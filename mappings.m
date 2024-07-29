
a = 500*10^3;
theta = 100* (pi/180);
e = 0.01;
i = 20* (pi/180);
w = 25 *(pi/180);
u = w + theta;
netta = sqrt(1 - e^2);
a_div_r = (1 + e*cos(theta)) /netta^2 ;

r = a/a_div_r;


dx_lvlh   = [1/a,  (a*e*sin(theta))/(r*sqrt(1-e^2)), 0 -a/r*cos(theta), 0, 0;
            0,      (a^2*netta)/r^2, 1, (a/r + (1/(1-e^4)))*sin(theta), 0, cos(i);
            0, 0, 0, 0, sin(u), -sin(i)*cos(u);
            zeros(3,6)];

d_delta_OE = [a, 0, 0, 0, 0, 0;
              0, 1, sin(w)/e, -cos(w)/e, 0, cos(i)/sin(i);
              0, 0, -sin(w)/e, cos(w)/e, 0, 0;
              0, 0, cos(w), sin(w), 0, 0;
              0, 0, 0, 0, 1, 0;
              0, 0, 0, 0, 0, sin(i)];

T = dx_lvlh * d_delta_OE;

x_lvlh = [0; 0; 0; 0; 0.1; 0;];

T_inv = pinv(T);

d_a = T_inv * x_lvlh;


o_1 = -r_i/norm(r_i);
o_3 = -cross(r_i,v_i)