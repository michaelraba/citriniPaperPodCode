%A = randi(9,2,1);
% https://www.cfd-online.com/Forums/main/199241-piv-data-analysis.html
nts=10;
tSize=3;
rSize=4;
Rat_t=struct('dat', repmat({zeros(1,rSize)}, [nts,1]));
for tt=1:nts
Rat_t(tt).dat=randi(12,tSize,1);
R(tt)=trapz(Rat_t(tt).dat); % radially average 
end

% Ruu= zeros(tSize);
% % correlation
% for tt=1:nts
% m=qq(tt).dat
% Ruu(tt)=m*m;
% end
