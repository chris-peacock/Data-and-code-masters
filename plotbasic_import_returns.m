%(sample, region, datatype(def,height,modulus))
%make data large enough to include all points from every profile; some with
%more than 256 points
data = zeros(300,3,3);
Average = zeros(21,3,3);
SD = zeros(21,3,3);
files_m = [];

%F = factor to divide out of data to get into desired units (= 1E15 for modulus, nPa -> MPa)
for n = 1:3
    if n == 1
        pname = 'C:\Users\Chris\Desktop\school\Dalhousie\DATA_Chris\AFM_images\SE\return_data\SE14_21_d_return\';
        cd C:\Users\Chris\Desktop\school\Dalhousie\DATA_Chris\AFM_images\SE\return_data\SE14_21_d_return\
        F = 1;
    elseif n == 2
        pname = 'C:\Users\Chris\Desktop\school\Dalhousie\DATA_Chris\AFM_images\SE\return_data\SE14_21_h_return\';
        cd C:\Users\Chris\Desktop\school\Dalhousie\DATA_Chris\AFM_images\SE\return_data\SE14_21_h_return\
        F = 1;
    elseif n==3
        pname = 'C:\Users\Chris\Desktop\school\Dalhousie\DATA_Chris\AFM_images\SE\return_data\SE14_21_m_return\';
        cd C:\Users\Chris\Desktop\school\Dalhousie\DATA_Chris\AFM_images\SE\return_data\SE14_21_m_return\
        F = 1E15;
    end

    %creates directory structure, to be filled with files found in directory
    dirinfo = dir();
    dirinfo(~[dirinfo.isdir]) = [];
    subdirinfo = cell(length(dirinfo));

    %create subdirinfo by reading all files, that are not directories
    for k = 1: length(dirinfo)
        thisdir = dirinfo(k).name;
        subdirinfo{k} = dir(fullfile(thisdir, '*.asc'));
    end

    %will add name of all files in directory to list
    files = [];

    for q = 1:length(subdirinfo{1})
        filechar = getfield(subdirinfo{1}(q),'name');
        sample = str2num(filechar(3:4));
        region = str2num(filechar(26));
        fid = fopen(strcat(pname,convertStringsToChars(convertCharsToStrings(getfield(subdirinfo{1}(q),'name')))));
        data_pre = textscan(fid,'%f', 'Delimiter','\t','HeaderLines',14);

        %take only even numbered elements (row 2 of 2, height)
        data(1:length(data_pre{1}(2:2:end)),region-1,n) = data_pre{1}(2:2:end)/F;
        Average(sample,region-1,n) = sum(data(1:length(data_pre{1}(2:2:end)),region-1,n))/sum(length(find(data(1:length(data_pre{1}(2:2:end)),region-1,n) ~=0)));
        SD(sample,region-1,n) = std(data(find(data(1:length(data_pre{1}(2:2:end)),region-1,n) ~=0),region-1,n));
        %Add the file name to a list
        files = [files; convertCharsToStrings(getfield(subdirinfo{1}(q),'name'));];
    end
    %close all files opened in this directory
    fclose('all')
    files_m = [files_m; files];
end

%dlmwrite([pname,'m_average.txt'],Average);
%dlmwrite([pname,'m_std.txt'],SD);

%plot(Average(:,:,1),Average(:,:,3),"*")
