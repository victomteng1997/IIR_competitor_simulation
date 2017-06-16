% here we also start with a low pass filter:

%% We can assume a prescribed group delay value based on our experiment
% Firstly generate the fir filter
f = [0 0.3 0.4 0.6 0.7 1];                   %a passband of 0.4-0.6
a = [0 0.0 1.0 1.0 0.0 0];
b = firpm(39,f,a,[30,1,30]);


% Then plot the hankel singular value
matrix = Hankel(b);
[v,d] = eig(matrix);
singular_value = abs(d);
dim = size(singular_value);
% Get the proper order k
order = zeros(1,dim(1));
for i = 1:dim(1)
    order(i) = singular_value(i,i);
end
order = sort(order);
s = sum(order);
for i = 1:length(order)
    if sum(order(1:i)) >0.02*s       % here I assume 0.02 is a value that is insignificent
        k = i;
        break
    end
end
k = length(order)-k;   %this is the reduced order

% Now get state space representation
truncated = zeros(k,k);
for i = 1:k
    truncated(i,i) = order(length(order)-i+1);
end
n = dim(1);
A_t = v(2:n,1:k)'*v(1:n-1,1:k);
B_t = v(1,1:k)';
C_t = v(1,1:k)*truncated;
D = 0;
%then generate iir
[b,a] = ss2tf(A_t,B_t,C_t,D);

%% 