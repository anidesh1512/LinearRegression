rel_labels = load('rel_labels.mat');
features = load('features.mat');

rel_labels = struct2cell(rel_labels);
features = struct2cell(features);

rel_labels = cell2mat(rel_labels);
features = cell2mat(features);

tic;
feat_train = features(1:floor(0.8*end), :);
rel_train = rel_labels(1:floor(0.8*end), :);

feat_valid = features(ceil(0.8*end):floor(0.9*end), :);
rel_valid = rel_labels(ceil(0.8*end):floor(0.9*end), :);

feat_test = features(ceil(0.9*end):end, :);
rel_test = rel_labels(ceil(0.9*end):end, :);





[row_train, col_train] = size(feat_train);
[row_valid, col_valid] = size(feat_valid);



M_cfs = 20;
s_cfs = sqrt(0.99);
lambda_cfs = 0.5;
W_cfs = zeros(M_cfs, 1);

[mu_cfs] = get_mu_values(feat_train, M_cfs);
[phi_design_train] = get_phi_design(feat_train, M_cfs, mu_cfs, s_cfs);
[phi_design_valid] = get_phi_design(feat_valid, M_cfs, mu_cfs, s_cfs);
[phi_design_test] = get_phi_design(feat_test, M_cfs, mu_cfs, s_cfs);

%cfs method
M_cfs = 20;
[W_cfs] = train_cfs(feat_train, M_cfs, lambda_cfs, rel_train);

%Now calculate error of validation data
E_valid = (((phi_design_valid * W_cfs) - rel_valid)' * ((phi_design_valid * W_cfs) - rel_valid)) / 2;

%Calculate error of training
E_train = (((phi_design_train * W_cfs) - rel_train)' * ((phi_design_train * W_cfs) - rel_train)) / 2;

[rms_cfs] = test_cfs(feat_test, rel_test, phi_design_test, W_cfs);
        

Erms_valid = sqrt((2 * E_valid)/ row_valid);
Erms_train = sqrt((2 * E_train)/ row_train);






%Gradient descent
M_gd = 15;
s_gd = sqrt(0.9);
    eta = 0.1;
    phi_design_train = zeros(row_train, M_gd);
    phi_design_valid = zeros(row_valid, M_gd);
    W_cfs = zeros(M_gd, 1);
    
    [mu_gd] = get_mu_values(feat_train, M_gd);
    [phi_design_train] = get_phi_design(feat_train, M_gd, mu_gd, s_gd);
    [phi_design_valid] = get_phi_design(feat_valid, M_gd, mu_gd, s_gd);
    [phi_design_test] = get_phi_design(feat_test, M_gd, mu_gd, s_gd);
    
    [phi_train_row, phi_train_col] = size(phi_design_train);
    
    W_gd = ones(M_gd, 1);
    next_weights = zeros(M_gd, 1);
    Erms_gd_prev = inf; 
    count = 0;
    while(1)
        count = count + 1;
        for i=1:phi_train_row
            for k=1:M_gd
                W_gd(k, :) = W_gd(k, :) + (eta * (rel_train(i) - (W_gd' * phi_design_train(i, :)')) * phi_design_train(i, k));
            end
        end
        
        E_gd = (((phi_design_valid * W_gd) - rel_valid)' * ((phi_design_valid * W_gd) - rel_valid)) / 2;
        
        Erms_gd_curr = sqrt((2 * E_gd) / row_valid);
        if(Erms_gd_curr > Erms_gd_prev)
            eta = eta * 0.1;
        elseif((Erms_gd_prev - Erms_gd_curr) < 0.0001)
            break;
        end
        Erms_gd_prev = Erms_gd_curr;
    end
    
    [rms_gd] = test_gd(feat_test, rel_test, phi_design_test, W_gd);



fprintf('My ubit name is %s\n','ad78');
fprintf('My student number is %d \n',50133684);
fprintf('the model complexity M cfs is %d\n', M_cfs);
fprintf('the model complexity M gd is %d\n', M_gd);
fprintf('the regularization parameters lambda cfs is %4.2f\n', lambda_cfs);
fprintf('the regularization parameters lambda gd is %4.2f\n', 0);
fprintf('the root mean square error for the closed form solution is %4.2f\n', rms_cfs);
fprintf('the root mean square error for the gradient descent method is %4.2f\n', rms_gd);
