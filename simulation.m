function [ S ] = simulation( S0,r,vol,dt,w,nsim,nobs )
S=zeros(nsim,nobs+1);
S(:,1)=S0;
S(:,2) = S0*exp((r-vol^2/2)*dt+vol*sqrt(dt)*w(:,1));
for j=3:nobs+1
    S(:,j) = S(:,j-1).*exp((r-vol^2/2)*dt+vol*sqrt(dt)*w(:,j-1));
end
end

