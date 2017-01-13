 % ------------------------
% TMohren 
% Analysis of 3rd data set 
% ------------------------
% Make colorful overview of all 37 laser responses


    
Lindoff  = find(Lbinon,1,'last');
Lindon = find(Lbinon,1);
% LW


f = figure(5);
    set(f,'name','PCA for all 37 neurons, BAR COLORS do not account for wrong lasers (e.g. 6) ')
    f.Position = [50,50,1200 900];



for j = 1:size(MothN,1)
    subplot(14,10,j*2-1)
        fill( [Lindon,Lindon,Lindoff,Lindoff] ,...
    [0,1,1,0]-0.5,...
      [0.8,0.8,0.8],'EdgeColor','none')     
        hold on   
        plot(U_modes(j,:))
        axis off
        hold off 
    subplot(14,10,j*2)
    for k = 1:5
            bar( find( L.cat( MothN(j,1),:) ==k)    ,...
            V_Vec(j ,  find( L.cat( MothN(j,1),:) ==k) ), Lcol(k),'EdgeColor','none')
                hold on 
    end
        title(['\# ',num2str(j)])
        axis off
end
% tightfig;
display('Non-sorted laserresponse plotted')


f = figure(6);
    set(f,'name','PCA for all 37 neurons')
    f.Position = [50,50,1200 900];
for j = 1:size(MothN,1)
        for k = 1:5
            V_mass(j,k) = sum(V_Vec(j ,  find( L.cat( MothN(j,1),:) ==k) ) );
            V_std(j,k) = std(V_Vec(j ,  find( L.cat( MothN(j,1),:) ==k) ) );
        end 
    subplot(14,10,j*2-1)
        fill( [Lindon,Lindon,Lindoff,Lindoff] ,...
        [0,1,1,0]-0.5,...
        [0.8,0.8,0.8],'EdgeColor','none')     
            hold on   
        plot(U_modes(SC.Is(j),:))
            axis off
            hold off 
    subplot(14,10,j*2)
    for k = 1:5
            bar( find( L.cat( MothN( SC.Is(j)   ,1),:) ==k)    ,...
            V_Vec(SC.Is(j) ,  find( L.cat( MothN(SC.Is(j),1),:) ==k) ), Lcol(k),'EdgeColor','none')
                hold on 
    end
    axis off
%     hold off 
%     axis([-1,27,-0.6,0.6])
        title(['',num2str(SC.gr( SC.Is(j) )), '-' num2str( round(SC.Vs(j), 1)),'\#',num2str(SC.Is(j)),])

%     if SC.Vs(j) > 6
%         rectangle('Position',[-1 -0.6 27 1.2])
%         
%     end
    drawnow
end
% tightfig;
display('Sorted laserresponse plotted ')







