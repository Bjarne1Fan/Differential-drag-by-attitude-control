modelName = 'system_model';


timestep_sim_pause = 10;
sim_end_time       = 1000;

%siminStates1 = Simulink.SimulationInput(modelName);
siminStates = Simulink.SimulationInput(modelName);

app = actxserver('STK12.application');
root = app.Personality2;

%config stk global
scenario = root.Children.New('eScenario','Differential_drag_sim');
scenario.SetTimePeriod('24 Feb 2020 16:00:00.000','25 Feb 2020 16:00:00.000');
scenario.StartTime = '24 Feb 2020 16:00:00.000';
scenario.StopTime = '25 Feb 2020 16:00:00.000';
root.ExecuteCommand('Animate * Reset');

% add leader satellite 
sat_l = scenario.Children.New('eSatellite','LeoSat_leader');



% add follower satellite 
sat_f = scenario.Children.New('eSatellite','LeoSat_follower');




% Setting propegator for the satellites
% IAgSatellite satellite: Satellite object
sat_l.SetPropagatorType('ePropagatorHPOP'); %Set satellite object propegator to HPOP

%set perturbation spesific settings, should be constant
forceModel = sat_l.Propagator.ForceModel;
forceModel.CentralBodyGravity.File = 'C:\Program Files\AGI\STK 12\STKData\CentralBodies\Earth\WGS84_EGM96.grv';
forceModel.CentralBodyGravity.MaxDegree = 21;
forceModel.CentralBodyGravity.MaxOrder = 21;
forceModel.Drag.Use=1;
forceModel.Drag.DragModel.Cd=2.2;
forceModel.Drag.DragModel.AreaMassRatio=0.03;
forceModel.SolarRadiationPressure.Use=0;

%Set integrator spesific settings, Should be constant
integrator = sat_l.Propagator.Integrator;
integrator.DoNotPropagateBelowAlt=-1e6;
integrator.IntegrationModel=3;
integrator.StepSizeControl.Method=1;
integrator.StepSizeControl.ErrorTolerance=1e-13;
integrator.StepSizeControl.MinStepSize=0.1;
integrator.StepSizeControl.MaxStepSize=30;
integrator.Interpolation.Method=1;
integrator.Interpolation.Order=7;


% IAgSatellite satellite: Satellite object
sat_f.SetPropagatorType('ePropagatorHPOP'); %Set satellite object propegator to HPOP

%set perturbation spesific settings, should be constant
forceModel = sat_f.Propagator.ForceModel;
forceModel.CentralBodyGravity.File = 'C:\Program Files\AGI\STK 12\STKData\CentralBodies\Earth\WGS84_EGM96.grv';
forceModel.CentralBodyGravity.MaxDegree = 21;
forceModel.CentralBodyGravity.MaxOrder = 21;
forceModel.Drag.Use=1;
forceModel.Drag.DragModel.Cd=2.2;
forceModel.Drag.DragModel.AreaMassRatio=0.03;
forceModel.SolarRadiationPressure.Use=0;

%Set integrator spesific settings, Should be constant
integrator = sat_f.Propagator.Integrator;
integrator.DoNotPropagateBelowAlt=-1e6;
integrator.IntegrationModel=3;
integrator.StepSizeControl.Method=1;
integrator.StepSizeControl.ErrorTolerance=1e-13;
integrator.StepSizeControl.MinStepSize=0.1;
integrator.StepSizeControl.MaxStepSize=30;
integrator.Interpolation.Method=1;
integrator.Interpolation.Order=7;

% Assign orbit
kep_leader = sat_l.Propagator.InitialState.Representation.ConvertTo('eOrbitStateClassical');
kep_leader.LocationType = 'eLocationTrueAnomaly';

kep_leader.SizeShape.SemiMajorAxis = earth_radi/10^3+ 500;
kep_leader.SizeShape.Eccentricity  = 0.01;
kep_leader.Orientation.Inclination = 20;
kep_leader.Orientation.ArgOfPerigee = 90;
kep_leader.Orientation.AscNode.Value     = 10;
kep_leader.Location.Value = 0;
sat_l.Propagator.InitialState.Representation.Assign(kep_leader);

kep_f = sat_f.Propagator.InitialState.Representation.ConvertTo('eOrbitStateClassical');
kep_f.LocationType = 'eLocationTrueAnomaly';

kep_f.SizeShape.SemiMajorAxis = earth_radi/10^3+ 500;
kep_f.SizeShape.Eccentricity  = 0.01;
kep_f.Orientation.Inclination = 20;
kep_f.Orientation.ArgOfPerigee = 90;
kep_f.Orientation.AscNode.Value     = 10;
kep_f.Location.Value = 90;
sat_f.Propagator.InitialState.Representation.Assign(kep_f);



% Propegate the satellites
sat_l.Propagator.Propagate();
sat_f.Propagator.Propagate();



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