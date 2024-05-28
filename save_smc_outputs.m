 %relative states

smc_time = out.ballistic.Time;

smc_mv_ballistic_leader = out.ballistic.Data(:,1);
smc_mv_ballistic_follower = out.ballistic.Data(:,2);

smc_plant_ballistic_leader = out.ballistic.Data(:,3);
smc_plant_ballistic_follower = out.ballistic.Data(:,4);

 %output sates
smc_a_rel      = out.states.Data(:,1)*a_leader;
smc_lambda_rel = out.states.Data(:,2)*a_leader;

%other states
smc_e_x =  out.states.Data(:,3);
smc_e_y =  out.states.Data(:,4);

smc_i_x =  out.states.Data(:,5);
smc_i_y =  out.states.Data(:,6);

