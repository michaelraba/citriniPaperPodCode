function plotSkmr(plotObject,isGraph)
[ntimesteps rMin ,rMax, ss ,ncs ,plotOn ,azimuthalSet, azimuthalSetSize ,printStatus, lags,csSet,timeSet]=constants();
if isGraph=="graph"
  f=figure('Renderer', 'painters', 'Position', [10 10 1900 900])
  cMaxx=2;
  A=linspace(0,1,ss)
  %A=linspace(0,1,1079)
  xlabel('radius $\frac{r}{R}$','interpreter','latex')
  ylabel("$S_{ii}(k,m;r,r')$",'interpreter','latex')  
  %xlabel('radius r');
  %ylabel('S');
  %figure;
  hold on;
  cou = 1
  for c=1:cMaxx
      subplot(cMaxx,1,cou);

      %for t=1:ntimesteps
      for m=4:azimuthalSetSize
      
      labelStr = ['(m,k)=(', num2str(azimuthalSet(m)),',',num2str(c),')'];
      %pp=plot(A,real(plotObject(c).circle(m).dat((end-1)/2:end) )/ntimesteps,"DisplayName",labelStr);
      pp=plot(A,real(plotObject(c).m(m).dat/ntimesteps),"DisplayName",labelStr);

      %smits2016(3).cs(1).circle(2).dat  
      tiSt=['Streamwise mode: ' num2str(c)  ];
      title(tiSt, 'FontName','capitana','FontSize',12,'interpreter','latex')
      if c==1
      legend();
      end
      %avgTimeEnd(1).circle(1).dat  
      %pp=plot(A,real(plotObject(c).circle(m).dat /ntimesteps),"DisplayName",labelStr)

      
      
      %pp=plot(A,real(plotObject(c).t(t).azimuthal(m).dat((end-1)/2:end) )/ntimesteps,"DisplayName",labelStr)
                    %SrrPrForFourierPost(c).t(t).azimuthal(m).dat
      %if mod(c,4)==0
      %  pp.LineStyle='-';
      %elseif mod(c,4)==1
      %  pp.LineStyle='--';
      %elseif mod(c,4)==2
      %  pp.LineStyle=':';
      %elseif mod(c,4)==3
      %  pp.LineStyle='-.';
      %end
      hold on;
      %pause(1);
      end % m
      cou = cou + 1;
  end %c
     % end %t
      %legend( );
      %saveas(gcf,'Sij.png','res')
      %sprintf('%s','pause');
elseif isGraph=="graphPause"
  hold on;
    for m=2:38
    for c=1:ncs
    plot(real(plotObject(m).crosssection(c).dat(end/2:end) )/ntimesteps)
    hold on;
    pause(1);
    end
    end
    %sprintf('%s','pause');
      pause(1)
else
end % if
  titleStrr=['Snapshot POD modes $\Phi_{ii}(k,m;r)$ for (tTot,xTot)=(' num2str(ntimesteps) ',' num2str(ncs) ') Uniformly Sampled']
  sgtitle(titleStrr,'FontName','capitana','FontSize',12,'interpreter','latex')
  xlabel('1-r','interpreter','latex')

if isGraph=="avg" % plot the avg of the cross sections
  f=figure('Renderer', 'painters', 'Position', [10 10 1900 900])
  cMaxx=2;
  A=linspace(0,1,ss)
  %A=linspace(0,1,1079)
  xlabel('radius $\frac{r}{R}$','interpreter','latex')
  ylabel("$S_{ii}(k,m;r,r')$",'interpreter','latex')
  hold on;
  cou = 1


for m=1:azimuthalSetSize
    avgPlotting(m).dat = zeros(1,540); 
for c=1:ncs
  avgPlotting(m).dat = plotObject(c).m(m).dat + avgPlotting(m).dat;
end % c
end % m


% only plot averages !
  %for c=1:cMaxx
      subplot(cMaxx,1,cou);

      %for t=1:ntimesteps
      %for m=1:azimuthalSetSize
      for m=1:azimuthalSetSize

      labelStr = ['(m,k)=(', num2str(azimuthalSet(m)),',',num2str(c),')'];
      %pp=plot(A,real(plotObject(c).circle(m).dat((end-1)/2:end) )/ntimesteps,"DisplayName",labelStr);
      pp=plot(A,real(avgPlotting(m).dat/(ntimesteps*ncs)),"DisplayName",labelStr);

      %smits2016(3).cs(1).circle(2).dat
      tiSt=['Streamwise mode: ' num2str(c)  ];
      title(tiSt, 'FontName','capitana','FontSize',12,'interpreter','latex')
      legend();
      hold on;
      end % m
      cou = cou + 1;
%  end %c



end % f
