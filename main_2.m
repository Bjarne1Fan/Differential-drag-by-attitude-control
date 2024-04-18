%constants
%mu = 6.67*10^(-11);

G  = 6.6743 * 10^(-11);
earth_mass = 5.972 * 10^24;
mu = G*earth_mass;

%constant for now
mean_rho_500km = 7.30*10^(-13);
rho_follower = mean_rho_500km;
rho_leader   = mean_rho_500km;

m_f = 2;
m_l = 2;
A_l_min = 0.1;
A_f_min = 0.1;
A_l_max = 0.6;
A_f_max = 0.6;
C_d = 2.6;

B_f_min = 0.0130124908105961; (C_d*A_f_min)/m_f;
B_f_max = 0.0780749448635768; %(C_d*A_f_max)/m_f;

B_l_min = 0.0130124908105961; %(C_d*A_l_min)/m_l;
B_l_max = 0.0780749448635768; %(C_d*A_l_max)/m_l;


%initial conditions Orbit
earth_radi      = 6371*10^3; % 6371km
a_follower      = 500*10^3 + earth_radi; % 500 km
a_leader        = 500*10^3 + earth_radi;


M_leader        = 0.00002; % mean annomaly
M_follower      = 0; % mean annomaly

omega_leader    = 0; % argument of periapsis;
omega_follower  = 0; % argument of periapsis;

Omega_leader    = 0; % longitude of accending node
Omega_follower  = 0; % logidtude of accendng node

i_leader        = 20; % inclination
i_follower      = 20; % inclination

e_leader       = 0.01; %eccenticity
e_follower     = 0.01;  %eccentricity

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

x_f = [a_follower; u_follower; e_follower; i_follower];
x_f_prop = [a_follower; m_follower; e_follower; omega_follower; Omega_follower; i_follower];
x_l_prop = [a_leader; m_leader; e_leader; omega_leader; Omega_leader; i_leader];

d_a          = (a_follower - a_leader) / a_leader;
d_lambda     = u_follower - u_leader + (Omega_follower - Omega_leader)*cos(i_leader);
d_e_x        = e_follower*cos(omega_follower) - e_leader*cos(omega_leader);
d_e_y        = e_follower*sin(omega_follower) - e_leader*sin(omega_leader);
d_i_x        = i_follower - i_leader;
d_i_y        = (Omega_follower -Omega_leader)*sin(i_leader);
d_Ballistic  = (BC_follower - BC_leader)/BC_follower;

x = [d_a; d_lambda; d_e_x; d_e_y; d_i_x; d_i_y];

% Note singularity for orbit with 0 inclination

% Keplarian effects
A_kep = zeros(6,6);

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

A_j2 = k_j2 * [zeros(1,6);
               -7/2* E*P,    0,  e_x*G*F*P,  e_y*G*F*P,  -F*S,   0;
               (7/2)*e_y*Q,  0, -4*e_x*e_y*G*Q, -(1+4*G*e_y^2)*Q,   5*e_y*S,    0;
               (-7/2)*e_y*Q, 0,  (1+4*G*e_x^2)*Q, 4*e_x*e_y*G*Q,   -5*e_y*S,    0;
               zeros(1,6);
               (7/2)*S, 0,  -4*e_x*G*S, -4*e_y*G*S, 2*T,    0];


% Drag effects

% Veldig usikker på om det blir rett med a_leader her. Det må bekreftes
% nærmere, Dette blir litt rart

%accurate anyway
v_leader =  G*earth_mass/a_leader; %speed for circular orbit
B = [f(e_follower)*rho_follower*(x(1) + 1)/(1-e_follower) - f(e_leader)*rho_leader*(x(1) + 1)/(1-e_leader)
    0
    f(e_follower)*rho_follower*cos(omega_follower)
    f(e_leader)*rho_leader*cos(omega_leader)
    0
    0];
% u = \delta Ballistic coefficent


% Total dynamics
A_tot = A_kep + A_j2;
% A_drag should be taken out from here an included in the B matrix for
% proper simulation
% Need to figure out a smart method to include the annomally in the
% simulation, for know, could propigate M for both spacecrafts
%This should not complicate things too much


% Mean orbital Elemets
% Dont konw if this is needed, but needed if i want to recover the full
% orbits of each spacecraft


% Integrate system




function f = f(e)
    f = 1.61*10^4*e^0.02701 -1.61*10^4;
end


function dy = zin(t,y)
dy = zeros(3,1);    
dy(1) = 3*y(1)+y(2);
dy(2) = y(2)-y(1)+y(2).^4+y(3).^4;
dy(3) = y(2)+y(3).^4+3+y(2).^4;    
end

