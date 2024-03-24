%% Startup connection

app = actxserver('STK12.application');
root = app.Personality2;


%%
scenario = root.Children.New('eScenario','MATLAB_PredatorMission');
scenario.SetTimePeriod('24 Feb 2020 16:00:00.000','25 Feb 2020 16:00:00.000');
scenario.StartTime = '24 Feb 2020 16:00:00.000';
scenario.StopTime = '25 Feb 2020 16:00:00.000';
root.ExecuteCommand('Animate * Reset');

%% Adding objects
satellite = scenario.Children.New('eSatellite','LeoSat');

keplerian = satellite.Propagator.InitialState.Representation.ConvertTo('eOrbitStateClassical');
%keplerian.SizeShapeType = 'eSizeShapeAltitude'; % perigee and apogee height insteand of a and e
keplerian.LocationType = 'eLocationTrueAnomaly';
%keplerian.Orientation.AscNodeType = 'eAscNodeLAN';

keplerian.SizeShape.SemiMajorAxis = earth_radi+ 500*10^3;
keplerian.SizeShape.Eccentricity  = 0.1;
keplerian.Orientation.Inclination = 20;
keplerian.Orientation.ArgOfPerigee = 90;
keplerian.Orientation.AscNode.Value     = 10;
keplerian.Location.Value = 0;
%keplerian.SizeShape.PerigeeAltitude = 500.1;
%keplerian.SizeShape.ApogeeAltitude = 550.1;
%keplerian.Orientation.Inclination = 20;
%keplerian.Orientation.ArgOfPerigee = 0;
%keplerian.Orientation.AscNode.Value = 245;
%keplerian.Location.Value = 180;
satellite.Propagator.InitialState.Representation.Assign(keplerian);
% satellite.Propagator.Propagate;




%%
% IAgSatellite satellite: Satellite object
satellite.SetPropagatorType('ePropagatorHPOP'); %Set satellite object propegator to HPOP

%set perturbation spesific settings, should be constant
forceModel = satellite.Propagator.ForceModel;
forceModel.CentralBodyGravity.File = 'C:\Program Files\AGI\STK 12\STKData\CentralBodies\Earth\WGS84_EGM96.grv';
forceModel.CentralBodyGravity.MaxDegree = 21;
forceModel.CentralBodyGravity.MaxOrder = 21;
forceModel.Drag.Use=1;
forceModel.Drag.DragModel.Cd=2.2;
forceModel.Drag.DragModel.AreaMassRatio=0.03;
forceModel.SolarRadiationPressure.Use=0;

%Set integrator spesific settings, Should be constant
integrator = satellite.Propagator.Integrator;
integrator.DoNotPropagateBelowAlt=-1e6;
integrator.IntegrationModel=3;
integrator.StepSizeControl.Method=1;
integrator.StepSizeControl.ErrorTolerance=1e-13;
integrator.StepSizeControl.MinStepSize=0.1;
integrator.StepSizeControl.MaxStepSize=30;
integrator.Interpolation.Method=1;
integrator.Interpolation.Order=7;




%% Run
satellite.Propagator.Propagate();




% %% Extract data
% root.UnitPreferences.Item('DateFormat').SetCurrentUnit('EpSec');
% satPosDP = satellite.DataProviders.Item('Cartesian Position').Group.Item('ICRF').Exec(scenario.StartTime,scenario.StopTime,60);
% satx = cell2mat(satPosDP.DataSets.GetDataSetByName('x').GetValues);
% saty = cell2mat(satPosDP.DataSets.GetDataSetByName('y').GetValues);
% satz = cell2mat(satPosDP.DataSets.GetDataSetByName('z').GetValues);


%% Extract data test
root.UnitPreferences.Item('DateFormat').SetCurrentUnit('EpSec');
satPosDP = satellite.DataProviders.Item('Classical Elements').Group.Item('ICRF').Exec(scenario.StartTime,scenario.StartTime+1,1);
sat_true_anomally = cell2mat(satPosDP.DataSets.GetDataSetByName('True Anomaly').GetValues);
sat_mean_anomally = cell2mat(satPosDP.DataSets.GetDataSetByName('Mean Anomaly').GetValues);
sat_semi_major_axis = cell2mat(satPosDP.DataSets.GetDataSetByName('Semi-major Axis').GetValues);
sat_inclination = cell2mat(satPosDP.DataSets.GetDataSetByName('Inclination').GetValues);
sat_RAAN = cell2mat(satPosDP.DataSets.GetDataSetByName('RAAN').GetValues);
sat_Arg_of_Perigee= cell2mat(satPosDP.DataSets.GetDataSetByName('Arg of Perigee').GetValues);
 sat_Eccentricity= cell2mat(satPosDP.DataSets.GetDataSetByName('Eccentricity').GetValues);


%% Update ballistic coefficent
%initial state must be updated to be the endpoint of the last timestep
%keplerian = satellite.Propagator.InitialState.Representation.ConvertTo('eOrbitStateClassical');
keplerian.SizeShape.SemiMajorAxis = sat_semi_major_axis(1);
keplerian.SizeShape.Eccentricity  = sat_Eccentricity(1);
keplerian.Orientation.Inclination = sat_inclination(1);
keplerian.Orientation.ArgOfPerigee = sat_Arg_of_Perigee(1);
keplerian.Orientation.AscNode.Value     = sat_RAAN(1);
keplerian.Location.Value = sat_true_anomally(1);
%keplerian.AssignClassical()
%keplerian.OrbitStateType
forceModel.Drag.DragModel.Cd=2.2;
forceModel.Drag.DragModel.AreaMassRatio=0.03;
%keplerian.AssignClassical('ICRF', 6870000, 0.1, 20, 90, 0, 0);
satellite.Propagator.InitialState.Representation.Assign(keplerian);
satellite.Propagator.Propagate();

