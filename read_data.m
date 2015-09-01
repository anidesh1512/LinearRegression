function [rel_labels ,feat] = read_data(filename)
    fid = fopen(filename);
    tline = fgets(fid);
    count = 1;
    rel_labels=0;
    str = '';
    feat = zeros(1,46);
    while ischar(tline)
        data = textscan(tline, '%d', 1);
        rel_labels = [rel_labels;cell2mat(data)];
        data = textscan(tline, '%d qid:%d', 1);
        start = numel(num2str(cell2mat(data(2))));
        str = tline(start+8:end);
        data = textscan(str, '%*d:%.6f', 46);
        row = cell2mat(data);
        feat = [feat; row'];
        s = size(feat);
        count = count+1;
        tline = fgets(fid);
    end
    fclose(fid);
    
    rel_labels = double(rel_labels);
    
end