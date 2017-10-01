function [ b,a ] = another_mr(order)
global tau
k = 15;
dev_best = 99;
while k <= 40;
    
    % Another model reduction method
    %   此处显示详细说明
    % test inital iir
    f = [0 0.4  0.6 1];                   %a passband of 0.4-0.6
    a = [1.0 1.0 0.0 0];
    b = firpm(k,f,a,[100,500]);
    len = length(b);
    a = zeros(1,len);
    a(1) = 1;
    sys = tf(b,a,0.05);
    GRED = balancmr(sys,order);
    es = 0.01; %stability margin
    tau = 15;

    A_t = GRED.A;
    B_t = GRED.B;
    C_t = GRED.C;
    D = GRED.D;
    %then generate iir
    [b,a] = ss2tf(A_t,B_t,C_t,D);     %a, b are numerators and denominators ( a very special case here, the author use a as num and b as den)
    b = truncate(b,16);
    a = truncate(a,16);
    [h,w] = freqz(b,a,'whole',2001);
    [gd,w] = grpdelay(b,a,500);
    gd = gd(1:200) - k/2;
    dev = max(abs(gd));
    if dev < dev_best
        k;
        dev_best = dev;
        b_best = b;
        a_best = a;
    end;
    
    %{
    plot(w/pi,20*log10(abs(h)))
    xlabel('Normalized Frequency (\times\pi rad/sample)')
    ylabel('Magnitude (dB)')

    figure(2)
    [gd,w] = grpdelay(b,a,500);
    plot(w(1:200),gd(1:200))
    %}
    
    k = k+1;
end  
[h,w] = freqz(b_best,a_best,'whole',2001);
plot(w/pi,20*log10(abs(h)))
xlabel('Normalized Frequency (\times\pi rad/sample)')
ylabel('Magnitude (dB)')
figure(2)
[gd,w] = grpdelay(b_best,a_best,500);
plot(w(1:200),gd(1:200))
end

