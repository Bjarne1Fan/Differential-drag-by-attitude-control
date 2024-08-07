close all;

earth_radi      = 6371*10^3; % 6371km
a               = 500*10^3 + earth_radi; % 500 km

G  = 6.6743 * 10^(-11);
earth_mass = 5.972 * 10^24;
mu = G*earth_mass;

T = 2*pi*sqrt(a^3/mu); % orbital period


 %ballisitc = out.ballistic;
 %mv_ballistic_leader = out.ballistic.Data(:,1);
 %mv_ballistic_follower = out.ballistic.Data(:,2);

 %plant_ballistic_leader = out.ballistic.Data(:,3);
 %plant_ballistic_follower = out.ballistic.Data(:,4);

 figure(1);

 plot(nmpc_time/ T, nmpc_mv_ballistic_leader);
 hold on;

 plot(nmpc_time/ T, nmpc_mv_ballistic_follower);

legend('NMPC $\beta_l$', 'NMPC $\beta_f$','Interpreter','latex');
title('Ballistic coeficcent from NMPC')
ylabel('Ballistic coefficent in [m^2/kg]')
xlabel('Orbits')
grid on;
hold off;


 figure(2);

 plot(nmpc_time/ T, nmpc_plant_ballistic_leader);
 hold on;

 plot(nmpc_time/ T, nmpc_plant_ballistic_follower);

legend('NMPC $\beta_l$', 'NMPC $\beta_f$','Interpreter','latex');
title('Ballistic coeficcent from attitude system')
ylabel('Ballistic coefficent in [m^2/kg]')
xlabel('Orbits')
grid on;
hold off;


figure(3);

%a_rel      = out.states.Data(:,1)*a_leader;
%lambda_rel = out.states.Data(:,2)*a_leader;


plot(nmpc_time/ T, nmpc_a_rel);
hold on;
plot(smc_time/ T, smc_a_rel);

legend('NMPC $\delta a \cdot a_l$', 'SMC $\delta a \cdot a_l$', 'Interpreter','latex');
title('Relative semi-major-axis')
ylabel('Relative distance in [m]')
xlabel('Orbits')
grid on;
hold off;

figure(4);

plot(nmpc_time/ T, nmpc_lambda_rel);
hold on;
plot(smc_time/ T, smc_lambda_rel);

sz = size(nmpc_lambda_rel, 1);
ref_vec = ones(sz,1);
ref_vec = ref_vec * (-20);
plot(nmpc_time/T, ref_vec);

legend('NMPC $\delta \lambda \cdot a_l$', 'SMC $\delta \lambda \cdot a_l$', '$\lambda_{ref} \cdot a_l$','Interpreter','latex');
title('Relative mean argument of longitude')
ylabel('Relative distance in [m]')
xlabel('Orbits')
grid on;
hold off;





 figure(5);

 plot(smc_time/ T, smc_mv_ballistic_leader);
 hold on;

 plot(smc_time/ T, smc_mv_ballistic_follower);

legend('SMC $\beta_l$', '$SMC \beta_f$','Interpreter','latex');
title('Ballistic coeficcent from SMC')
ylabel('Ballistic coefficent in [m^2/kg]')
xlabel('Orbits')
grid on;
hold off;


 figure(6);

 plot(smc_time/ T, smc_plant_ballistic_leader);
 hold on;

 plot(smc_time/ T, smc_plant_ballistic_follower);

legend('SMC $\beta_l$', 'SMC $\beta_f$','Interpreter','latex');
title('Ballistic coeficcent from attiutude system')
ylabel('Ballistic coefficent in [m^2/kg]')
xlabel('Orbits')
grid on;
hold off;