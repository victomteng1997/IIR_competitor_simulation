function [ result ] = objective2007( x, F_k, g_k)
% The objective function for paper 2007
% Objective function solved by fmincon solver.
result = norm(F-k*x+g_k);

end

