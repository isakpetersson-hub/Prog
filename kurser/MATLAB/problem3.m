clear; close;
a = 0; b=0.5; c=1; n=10000;
rng(1);
two_dim_unif=rand([2,n]); % generate n uniform in the rectangle
x=0.5*two_dim_unif(1,:); % spefify x
y=two_dim_unif(2,:); % specify y
y_curve=(1/sqrt(2*3.14))*exp(-x.^2/2); % the normal curve
f_n=sum(y<y_curve); % count how many in the region I
area_I=(b-a)*c*f_n/n % compute the area of I