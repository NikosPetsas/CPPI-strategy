function [prob_cashlock,prob_gapevent,mean_Value] = CPPI(T,dt,risk_free,S,Value_0,nsim,nobs)
Value=zeros(nsim,nobs+1);
Value(:,1)=Value_0;
disc=1/(1+risk_free)^T;
BondPrice(1)=Value_0*disc; %our floor
cushion(:,1)=Value(:,1)-BondPrice(1);
for mult=1:8 %multipliers from 1 to 8
    exposure_to_index(:,1)=min(max(mult*cushion(:,1),0),Value(:,1)); % 0<exposure to index<Value (every time)
    exposure_to_bond(:,1)=Value(:,1)-exposure_to_index(:,1);
    index_holding(:,1)=exposure_to_index(:,1)./S(:,1);
    bond_holding(:,1)=exposure_to_bond(:,1)/BondPrice(1);
    for i=2:nobs
       disc=1/(1+risk_free)^((nobs+1-i)*dt);
       BondPrice(i)=Value_0*disc; %new floor
       Value(:,i)=index_holding(:,i-1).*S(:,i)+bond_holding(:,i-1).*BondPrice(i); %our value before rebalancing
       cushion(:,i)=Value(:,i)-BondPrice(i);
       exposure_to_index(:,i)=min(max(mult*cushion(:,i),0),Value(:,i));
       exposure_to_bond(:,i)=Value(:,i)-exposure_to_index(:,i);
       index_holding(:,i)=exposure_to_index(:,i)./S(:,i);
       bond_holding(:,i)=exposure_to_bond(:,i)/BondPrice(i);
    end
    %at maturity
    BondPrice(nobs+1)=Value_0; 
    Value(:,nobs+1)=index_holding(:,nobs).*S(:,nobs+1)+bond_holding(:,nobs)*BondPrice(nobs+1);
    exposure_to_index(:,nobs+1)=index_holding(:,nobs).*S(:,nobs+1); %no rebalancing
    exposure_to_bond(:,nobs+1)=bond_holding(:,nobs)*BondPrice(nobs+1);
    index_holding(:,nobs+1)=index_holding(:,nobs);
    bond_holding(:,nobs+1)=bond_holding(:,nobs);
    mean_Value(mult)=mean(Value(:,end));
    k=0;
    for j=1:nsim
        if exposure_to_index(j,end)==0 && S(j,end)>S(j,1) %conditions for cash lock
            k=k+1;
        end
    end
    prob_cashlock(mult)=k/nsim; %probability of cash lock
    gapevent=Value(:,end)<Value_0; %condition for gap event
    prob_gapevent(mult)=sum(gapevent)/nsim; %probability of gap risk
end
end