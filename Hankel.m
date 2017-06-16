function [ result ] = Hankel( coeff )
% Calculate hankel vectors 
% the result would be a matrix, n by n
len = length(coeff);

result = zeros(len,len);
for i = 1:len
    for j = 1:len
        if i + j -1 > len
            result(i,j) = 0;
        else
            result(i,j) = coeff(i+j-1);
        end
    end
end
end

