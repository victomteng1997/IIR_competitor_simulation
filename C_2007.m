%% step 1: Determine filter specifications:
n = 12;           %numerator order
m = 12;           %denominator order
num = ones(12,1);
den = zeros(12,1);
den(1) = 1;
radius = 0.999;
alpha = 0.999;          %this is a parameter which I need to think about. Don't know the physical meaning of this parameter
% assume we are doing a low pass filter (example 1 in the paper), given the
% weighted complex error in a vector form (Chooose 1000 sample points)
sam = 1000;
W = ones(1,sam);
for i = 201:250;
    W(i) = 0.1;
end
% idea frequency response D(w): here I choose a low pass filter with a
% passband of 0-0.2 pi, transition band from 0.2pi to 0.25 pi
D = zeros(1,sam);
for i = 1:200
    D(i) = 1;
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
while k < 51           %assume we are at the k th iteration
    k = k+1;
    [Q,w] = freqz(n,1,sam);
    for i = 1:1000
       W_k(i) = W(i)^2/(abs(Q(i)))^2;
    end
    % then get A_k (no head). Still, we choose 1000 sample points.
    A_k = 0;
    for i = 1:sam
        A_k = A_k + pi/1000*W_k(i)*real(c(:,i)*c(:,i)');
    end
    A_k_head = alpha*A_k+(1-alpha)*G_head;
end
