
nx = 6; % Number of states - dim(x) state_func
ny = 2; % Number of outputs - dim(z) state_func
nu = 2; % Number of inputs  - dim(u) state_func
nlobj = nlmpc(nx,ny,nu);

% Use function name:        Model.StateFcn = 'myStateFunction'

%Specify the sample time and horizons of the controller.
nlobj.Ts                = 30;
nlobj.PredictionHorizon = 60;
nlobj.ControlHorizon    = 2;

% state function
nlobj.Model.StateFcn    = 'state_func';
nlobj.Model.IsContinuousTime = true;

nlobj.Model.NumberOfParameters = 5;
% see create parameter bus

% define output function
nlobj.Model.OutputFcn = @(x, u, a_f_nmpc, e_f_nmpc, i_f_nmpc, omega_f_nmpc, rho_f) [x(1); x(2)];

nlobj.States(1).Max = inf;
nlobj.States(1).Min = -inf;


x0 = [0 ; -2.00000000000000e-05 ; 0.001 ; 0.001; 0.001; 0.001];
u0 = [0.04; 0.04];
%x_f = [500*10^3; 2; 0.001 ; 0.001 ; 0.01 ; 0.01];
%x_f = [500*10^3; 2; 0.001 ; 0.001 ];
a_f_nmpc = 500*10^3; 
e_f_nmpc = 0.01;
i_f_nmpc = 0.01;
omega_f_nmpc = 0.01;
rho_f = 7.3e-13;

z = state_func(x0,u0, a_f_nmpc, e_f_nmpc, i_f_nmpc, omega_f_nmpc, rho_f);


validateFcns(nlobj, x0, u0, [], {a_f_nmpc; e_f_nmpc; i_f_nmpc; omega_f_nmpc; rho_f});

open('system_model.slx');
mdl = bdroot;
createParameterBus(nlobj, [mdl '/Nonlinear MPC Controller'],'BusObject',{a_f_nmpc; e_f_nmpc; i_f_nmpc; omega_f_nmpc; rho_f});





%OV = output variables



