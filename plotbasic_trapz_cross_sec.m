numstrain = 7;
strainskip = -1;

fname = 'SE13_fib1_';
pname = 'C:\Users\Chris\Desktop\school\Dalhousie\DATA_Chris\AFM_images\SE\071018_SE13\cross_sec_height\';
cd C:\Users\Chris\Desktop\school\Dalhousie\DATA_Chris\AFM_images\SE\071018_SE13\cross_sec_height\

dirinfo = dir();
dirinfo(~[dirinfo.isdir]) = [];
subdirinfo = cell(length(dirinfo));

for k = 1: length(dirinfo)
    thisdir = dirinfo(k).name;
    subdirinfo{k} = dir(fullfile(thisdir, '*.asc'));
end

getfield(subdirinfo{1}(1),'name');
convertCharsToStrings(getfield(subdirinfo{1}(1),'name'));

files = [];
for q = 1:(3*numstrain)
    files = [files; convertCharsToStrings(getfield(subdirinfo{1}(q),'name'));];
end

%data structure has collumns corresp to different strains, 3 deep for 3
%regions, and 1 row for each datapoint.  fill with 0s to make all 256 in
%length
data_height = zeros(256,numstrain,3);
data_length = zeros(256,numstrain,3);
reg2_trapz = zeros(numstrain,1);
reg3_trapz = zeros(numstrain,1);
reg4_trapz = zeros(numstrain,1);

if strainskip ~= -1
    numstrain = numstrain+1;
end

for i = 1:numstrain
    strain = 5*(i-1);
    if strain == strainskip
        reg2_trapz(i) = 0;
        reg3_trapz(i) = 0;
        reg4_trapz(i) = 0;
        ndata_all = 0;
    else
        for j = 2:4
            %find datafile specific to strain, region number and sample
            %number
            thisfile_index = startsWith(files,[fname, int2str(strain), 'strain_',int2str(j)]);
            thisfile = files(find(thisfile_index==1));
            fid = fopen(strcat(pname,convertStringsToChars(thisfile)));
            data_pre = textscan(fid,'%f', 'Delimiter','\t','HeaderLines',12);
        
            %take only even numbered elements (row 2 of 2, height)
            data_height(1:length(data_pre{1}(2:2:end)),i,j-1) = data_pre{1}(2:2:end);
            data_length(1:length(data_pre{1}(1:2:end)),i,j-1) = data_pre{1}(1:2:end);
            fclose('all')
        end
        %numerical integration of each profile, X = profile length, Y =
        %profile height
        reg2_trapz(i) = trapz(data_length(:,i,1),data_height(:,i,1));
        reg3_trapz(i) = trapz(data_length(:,i,2),data_height(:,i,2));
        reg4_trapz(i) = trapz(data_length(:,i,3),data_height(:,i,3));
    end
    
end

figure(1)
plot(linspace(0,strain,numstrain),100*((reg2_trapz/reg2_trapz(1))-1),'*')
xlabel('machine strain (%)')
ylabel('Change in cross sectional area (%)')
title('region 1, SE16')

figure(2)
plot(linspace(0,strain,numstrain),100*((reg3_trapz/reg3_trapz(1))-1),'*')
xlabel('machine strain (%)')
ylabel('Change in cross sectional area (%)')
title('region 2, SE16')

figure(3)
plot(linspace(0,strain,numstrain),100*((reg4_trapz/reg4_trapz(1))-1),'*')
xlabel('machine strain (%)')
ylabel('Change in cross sectional area (%)')
title('region 3, SE16')

dlmwrite([pname,'cross_area.txt'],[[transpose(reg2_trapz)]; [transpose(reg3_trapz)]; [transpose(reg4_trapz)];]);