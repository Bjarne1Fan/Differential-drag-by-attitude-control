function [B_l, B_f, theta_l_d, theta_f_d] = ballistic_to_theta(B_l, B_f, m_f, m_l, B_f_max, B_l_max, B_f_min, B_l_min)
%DRAGTOATTITUDE Summary of this function goes here
%   Detailed explanation goes here
% 
% C_d = 2.5;
% C_d_l = C_d;
% C_d_f = C_d;

%Polinomial that represents A_ref*C_d at theta [0.pi/2]
%p = [40.01, -411.74, 327.3, 1173.96, 261.12];
    p  = [0.00400120687442500	-0.0411735422456600	0.0327337954545250	0.117396192785134	-0.0678880815497270];
    
    % B_max = 0.081
    % B_min = 0.0130
    %
    theta_l_d = 0;
    theta_f_d = 0;

%Seperate function based on sign of rel_accel

   % B_l = (A_l_min*C_d_l)/ m_l; % must be updated to include the spesific drag coefficent at C_d_0
    
    %B_f = abs(u) + B_l;
    if B_f > B_f_max
        B_f = B_f_max;
    end
    if B_l > B_l_max
        B_l = B_l_max;
    end
    
    Cd_x_A_f = B_f * m_f; % inverse Ballistic coefficent
    % find pitch angle from Cd_x_A_f
    p(5) = p(5) - Cd_x_A_f; % move root to f(theta) = cd_x_A_f
    r = roots(p);
    theta_f_d = select_root(r, 0, pi/2);

    %B_f = (A_f_min*C_d_f)/m_f; % must be updated to include the spesific drag coefficent at C_d_0
    
    %B_l = abs(u) + B_f;
    p  = [0.00400120687442500	-0.0411735422456600	0.0327337954545250	0.117396192785134	-0.0678880815497270];
    
    Cd_x_A_l = B_l * m_l; % Inverse ballistic coefficent
    % find pitch angle from Cd_x_A_l
    p(5) = p(5) - Cd_x_A_l; % move root to f(theta) = cd_x_A_f
    r = roots(p);
    theta_l_d = select_root(r, 0, pi/2);

    
end


function root = select_root(roots, lower_bound, upper_bound)
    %extract values that are within the inteval
    root = [];
    sz = size(roots,1);
    for row = 1:sz
        val = roots(row);
        if val > lower_bound && val < upper_bound && isreal( val )
            root(end+1) = val;
        end

    end
    if size(root)[2] > 1
        root_index = min(root);
        root = root(root_index);
    end
    
    sz = size(root,2);
    if size(root,2) < 1
        root = 0; % if no suitable root is found, then the angle could be assumed to be 0 deg
    end
    temp = root(1);
    root = temp;

end
