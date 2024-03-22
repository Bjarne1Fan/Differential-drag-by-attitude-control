num_points = 10 + 9 ;


%C_d control check

mu = 13/ 26.98; % ratio of Nitrogen to Aliminnium
alpha_teoretical = (4*mu)/(1+mu)^2*(cos(pi/4))^2; %

alpha = (7.5*10^(-17)*2.03*10^7*10^6*938)/ (1+ (7.5*10^(-17)*2.03*10^7*10^6*938)); % for NRLSMIE-00 model

alpha = 0.65;
r = sqrt(1-alpha);

%flat plate normal flow
C_d_flat90 = 2*(1+(2/3)*r);

C_d_vec   = zeros(num_points,1);
theta_vec = zeros(num_points,1);
A_ref_tot_vec = zeros(num_points,1);

deg_in_iteration = 90 / num_points -1 ;

for c = 1:num_points

    theta = (5*(pi/180))*(c-1); %pitch of satellite
    
    
    gamma = cos(theta);
    l = sin(theta);
    G = 1/(2*s^2);

    dC_d = (P/sqrt(pi)) + gamma * Q *Z + (gamma/2) * (v_r_v_inf)*(gamma*sqrt(pi)*Z + P);


    %flat plate at incidence theta
    C_d_flat_theta = 2*(1+(2/3)*r*sin(theta));
    C_d_flat_theta_inv = 2*(1+(2/3)*r*sin(pi/2-theta));
    
    % portion of total area as A_ref
    
    %Areas
    %2 solar panels
    A_tot_solar = 2*15*15;
    A_ref_solar = A_tot_solar*sin(theta);
    
    %box (front and upper side)
    A_tot_box_front = 10*10;
    A_tot_box_top = 15*10;
    
    A_ref_box_front = A_tot_box_front*cos(theta);
    A_ref_box_top   = A_tot_box_top*sin(theta);
    
    
    A_ref_tot = A_ref_solar + A_ref_box_top + A_ref_box_front;
    
    %Total drag coefficent
    C_d_total = (A_ref_box_front/A_ref_tot)* C_d_flat_theta_inv + ((A_ref_tot-A_ref_box_front)/A_ref_tot)* C_d_flat_theta;
    C_d_vec(c)   = C_d_total;
    theta_vec(c) = theta;
    A_ref_tot_vec(c) = A_ref_tot;

end
figure(1);
plot(theta_vec*180/pi, C_d_vec);
title("Drag coefficent for different pitch angles")
grid on;
xlabel('Pitch angle [°]') 
ylabel('Drag coefficent') 

figure(2);
plot(theta_vec*180/pi, A_ref_tot_vec);
title("Area for different pitch angles")
grid on;
xlabel('Pitch angle [°]') 
ylabel('Area [cm^2]') 


