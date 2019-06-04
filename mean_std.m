function [M,S] = mean_std(data)
    M = mean(squeeze(data(:,:,:,2,:)),4,'omitnan');
    S = std(squeeze(data(:,:,:,2,:)),0,4,'omitnan');
end