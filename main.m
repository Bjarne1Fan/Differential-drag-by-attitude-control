%constants
mu = 6.67*10^(-11);
G  = 6.6743 * 10^(-11);
earth_mass = 5.972 * 10^24;

%initial conditions Orbit
earth_radi      = 6371*10^3; % 6371km
a_follower      = 500*10^3 + earth_radi; % 500 km
a_leader        = 500*10^3 + earth_radi;


M_leader        = 0; % mean annomaly
M_follower      = 0; % mean annomaly

omega_leader    = 0; % argument of periapsis;
omega_follower  = 0; % argument of periapsis;

Omega_leader    = 0; % longitude of accending node
Omega_follower  = 0; % logidtude of accendng node

i_leader        = 20; % inclination
i_follower      = 20; % inclination

e_leader       = 0.5; %eccenticity
e_follower     = 0.5;  %eccentricity

u_leader    = omega_leader + M_leader;
u_follower  = omega_follower + M_follower;

n_leader    = sqrt(mu/a_leader^3);   %mean angular motion
n_follower  = sqrt(mu/a_follower^3); %mean angular motion

%initial conditions satellites
m_follower = 1;
m_leader = 1;

C_d_leader   = 1;
C_d_follower = 1;

A_leader     = 1;
A_follower   = 1;

BC_leader    = m_leader / (C_d_leader*A_leader);
BC_follower  = m_follower / (C_d_follower*A_follower);

%V_rel_leader   = G*M/a_leader; %speed for circular orbit
%V_rel_follower = G*M/a_follower;






d_a          = (a_follower - a_leader) / a_leader;
d_lambda     = u_follower - u_leader + (Omega_follower - Omega_leader)*cos(i_leader);
d_e_x        = e_follower*cos(omega_follower) - e_leader*cos(omega_leader);
d_e_y        = e_follower*sin(omega_follower) - e_leader*sin(omega_leader);
d_i_x        = i_follower - i_leader;
d_i_y        = (Omega_follower -Omega_leader)*sin(i_leader);
d_Ballistic  = (BC_follower - BC_leader)/BC_follower;

x = [d_a; d_lambda; d_e_x; d_e_y; d_i_x; d_i_y; d_Ballistic];

% Note singularity for orbit with 0 inclination

% Keplarian effects

A_kep = zeros(7,7);
A_kep(1,1) = -(3/2)*n_leader;




% J2 effect
eta     = sqrt(1-e_leader^2);
J_2     =  1.08263 * 10^(-3);
k_j2    = (3/4) * (J_2 * earth_radi^2 * sqrt(mu))/(a_leader^(3.5)*eta^4);
e_x     = e_leader*cos(omega_leader);
e_y     = e_leader*sin(omega_leader);
E       = 1 + eta;
F       = 4 + 3*eta;
G       = 1/eta^2;
P       = 3* cos(i_leader)^2 - 1;
Q       = 5* cos(i_leader)^2 - 1;
S       = sin(2*i_leader);
T       = sin(i_leader)^2;

A_j2 = k_j2 * [zeros(1,7);
               -7/2* E*P,    0,  e_x*G*F*P,  e_y*G*F*P,  -F*S,   0,  0;
               (7/2)*e_y*Q,  0, -4*e_x*e_y*G*Q, -(1+4*G*e_y^2)*Q,   5*e_y*S,    0, 0;
               (-7/2)*e_y*Q, 0,  (1+4*G*e_x^2)*Q, 4*e_x*e_y*G*Q,   -5*e_y*S,    0, 0;
               zeros(1,7);
               (7/2)*S, 0,  -4*e_x*G*S, -4*e_y*G*S, 2*T,    0,  0;
               zeros(1,7)];


% Drag effects

% Veldig usikker på om det blir rett med a_leader her. Det må bekreftes
% nærmere, Dette blir litt rart
theta = 0.5; % TEMP. REMEBER To CHANGE THIS VALUE, I THINK THIS IS SUPPOSED TO REPRESENT TRUE ANOMALLY (the variational equation) An Introduction to the Mathematics and Methods of Astrodynamics
%Cold consider to replace this with the mean annomally. Will be more
%accurate anyway
v_leader =  G*earth_mass/a_leader; %speed for circular orbit
A_drag_vec = [2*a_leader^2 *v_leader /mu, 0, (2*(e_leader+cos(theta))/v_leader) *cos(omega_leader), (2*(e_leader+cos(theta))/v_leader) *sin(omega_leader), 0, 0, 0];
A_drag = [zeros(7,6), A_drag_vec'];


% Total dynamics

A_tot = A_kep + A_j2 + A_drag;
% A_drag should be taken out from here an included in the B matrix for
% proper simulation
% Need to figure out a smart method to include the annomally in the
% simulation, for know, could propigate M for both spacecrafts
%This should not complicate things too much


% Mean orbital Elemets
% Dont konw if this is needed, but needed if i want to recover the full
% orbits of each spacecraft



