clf;

%%%%%%USER INPUT %%%%%%%%\
%number of strain increments
numstrain =7;
%set to -1 if there are no strian values to skip
strainskip = -1; %ex: 5 will skip all 5strain images. For multiple, [5,10,25] will skip these strains.
%theshold of deformation, values beyond which will be set to the threshold
thresh = 400;
%plot limits
ylim_min = 100;
ylim_max = 300;

y = 11; %add 10 to x; this is the SE number
fname = 'SE13_fib1_';
pname = 'C:\Users\Chris\Desktop\school\Dalhousie\DATA_Chris\AFM_images\SE\071018_SE13\deformation_summary\';
cd C:\Users\Chris\Desktop\school\Dalhousie\DATA_Chris\AFM_images\SE\071018_SE13\deformation_summary\

%Import relevant length strain data
data_l = zeros(1,7);
fid_l = fopen('C:\Users\Chris\Desktop\school\Dalhousie\DATA_Chris\AFM_images\SE\fibstrain_data_2.txt');
data_length = textscan(fid_l,'%f', 'Delimiter','\t','HeaderLines',1);
data_l(1:7) = data_length{1}((9*(y-1)+2):(9*(y-1)+8));
data_l = 100*((data_l(1:7)/data_l(1))-1);
fclose('all')

%creates directory structure, to be filled with files found in directory
dirinfo = dir();
dirinfo(~[dirinfo.isdir]) = [];
subdirinfo = cell(length(dirinfo));

for k = 1: length(dirinfo)
    thisdir = dirinfo(k).name;
    subdirinfo{k} = dir(fullfile(thisdir, '*.asc'));
end

getfield(subdirinfo{1}(1),'name');
convertCharsToStrings(getfield(subdirinfo{1}(1),'name'));

%will only look for the first 3*numstrain files in drectory, so move all
%incomplete sets to 'incomplete' directory
files = [];
for q = 1:(3*numstrain)
    files = [files; convertCharsToStrings(getfield(subdirinfo{1}(q),'name'));];
end

%data structure has collumns corresp to different strains, 3 deep for 3
%regions, and 1 row for each datapoint.  fill with 0s to make all 256 in
%length
data = zeros(256,numstrain,3);
allreg_average = zeros(numstrain,1);
allreg_std = zeros(numstrain,1);
reg2_average = zeros(numstrain,1);
reg2_std = zeros(numstrain,1);
reg3_average = zeros(numstrain,1);
reg3_std = zeros(numstrain,1);
reg4_average = zeros(numstrain,1);
reg4_std = zeros(numstrain,1);

if strainskip ~= -1
    numstrain = numstrain+(length(strainskip));
end

for i = 1:numstrain
    strain = 5*(i-1);
    if length(find(strain==strainskip))>0
        print([num2str(strain),' does not exist'])
        reg2_average(i) = 0;
        reg2_std(i) = 0;
        reg3_average(i) = 0;
        reg3_std(i) = 0;
        reg4_average(i) = 0;
        reg4_std(i) = 0;
        allreg_average(i) = 0;
        ndata_all = 0;
        allreg_std(i) = 0;
    else
        print([num2str(strain),' exists'])
        for j = 2:4
            thisfile_index = startsWith(files,[fname, int2str(strain), 'strain_',int2str(j)]);
            thisfile = files(find(thisfile_index==1));
            fid = fopen(strcat(pname,convertStringsToChars(thisfile)));
            data_pre = textscan(fid,'%f', 'Delimiter','\t','HeaderLines',14);
        
            %take only even numbered elements (row 2 of 2, height)
            data(1:length(data_pre{1}(2:2:end)),i,j-1) = data_pre{1}(2:2:end);
            %cap all values beyond a threshold to that threshold
            data(find(data(1:length(data_pre{1}(2:2:end)),i,j-1)>=thresh)) = thresh;
            fclose('all')
        end
        %replace uncommented with commented for standard error (dividing by number of datapoints)
        reg2_average(i) = sum(data(:,i,1))/sum(length(find(data(:,i,1) ~=0)));
        reg2_std(i) = std(data((find(data(:,i,1)~=0)),i,1));%((1/length(data((find(data(:,i,1)~=0)),i,1)))^0.5)*std(data((find(data(:,i,1)~=0)),i,1));
        reg3_average(i) = sum(data(:,i,2))/sum(length(find(data(:,i,2) ~=0)));
        reg3_std(i) = std(data((find(data(:,i,2)~=0)),i,2));%((1/length(data((find(data(:,i,2)~=0)),i,2)))^0.5)*std(data((find(data(:,i,2)~=0)),i,2));
        reg4_average(i) = sum(data(:,i,3))/sum(length(find(data(:,i,3) ~=0)));
        reg4_std(i) = std(data((find(data(:,i,3)~=0)),i,3));%((1/length(data((find(data(:,i,3)~=0)),i,3)))^0.5)*std(data((find(data(:,i,3)~=0)),i,3));
        allreg_average(i) = sum(sum(data(:,i,:)))/sum(length(find(data(:,i,:) ~=0)));
        ndata_all = length([transpose(data((find(data(:,i,1)~=0)),i,1)), transpose(data((find(data(:,i,2)~=0)),i,2)), transpose(data((find(data(:,i,3)~=0)),i,3))]);
        allreg_std(i) = std([transpose(data((find(data(:,i,1)~=0)),i,1)), transpose(data((find(data(:,i,2)~=0)),i,2)), transpose(data((find(data(:,i,3)~=0)),i,3))]);%((1/ndata_all)^0.5)*std([transpose(data((find(data(:,i,1)~=0)),i,1)), transpose(data((find(data(:,i,2)~=0)),i,2)), transpose(data((find(data(:,i,3)~=0)),i,3))]);
    end
end
%strain calculated for average and deviation of all 3 regions
hstrain_average = allreg_average/allreg_average(1);
ndata_all = length([transpose(data((find(data(:,i,1)~=0)),i,1)), transpose(data((find(data(:,i,2)~=0)),i,2)), transpose(data((find(data(:,i,3)~=0)),i,3))]);
hstrain_std = hstrain_average.*((allreg_std./allreg_average).^2 + (allreg_std(1)/allreg_average(1)).^2).^0.5;

%strain calculated for average and deviation for 3 separate regions
hstrain_reg2_average = reg2_average/reg2_average(1);
ndata_reg2 = length(data((find(data(:,i,1)~=0)),i,1));
hstrain_reg2_std = hstrain_reg2_average.*((reg2_std./reg2_average).^2 + (reg2_std(1)/reg2_average(1)).^2).^0.5;

hstrain_reg3_average = reg3_average/reg3_average(1);
ndata_reg3 = length(data((find(data(:,i,2)~=0)),i,2));
hstrain_reg3_std = hstrain_reg3_average.*((reg3_std./reg3_average).^2 + (reg3_std(1)/reg3_average(1)).^2).^0.5;

hstrain_reg4_average = reg4_average/reg4_average(1);
ndata_reg4 = length(data((find(data(:,i,3)~=0)),i,3));
hstrain_reg4_std = hstrain_reg4_average.*((reg4_std./reg4_average).^2 + (reg4_std(1)/reg4_average(1)).^2).^0.5;

figure(1)
subplot(2,2,1)
errorbar(linspace(0,strain,numstrain),reg2_average,reg2_std,'.','Color','b')
xlabel('strain applied by motors (%)')
ylabel('Region 1 (nm)')
xlim([-4 (strain+4)])
ylim([ylim_min ylim_max])
subplot(2,2,2)
errorbar(linspace(0,strain,numstrain),reg3_average,reg3_std,'.','Color','r')
xlabel('strain applied by motors (%)')
ylabel('Region 2 (nm)')
xlim([-4 (strain+4)])
ylim([ylim_min ylim_max])
subplot(2,2,3)
errorbar(linspace(0,strain,numstrain),reg4_average,reg4_std,'.','Color','g')
xlabel('strain applied by motors (%)')
ylabel('Region 3 (nm)')
xlim([-4 (strain+4)])
ylim([ylim_min ylim_max])
subplot(2,2,4)
errorbar(linspace(0,strain,numstrain),allreg_average,allreg_std,'.','Color','k')
xlabel('strain applied by motors (%)')
ylabel('Region average (nm)')
xlim([-4 (strain+4)])
ylim([ylim_min ylim_max])


%height versus true strain applied to fibril

figure(2)
subplot(2,2,1)
errorbar(data_l(1:length(reg2_average)),reg2_average,reg2_std,'.','Color','b')
xlabel('True fibril strain (%)')
ylabel('Region 1 (nm)')
xlim([(min(data_l(1:numstrain))-1) (max(data_l(1:numstrain))+1)])
ylim([ylim_min ylim_max])
subplot(2,2,2)
errorbar(data_l(1:length(reg2_average)),reg3_average,reg3_std,'.','Color','r')
xlabel('True fibril strain (%)')
ylabel('Region 2 (nm)')
xlim([(min(data_l(1:numstrain))-1) (max(data_l(1:numstrain))+1)])
ylim([ylim_min ylim_max])
subplot(2,2,3)
errorbar(data_l(1:length(reg2_average)),reg4_average,reg4_std,'.','Color','g')
xlabel('True fibril strain (%)')
ylabel('Region 3 (nm)')
xlim([(min(data_l(1:numstrain))-1) (max(data_l(1:numstrain))+1)])
ylim([ylim_min ylim_max])
subplot(2,2,4)
errorbar(data_l(1:length(reg2_average)),allreg_average,allreg_std,'.','Color','k')
xlabel('True fibril strain (%)')
ylabel('Region average (nm)')
xlim([(min(data_l(1:numstrain))-1) (max(data_l(1:numstrain))+1)])
ylim([ylim_min ylim_max])
path = 'C:\Users\Chris\Desktop\school\Dalhousie\DATA_Chris\AFM_images\height_mod_summary_MASTER\allfigs\height_figs_fibstrain_2\';
%saveas(figure(2),fullfile(path,['SE',num2str(x+10),'_h_truestrain.jpg']), 'jpeg');
%}

figure(3)
plot(linspace(0,strain,numstrain),data_l(1:numstrain),'.','Color','k','MarkerSize',10)
xlabel('strain applied by motors (%)')
ylabel('True fibril strain (%)')
xlim([-4 (strain+4)])
ylim([(min(data_l(1:numstrain))-1) (max(data_l(1:numstrain))+1)])
title(fname)
%}
path = 'C:\Users\Chris\Desktop\school\Dalhousie\DATA_Chris\AFM_images\height_mod_summary_MASTER\allfigs\height_figs_fibstrain_2\';
%saveas(figure(3),fullfile(path,['SE',num2str(x+10),'_straincomp.jpg']), 'jpeg');

%writes all recorded average data to file
%Each row of matrix is a set of average data, collumns indicate strain
%values
M1 = [transpose(reg2_average); transpose(reg3_average); transpose(reg4_average)]
M2 = [transpose(reg2_std); transpose(reg3_std); transpose(reg4_std)]
dlmwrite([pname,'deform_average.txt'],M1);
dlmwrite([pname,'deform_std.txt'],M2);