
nx = 6; % Number of states - dim(x) state_func
ny = 6; % Number of outputs - dim(z) state_func
nu = 2; % Number of inputs  - dim(u) state_func
nlobj = nlmpc(nx,ny,nu);

% Use function name:        Model.StateFcn = 'myStateFunction'

%Specify the sample time and horizons of the controller.
nlobj.Ts                = 20;
nlobj.PredictionHorizon = 20;
nlobj.ControlHorizon    = 2;

% state function
nlobj.Model.StateFcn    = 'state_func';
nlobj.Model.IsContinuousTime = true;

nlobj.Model.NumberOfParameters = 2;
% see create parameter bus

% define output function
%nlobj.Model.OutputFcn = @(x,u, x_f, rho) [x(1); x(2); x(3); x(4)];



x0 = [0 ; -2.00000000000000e-05 ; 0.001 ; 0.001; 0.001; 0.001];
u0 = [0.04; 0.04];
%x_f = [500*10^3; 2; 0.001 ; 0.001 ; 0.01 ; 0.01];
x_f = [500*10^3; 2; 0.001 ; 0.001 ];
rho = 7.3e-13;

z = state_func(x0,u0, x_f, rho);


validateFcns(nlobj, x0, u0, [], {x_f, rho});

open('system_model.slx');
mdl = bdroot;
createParameterBus(nlobj, [mdl '/Nonlinear MPC Controller'],'BusObject',{x_f, rho});




%OV = output variables



