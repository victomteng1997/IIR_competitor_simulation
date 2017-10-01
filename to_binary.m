function [ result ] = to_binary( num,k )
%change a num to binary
%   此处显示详细说明
p = 0;
if num < 0
    p = 1;
    num = 0-num;
end
int_part = floor(num);
dec_part = num - int_part;
int_bi = de2bi(int_part)';
int_bi = flip(int_bi);
dec_bi = zeros(k,1);
for i = 1:k-length(int_part)
    dec_bi(i) = floor(dec_part*2);
    dec_part = dec_part*2-floor(dec_part*2);        
end
result = '';
for i = 1:length(int_bi)
    result = strcat(result,num2str(int_bi(i)));
end 
result = strcat(result,'.');
for i = 1:length(dec_bi)
    result = strcat(result,num2str(dec_bi(i)));
end 
if p == 1
    result = strcat('-',result);
end
end

