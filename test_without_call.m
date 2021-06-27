T=2;
dt=1/52; %rebalancing every week
risk_free=0.05;
r=[0; 0.02; 0.05]+risk_free; %3 different scenarios
vol=[0.05; 0.25; 0.45]; %3 different scenarios
nsim=5000; %number of simulations
Value_0=100000; %initial value of our portfolio
S0=100; %initial price of the index
nobs = T/dt;
w = zscore(normrnd(0,1,nsim,nobs)); %standard normal
rng(0,'twister');
S.first=simulation(S0,r(1),vol(1),dt,w,nsim,nobs);
S.second=simulation(S0,r(2),vol(2),dt,w,nsim,nobs);
S.third=simulation(S0,r(3),vol(3),dt,w,nsim,nobs);
%Scenario 1: low volatility (and return)
[prob_cashlock1,prob_gapevent1,mean_Value1]=CPPI(T,dt,risk_free,S.first,Value_0,nsim,nobs)
%Scenario 2: medium volatility
[prob_cashlock2,prob_gapevent2,mean_Value2]=CPPI(T,dt,risk_free,S.second,Value_0,nsim,nobs)
%Scenario 3: high volatility
[prob_cashlock3,prob_gapevent3,mean_Value3]=CPPI(T,dt,risk_free,S.third,Value_0,nsim,nobs)
