% here we also start with a low pass filter:

%% We can assume a prescribed group delay value based on our experiment, generate the iir filter
% Firstly generate the fir filter
f = [0 0.2 0.3 0.65 0.8 1];                   %a passband of 0.4-0.6
a = [0 0.0 1.0 1.0 0.0 0];
b = firpm(39,f,a,[30,1,30]);
len = length(b);
a = zeros(1,len);
a(1) = 1;
sys = tf(b,a,0.05);
GRED = balancmr(sys);
es = 0.01; %stability margin
tau = 15;

A_t = GRED.A;
B_t = GRED.B;
C_t = GRED.C;
D = GRED.D;
%then generate iir
[a,b] = ss2tf(A_t,B_t,C_t,D);     %a, b are numerators and denominators ( a very special case here, the author use a as num and b as den)
[h,w] = freqz(a,b,'whole',2001);
plot(w/pi,20*log10(abs(h)))
xlabel('Normalized Frequency (\times\pi rad/sample)')
ylabel('Magnitude (dB)')
%% Second part: Do optimization
c = [a,b];
c = transpose(c);
k = 0;
while k < 200
    k = k+1;
    x = transpose(transpose(c)*tau);
end