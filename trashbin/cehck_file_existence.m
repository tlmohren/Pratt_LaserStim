for j = par.w_moths 
    if ~exist( par.SpikeName{j})  
        error( [par.SpikeName{j} ,' not found'])
    end
    if ~exist( par.StimName{j})  
        error( [par.StimName{j} ,' not found'])
    end
end