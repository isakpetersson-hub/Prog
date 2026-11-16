clear; close;
n = 1000; p = 0.3;
bino_cdf=[ ]; % the cdf of a Binomial X;
% give values of cdf of a Binomial X at 0 to n
for i=0:n
    bino_cdf=[bino_cdf, binocdf(i,n,p)];
end

% the corresponding Normal cdf
norm_cdf=[ ];
for i=0:n
    norm_cdf=[norm_cdf, normcdf(i,n*p,sqrt(n*p*(1-p)))];
end

max_difference=max(abs(bino_cdf-norm_cdf))
