function [a_m, e_m, i_m, Omega_m, omega_m, nu_m, M_m] = cart2kep(a, e, i, Omega, omega, nu, M)

    %% Osculating orbital elements to mean orbital elements
    gamma_2 = - (J_2/2)*(earth_radi/a)^2;
    
    netta = sqrt(1 -e^2);
    gamma_2_marked = gamma_2 / (netta^4);

    a_div_r = (1 + e*cos(nu) /netta^2 );

    a_m = a + gamma_2 *( ( 3*cos(i)^2 -1) * ( (a/r)^3 - 1/(netta^3) ) ) ...
        + 3*( 1 - cos(i)^2) * (a/r)^3*cos(2*omega +2*nu);
    
    de_1 = (gamma_2_marked/8) * e * netta^2 *( 1 - 11*cos(i)^2 - 40* (cos(i) / (1-5*cos(i)^2) ) ) * cos(2*omega);
    de   = de_1 + (netta^2/2) * (gamma_2 * ( ( 3*cos(i)^2-1)/(netta^6)  * (e*netta + (e/(1+netta)) + 3*cos(nu) + 3 *e*cos(nu)^2 + e^2*cos(nu)^3 )  + ...
        3*( (1-cos(i)^2)/(netta^6) )* (e + 3*cos(nu) + 3*e*(cos(nu)^2) + e^2*cos(nu^3) )* cos(2*omega + 2*nu) ) - gamma_2_marked*( 1-cos(i)^2)*(3*cos(2*omega+nu)) + cos(2*omega + 3*nu) );

    di = - (e*de_1)/(netta^2*tan(i)) + (gamma_2_marked/2) *cos(i)*sqrt(1-cos(i)^2)*(3*cos(2*omega+2*nu) + 3*e*cos(2*omega+nu) + e*cos(2*omega+3*nu));
    
    %not quite lambda 
    lambda_marked = M + omega + Omega + (gamma_2_marked/8)*netta^3 * (1 - 11*cos(i)^2 - 40*( cos(i_leader^4)/(1- 5 *cos(i)^2) ) ) - ...
        gamma_2_marked/16 *( 2 + e^2 -11*(2+3*e^2)*cos(i)^2 -40*(2+5*e^2)* (cos(i)^4/(1-5*cos(i)^2)) -400*e^2*(cos(i)^6/(1-5*cos(i)^2)^2)) ...
        + gamma_2_marked/8 * e^2 *cos(i)*( 11 + 80 * (cos(i)^2/(1-5*cos(i)^2)) + 200* (cos(i)^4)/(1-5*cos(i)^2)^2) ...
        -gamma_2_marked/2 * cos(i)*(6* (nu-M+e*sin(nu)) -3*sin(2*omega+2*nu) -3*e*sin(2*omega+nu) - e*sin(2*omega+3*nu));

    
    
end