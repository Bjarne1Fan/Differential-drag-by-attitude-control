% Drag coefficent and reference area plotting


C_d = [4.72 2.96 2.63 2.69 2.74 2.84 2.90 2.98 2.99 3.07];

num_points = 10;

deg_in_iteration = 90 / num_points -1 ;
theta_vec = zeros(num_points, 1);

for c = 1:num_points

    theta = (10*(pi/180))*(c-1); %pitch of satellite
    theta_vec(c) = theta;
    
end

figure(3);
plot(theta_vec*180/pi, C_d);
title("Drag coefficent for different pitch angles")
grid on;
xlabel('Pitch angle [°]') 
ylabel('Drag coefficent') 