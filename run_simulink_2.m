modelName = 'system_model';


timestep_sim_pause = 10;
sim_end_time       = 1000;

%siminStates1 = Simulink.SimulationInput(modelName);
siminStates = Simulink.SimulationInput(modelName);

for t = 0:timestep_sim_pause:sim_end_time
    start_time = t;
    stop_time  = t + timestep_sim_pause;

    siminStates = setModelParameter(siminStates,'StartTime', int2str(start_time),'StopTime',int2str(stop_time),...
    'SaveFinalState','on');

    finalStates = sim(siminStates);
    siminStates = setInitialState(siminStates,finalStates.system_modelSimState);

end


% siminStates1 = setModelParameter(siminStates1,'StartTime','0','StopTime','5',...
%     'SaveFinalState','on');
% 
% finalStates1 = sim(siminStates1);
% siminStates2 = Simulink.SimulationInput(modelName);
% 
% siminStates2 = setModelParameter(siminStates2,'StartTime','5','StopTime','10');
% 
% siminStates2 = setInitialState(siminStates2,finalStates1.system_modelSimState);
% 
% finalStates2 = sim(siminStates2);
% 
% %finalStatesResults = finalStates1.logsout;