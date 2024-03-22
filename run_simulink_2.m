modelName = 'system_model';

siminStates1 = Simulink.SimulationInput(modelName);
siminStates1 = setModelParameter(siminStates1,'StartTime','0','StopTime','5',...
    'SaveFinalState','on');

finalStates1 = sim(siminStates1);
siminStates2 = Simulink.SimulationInput(modelName);

siminStates2 = setModelParameter(siminStates2,'StartTime','5','StopTime','10');

siminStates2 = setInitialState(siminStates2,finalStates1.system_modelSimState);

finalStates2 = sim(siminStates2);

%finalStatesResults = finalStates1.logsout;