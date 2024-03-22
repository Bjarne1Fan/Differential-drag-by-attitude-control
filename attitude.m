%Spacecraft parameters
J = eye(3);
w_0 = [1; 2; 1];
q_0 = [1; 0; 0; 1];
q_0 = q_0 /norm(q_0);



%Control law parameters
Kp = 5;
Kd = 5;
q_c = [0; 0; 0; 1];
E_qc = [q_c(4)  -q_c(3) q_c(2);
        q_c(3)  q_c(4)  -q_c(1);
        -q_c(2) q_c(1)  q_c(4);
        -q_c(1) -q_c(2) -q_c(3)];

%w_c always 0


starttime       = 1;
endtime         = 500;
timestep        = 0.1;
num_timesteps   = (endtime-starttime)/timestep;

q = q_0;
w = w_0;

%q_series
%w_series()

for step = (starttime):num_timesteps
    %Control law update
    dq_13 = E_qc' * q;
    dq_4  = q' * q_c;
    dq = [dq_13; dq_4];
    L = -Kp * dq_13 - Kd*w;

    %Simulate system
    y0 = [q; w];
    [t,y] = ode45(@(t,y) system_sim(t,y,J,L), [0, timestep], y0);
    q = y(end,1:4)';
    %q = q/norm(q);
    w = y(end,5:7)';
end

function dydt = system_sim(t,y,J, L)
  dydt = zeros(7,1);
  E_q = [y(4)  -y(3) y(2);
         y(3)  y(4)  -y(1);
        -y(2)  y(1)  y(4);
        -y(1) -y(2) -y(3)];

  q_dot = 0.5 * E_q * y(5:7);
  w_x = [0      -y(7)   y(6);
        y(7)    0      -y(5);
        -y(6)   y(5)    0];
  Jw_dot = -(w_x)*J*y(5:7) + L;
  w_dot = J^(-1) * Jw_dot;
   
  dydt = [q_dot; w_dot];
end
