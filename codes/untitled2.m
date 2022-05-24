A = randi(9,2,1);
%B = xcorr(A,A)
% A is 2x2 size matrix, so xcorr(A) is size 2*2

%A.*ctranspose(A)
A