function [dw_theta, theta_diff] = dw(theta_i, theta_j, w)
    theta_diff = theta_i - theta_j;
    dw_theta = sqrt(theta_diff'*(w'*w)*theta_diff);
end