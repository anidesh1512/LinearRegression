function [weights] = train_cfs(feat_train, M, lambda, rel_train)

    weights = zeros(M, 1);
    
    [mu] = get_mu_values(feat_train, M);
    
    phi_design_train = get_phi_design(feat_train, M, mu, sqrt(0.99));
    
    weights = ((lambda*eye(M, M)) + (phi_design_train' * phi_design_train)) \ (phi_design_train' * rel_train);    
end
    
         