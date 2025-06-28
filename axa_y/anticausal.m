function y=anticausal(B,A,x)
xrev=fliplr(x);
yrev=filter(B,A,xrev);
y=fliplr(yrev);
