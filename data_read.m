function [data,files] = data_read(directory_path,datashape,charpos,lineskip);
    
    %sample,strain,region,(x or y),data
    data = NaN(datashape(1),datashape(2),datashape(3),2,datashape(4));

    %path to search for subdirectories full of files
    cd(directory_path)
    %F = factor to divide out of data to get into desired units (= 1E15 for modulus, nPa -> MPa)

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
        %%%extract sample, strain and region numbers%%%
        filechar = getfield(subdirinfo{1}(q),'name');
        sample = str2num(filechar(charpos{1}));
        strain = str2num(filechar(charpos{2}));
        region = str2num(filechar(charpos{3}));
        
        %%%open file, collect data%%%
        fid = fopen(strcat(directory_path,convertStringsToChars(convertCharsToStrings(getfield(subdirinfo{1}(q),'name')))));
        data_pre = textscan(fid,'%f', 'Delimiter','\t','HeaderLines',lineskip);
        %%%fill data with textfile contents, save filename separately%%%
        
        data(sample,((strain/5)+1),region-1,1,1:(length(data_pre{1})/2)) = data_pre{1}(1:2:(end-1)); %default units: nanometres, div by 1000 for um
        data(sample,((strain/5)+1),region-1,2,1:(length(data_pre{1})/2)) = data_pre{1}(2:2:end);
        files = [files; convertCharsToStrings(getfield(subdirinfo{1}(q),'name'));];
    end
    %close all files opened in this directory
    fclose('all')
end