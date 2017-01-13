
% determine Laser start & stop 
Lred = 1e2;
red_vec = 1:Lred:par.N_last;
Ldur = round((5000*40-30*40)/Lred);
Lmove = (1:4)*0.4*1e7;      %  moments when laser switched position 

L.st = zeros(length(par.w_moths),25);
L.end = zeros(length(par.w_moths),25);
L.cat = zeros(length(par.w_moths),25);
        
% for j =1:length(par.w_moths)
for j = par.w_moths
    LaserStim = Sp.(['M',num2str(j),'stim'])(red_vec);
    Count = 1;
    LaserSwitch = LaserStim;
    LaserSwitch( LaserSwitch <2.5) = 0;  
    LaserSwitch( LaserSwitch >2.5) = 1;
    max(501:length(LaserSwitch)-Ldur)
    for k = 501:length(LaserSwitch)-Ldur-3e3
       if any( LaserSwitch(  k-   Ldur/4  +1   :k-1)) == 0 && LaserSwitch(k) > 0.99
           L.st(j,Count) = red_vec(k);
           LaserSwitch(k+1:k+Ldur) = 1;
       elseif   any( LaserSwitch(k+1 :  k+   Ldur/4   )) == 0 && LaserSwitch(k) > 0.99
           
           L.end(j,Count) = red_vec(k) ;
           Count = Count + 1;
       end
    end
    L.pulses(j) = Count-1;
                if par.diagnostic_fig 
                f = figure(1);
                    set(f,'name','Laser start & stop')
                    f.Position = [300,200,700 600];
                     for k = 1:L.pulses(j)
                     h(1) = fill([L.st(j,k);L.st(j,k);L.end(j,k);L.end(j,k)]/40e3,...
                         [0,1,1,0]*3.4,...
                         [0.9,0.9,0.9],'EdgeColor','none');
                        hold on
                     end
                    h(2) =  plot( red_vec/40e3,LaserStim);
                    h(3:6) =  plot( [Lmove',Lmove']/40e3,[0,5],'k');
                    xlabel('Time [s]') ;     ylabel('Stimulus intensity [?]')
                    axis([0,par.N_last/4e4,1.5,3.5])
                    legend(h(1:3),'laser ON','laser stimulus','division line')
                    hold off
                    drawnow
                end
end

% Split up laser in categories (L.cat), for the 5 different laser locations
L.cat = L.end<=Lmove(1);
L.cat = L.cat + ( ( L.end>=Lmove(1)) .*  (L.end<=Lmove(2) )  ) * 2;
L.cat = L.cat + ( ( L.end>=Lmove(2)) .*  (L.end<=Lmove(3) )  ) * 3;
L.cat = L.cat + ( ( L.end>=Lmove(3)) .*  (L.end<=Lmove(4) )  ) * 4;
L.cat = L.cat + ( ( L.end>=Lmove(4))   ) * 5;
L.cat( find(L.end== 0) ) = 0;

display('Laser start + stop done')