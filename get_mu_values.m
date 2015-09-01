function [mu] = get_mu_values(features, M)
    [row_feat, col_feat] = size(features);
    
    mu = zeros(M - 1, col_feat);
    
    start_pt = 1;
    end_pt = floor(row_feat/(M -1));
    for i=1:(M -1)
        mu(i, :) = mean(features(start_pt:end_pt, :), 1);
        start_pt = end_pt + 1;
        end_pt = end_pt + floor(row_feat/(M - 1));
        if end_pt > row_feat
            end_pt = row_feat;
        end
    end
end