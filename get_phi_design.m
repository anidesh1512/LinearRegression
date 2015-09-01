function[phi_design] = get_phi_design(features, M, mu, s)
    [row_feat, col_feat] = size(features);
    phi_design = ones(row_feat, M);
    sigma = 2*s*s*eye(col_feat, col_feat);
    
    for i=1:row_feat
        for j=2:M
            phi_design(i, j) = exp(-1 * (features(i, :) - mu(j - 1, :)) / (sigma) * (features(i, :) - mu(j - 1, :))');
        end
    end
end