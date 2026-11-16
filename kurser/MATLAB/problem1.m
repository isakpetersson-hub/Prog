clear; close; % good habit :-)
n=600; % n throws of the die
rng(1); % to fix random generator seed so that each time one gets same random simulations
throw = randi(6,n,1); % Simulate n throws
f1 = sum(throw==1);
f2 = sum(throw==2);
f3 = sum(throw==3);
f4 = sum(throw==4);
f5 = sum(throw==5);
f6 = sum(throw==6);
sample_mean = mean(throw) % Sample mean
sample_standard_deviation = std(throw) % Sample standard deviation