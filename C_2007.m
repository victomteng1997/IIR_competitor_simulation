%% step 1: Determine filter specifications:
m = 12;           %numerator order
n = 12;           %denominator order
num = ones(12,1);
den = zeros(12,1);
den(1) = 1;
radius = 0.999;
alpha = 0.999;          %this is a parameter which I need to think about. Don't know the physical meaning of this parameter
% assume we are doing a low pass filter (example 1 in the paper), given the
% weighted complex error in a vector form (Chooose 1000 sample points)
W = ones(1,1000);

k = 0;
W_k = zeros(1,1000);
while k < 51           %assume we are at the k th iteration
    k = k+1;
    [Q,w] = freqz(n,1,1000);
    for i = 1:1000
       W_k(i) = W(i)^2/(abs(Q(i)))^2;
    end
end
