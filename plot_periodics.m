close all;


 pos_f_ecef = out.follower_ecef_pos.Data;
 pos_l_ecef = out.leader_ecef_pos.Data;

 
 figure(1);

 plot(out.leader_ecef_pos.Time, pos_f_ecef);
 %hold on;

 %plot(out.leader_ecef_pos.Time, pos_l_ecef);

legend('$x$', '$y$', '$z$', 'Interpreter','latex');
title('ECEF coordinates for the leader satellite')
ylabel(' [m]')
xlabel('Time [s]')
grid on;
hold off;


 figure(2);

 plot(out.leader_ecef_pos.Time, pos_l_ecef-pos_f_ecef);
 hold on;

 plot(out.leader_ecef_pos.Time, vecnorm(pos_l_ecef-pos_f_ecef, 2, 2));

hold on;
sz = size(out.leader_ecef_pos.Time, 1);
ref_vec = ones(sz,1);
ref_vec = ref_vec * (20);
plot(out.states.Time, ref_vec);

legend('$x$', '$y$', '$z$', 'norm', 'ref', 'Interpreter','latex');
title('Relative distance between the spacecraft in ECEF')
ylabel('Relative distance [m]')
xlabel('Time [s]')
grid on;
hold off;

