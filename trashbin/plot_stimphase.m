
L.last = 2.05e7;  % repeat

% Plot different stimulus sections  sections 
if figure_on
    figure(31)
        plot( (1:L.last)   /4e4    ,Sp.M2stim(1:L.last)   )
            hold on
        plot( (L.last:STAst(1))'  /4e4   ,Sp.M2stim(  L.last:STAst(1) )   )
        plot( (STAst(1):STAsp(1))' /4e4   ,Sp.M2stim(  STAst(1):STAsp(1)  )   )
        plot( (STAst(2):STAsp(2))'  /4e4   ,Sp.M2stim(  STAst(2):STAsp(2)  )   )
        plot( (STAst(3):STAsp(3))'   /4e4  ,Sp.M2stim(  STAst(3):STAsp(3) )   )
            legend('Laser phase','Sine wave','White noise small amp',...
                'White noise large amp 1','White noise large amp 2','Location','Best')
            xlabel('Time [s]');ylabel('stimulus [?]')
            
            
    figure(32)
        for j = 3:-1:1
            y = Sp.M2stim( STAst(j):STAsp(j),1);
            N = length(y);
            Fs = 4e4;          
             k = (-N/2:N/2-1)/N*Fs;  % last term is periodic 
             yt = 2/N*fft(y);        % scale by 2 to compensate for negative f, /N for scaling
             yts = abs(fftshift(yt));
             plot( k , yts)
                hold on
            mean_noisefloor(j) = mean(yts( N/2 : N*6/11));
        end
        legend('Largeamp 2', 'Largeamp2','Smallamp')
        hold off
        axis([0,2e3,0,0.005])
        display(['Mean noisefloor: ',num2str(mean_noisefloor)])
end


