open('system_model.slx');
mdl = bdroot;
set_param(mdl, 'SaveFinalState', 'on', 'FinalStateName',...
 [mdl 'SimState'],'SaveCompleteFinalSimState', 'on')
final_state = sim(mdl, [0 15]);

set_param(mdl, 'LoadInitialState', 'on', 'InitialState',...
[mdl 'SimState']);

system_modelSimState = final_state.system_modelSimState;

siminStates2 = Simulink.SimulationInput(mdl);
siminStates2 = setModelParameter(siminStates2,'StartTime','15','StopTime','25');
siminStates2 = setInitialState(siminStates2,system_modelSimState);
finalStates2 = sim(siminStates2);
%

%mdl = setInitialState(mdl,final_state.system_modelSimState);
%plot(t1,Y1,'b');

t2 = sim(mdl, [15 25]);
hold on; plot(t2,Y2,'r');
set_param(mdl, 'LoadInitialState', 'off');