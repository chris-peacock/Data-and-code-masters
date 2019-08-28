function [M,S] = mean_std_general(data)
    M = mean(squeeze(data(:,2,:)),2,'omitnan');
    S = std(squeeze(data(:,2,:)),0,2,'omitnan');
end