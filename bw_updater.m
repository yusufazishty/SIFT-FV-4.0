function [w_new,b_new] = bw_updater(w, b, gamma, yij, psi)
    w_new = w - gamma*yij*w*psi;
    b_new = b + gamma*yij*b;
end