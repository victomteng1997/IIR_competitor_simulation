function [solution] = mosek_optimizer(gamma, mu, den, B, x_k, sam, F_k, g_k)
    ita = sdpvar(26,1);
    left_omega = gamma*B*ita + B*x_k;
    left_constraint = [];
    for i = 1:sam
        left_constraint = [left_constraint; norm(left_omega(26*(i-1)+1:26*i))];
    end
    right_constraint = mu * abs(freqz(den,1,1000));
    Constraints = [left_constraint <= right_constraint, ita(1) == 0];
    Objective = objective2007(ita,F_k,g_k);
    % Set some options for YALMIP and solver
    options = sdpsettings('verbose',1,'solver','mosek');
    % Solve the problem
    sol = optimize(Constraints, Objective, options);
    % Analyze error flags
    if sol.problem == 0
     % Extract and display value
     solution = value(ita);
    else
     display('Hmm, something went wrong!');
     sol.info
     yalmiperror(sol.problem)
    end
end