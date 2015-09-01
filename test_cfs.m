function[Erms_test] = test_cfs(feat_test, rel_test, phi_design_test, weights)
    E_test = (((phi_design_test * weights) - rel_test)' * ((phi_design_test * weights) - rel_test)) / 2;
    
    [row_test, col_test] = size(feat_test);
    Erms_test = sqrt((2 * E_test)/ row_test);
end