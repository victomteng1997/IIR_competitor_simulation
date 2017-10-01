n = 12;           %numerator order (N = 12)
m = 12;           %denominator order
gama = 0.8;
e = 10^(-6);
num = ones(n+1,1);
den = zeros(m+1,1);
den(1) = 1;
radius = 0.999;
alpha = 0.9999;          %this is a parameter which I need to think about. Don't know the physical meaning of this parameter
% assume we are doing a low pass filter (example 1 in the paper), given the
% weighted complex error in a vector form (Chooose 1000 sample points)
syms w
W = heaviside(w);
D = heaviside(w)-heaviside(w-0.2*pi);
phi2w =[] ;
for k = 1:m+1
    phi2w = [phi2w;(exp(1i*w))^-k];
end
phi1w =[];
for k = 1:n+1
    phi1w = [phi1w;(exp(1i*w))^-k];
end
c = [D*phi2w;-phi1w];
k = 0;

while k <= 200
    k = k+1;
    Q_k = norm(transpose(phi2w)*den)^2;
    W2_k = W^2/Q_k;
    fun = W2_k*real(c*c');
    B = (real(c*c'))^0.5;
end