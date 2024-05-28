 %relative states

nmpc_time = out.tout;

nmpc_mv_ballistic_leader = out.ballistic.Data(:,1);
 nmpc_mv_ballistic_follower = out.ballistic.Data(:,2);

 nmpc_plant_ballistic_leader = out.ballistic.Data(:,3);
 nmpc_plant_ballistic_follower = out.ballistic.Data(:,4);

 %output sates
nmpc_a_rel      = out.states.Data(:,1)*a_leader;
nmpc_lambda_rel = out.states.Data(:,2)*a_leader;

%other states
nmpc_e_x =  out.states.Data(:,3);
nmpc_e_y =  out.states.Data(:,4);

nmpc_i_x =  out.states.Data(:,5);
nmpc_i_y =  out.states.Data(:,6);

