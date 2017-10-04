%% step 1: Determine filter specifications:
n = 12;           %numerator order (N = 12)
m = 12;           %denominator order
gamma = 0.8;
e = 10^(-6);
num = ones(n+1,1);
den = zeros(m+1,1);
den(1) = 1;
radius = 0.999;
alpha = 0.9999;          %this is a parameter which I need to think about. Don't know the physical meaning of this parameter
% assume we are doing a low pass filter (example 1 in the paper), given the
% weighted complex error in a vector form (Chooose 1000 sample points)
sam = 1000;
W = ones(1,sam);
for i = 400:600;
    W(i) = 0.01;
end
% idea frequency response D(w): here I choose a low pass filter with a
% passband of 0-0.2 pi, transition band from 0.2pi to 0.25 pi
D = zeros(1,sam);
for i = 1:200
    D(i) = exp(1j*pi*i/1000);
end
k = 0;
W_k = zeros(1,sam);
c = zeros(m+n+2,sam);
for i = 1:sam
    phi1 = ones(n+1,1);
    phi2 = ones(m+1,1);
    for count = 2:m+1
        phi2(count) = exp(1i*pi/sam)^(-count);
    end
    for count = 1:n
        phi1(count) = exp(1i*pi/sam)^(-count);
    end
    c(1:m+1,i) = D(i)*phi2;
    c(m+2:m+n+2,i) = -phi1;
end

%% Step 2: start the loop
while k < 200           %assume we are at the k th iteration
    k = k+1;
    [Q,w] = freqz(den,1,sam);
    for i = 1:1000
       W_k(i) = W(i)^2/(abs(Q(i)))^2;
    end
    % then get A_k (no head). Still, we choose 1000 sample points.
    A_k = 0;
    for i = 1:sam
        A_k = A_k + pi/1000*W_k(i)*real(c(:,i)*c(:,i)');
    end
    diag_matrix = zeros(m+1,m+1);
    for i = 1:m
        diag_matrix(i+1,i+1) = i;
    end
    G = 0;
    for i = 1:sam                   %to get integration from zero to pi.
        phi2r = ones(m+1);
        for count = 2:m+1
            phi2r(count) = exp(radius*1i*pi/sam)^(-count);
        end
        psi = real(phi2r*phi2r');
        Qr = 0;
        for t = 1:m+1
           Qr = Qr + den(t)*(radius*exp(1i*pi/1000*i))^(-(t-1)); 
        end
        G = G + diag_matrix*psi/abs(Qr)^2*pi/sam;
        G_head = [G, zeros(m+1,n+1); zeros(n+1,m+1), zeros(n+1,n+1)];
    end
    A_k_head = alpha*A_k+(1-alpha)*G_head;
    %calculate B here.
    B = real(c(:,1)*c(:,1)')^0.5;
    for p = 2:sam
        B = [B ;(real(c(:,p)*c(:,p)')^0.5)];
    end
    % c = c(:);
    F_k = gamma*(A_k_head)^0.5;
    x_k = [den;num];
    g_k = A_k_head^0.5*x_k;
    mu = 0.1;

    %solve (13) with constrain (18);
%     best_x = fmincon(@(x) objective2007(x,F_k,g_k), initial, B, c) %need to solve the constraint problem here; discuss it later.
    disp(k);
    disp(x_k);
    ita = mosek_optimizer(gamma, mu, den, B, x_k, sam, F_k, g_k);
    num = num + ita(1:13);
    den = den + ita(14:26);
    disp(ita);
    x_k = [den;num];

end
