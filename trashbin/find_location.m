


for j = 1 :size(par.MothN,1)
    [U,S,V] = svd( NE.(['Nrate',num2str(j)]) , 'econ');
    
    M1(:,j) = mean( NE.(['Nrate',num2str(j)]),2);
%     size(NE.(['Nrate',num2str(j)]))
    
    M1_proj(j,:) = NE.(['Nrate',num2str(j)])'  * M1(:,j);
    
    
    if mean(V(1:5,1)) <=0.2
        V(:,1) = -V(:,1);
        U(:,1) = -U(:,1);
    end
    V_Vec(j,:) = V(:,1);
    U_modes(j,:) = U(:,1);
    S_vec(j,:) = diag(S);
    
    
    % create sorting metric 
% for j = 1:size(par.MothN,1)
    for k = 1:5
            V_mass(j,k) = sum(V_Vec(j ,  find( L.cat( par.MothN(j,1),:) ==k) ) );
            V_std(j,k) = std(V_Vec(j ,  find( L.cat( par.MothN(j,1),:) ==k) ) );
    end
    [V,I] = max( abs(V_mass(j,:))  );
    SC.V(j) = abs(V)/V_std(j,I);
    SC.gr(j) = I;
end
[SC.Vs,SC.Is] = sort(SC.V,'descend');   