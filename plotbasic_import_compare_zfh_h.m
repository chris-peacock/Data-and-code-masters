%Insert directory namer here, to pull files from for analysis
pname = 'C:\Users\Chris\Desktop\HmD_test_images\profiles\';
cd C:\Users\Chris\Desktop\HmD_test_images\profiles\

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

%(sample,full data,datatype[d,h,zfh])
data_m = zeros(21,256,3);
%(sample,regions,datatype[d,h,zfh])
Average_m = zeros(21,3,3);
SD_m = zeros(21,3,3);
strain_num = [];
strain_threshold= 10;


for q = 1:length(subdirinfo{1})
    filechar = getfield(subdirinfo{1}(q),'name');
    %find sample number and region from name
    sample = str2num(filechar(3:4));
    strain = str2num(filechar(6:7));
    region = str2num(filechar(15));
    fid = fopen(strcat(pname,filechar));
    data_pre = textscan(fid,'%f', 'Delimiter','\t','HeaderLines',14);
    
    %take only even numbered elements (row 2 of 2, height).  region-1
    %because of naming scheme 2,3,4 rather than 1,2,3
   
    data = data_pre{1}(2:2:end);
    Average= sum(data)/sum(length(find(data ~=0)));
    SD= std(data(find(data ~=0)));
    
    if ~isempty(find(filechar=='d'))
        data_m(sample,1:length(data),1) = data;
        Average_m(sample,region-1,1)= Average;
        SD_m(sample,region-1,1)= SD;
    elseif length(find(filechar=='h'))>0
        data_m(sample,1:length(data),2) = data;
        Average_m(sample,region-1,2)= Average;
        SD_m(sample,region-1,2)= SD;
    elseif length(find(filechar=='z'))>0
        data_m(sample,1:length(data),3) = data;
        Average_m(sample,region-1,3)= Average;
        SD_m(sample,region-1,3)= SD;
    end
    %marks datapoints corresponding to images where fibril was above
    %10percent strain
    if strain>=strain_threshold
        strain_num = [strain_num; [sample 1]]
    else
        strain_num = [strain_num; [sample 0]]
    end
    
    fclose('all')

    %Add the file name to a list
    files = [files;{getfield(subdirinfo{1}(q),'name')};];
    
end

Dvec = Average_m(:,1,1)+Average_m(:,2,1)+Average_m(:,3,1);
Hvec = Average_m(:,1,2)+Average_m(:,2,2)+Average_m(:,3,2);
Zvec = Average_m(:,1,3)+Average_m(:,2,3)+Average_m(:,3,3);

Dvec_SD = SD_m(:,1,1)+SD_m(:,2,1)+SD_m(:,3,1);
Hvec_SD = SD_m(:,1,2)+SD_m(:,2,2)+SD_m(:,3,2);
Zvec_SD = SD_m(:,1,3)+SD_m(:,2,3)+SD_m(:,3,3);

%HEIGHT VERSUS ZFH
%Plots a blue marker for images where the machine strain was above 10%, red
%for less
figure(1)

for s = 1:length(subdirinfo{1})/3
    %strain_num has values for all 3 datasets for each image; multiply
    %index by 3 to check the strain value for each image only
    if strain_num(3*s,2)==1
        errorbar(Hvec(s+5),(Zvec(s+5)-Dvec(s+5)),max([Zvec_SD(s+5) Dvec_SD(s+5)]),max([Zvec_SD(s+5) Dvec_SD(s+5)]),Hvec_SD(s+5),Hvec_SD(s+5),'o','Color','b')
        hold on;
    else
        errorbar(Hvec(s+5),(Zvec(s+5)-Dvec(s+5)),max([Zvec_SD(s+5) Dvec_SD(s+5)]),max([Zvec_SD(s+5) Dvec_SD(s+5)]),Hvec_SD(s+5),Hvec_SD(s+5),'o','Color','r')
        hold on;
    end
end

line([0 400],[0 400])
xlabel('uncorrected height (nm)')
ylabel('zfh - deformation (nm)')
%xlim([80 350])
%ylim([80 350])
h(1) = plot(NaN,NaN,'ob');
h(2) = plot(NaN,NaN,'or');
legend(h, ['>',num2str(strain_threshold),'% strain'],['<',num2str(strain_threshold),'% strain']);

%DEF VERSUS HEIGHT
%Plots a blue marker for images where the machine strain was above 10%, red
%for less
figure(2)

for s = 1:length(subdirinfo{1})/3
    %strain_num has values for all 3 datasets for each image; multiply
    %index by 3 to check the strain value for each image only
    if strain_num(3*s,2)==1
        errorbar(Dvec(s+5),(Hvec(s+5)),Hvec_SD(s+5),Hvec_SD(s+5),Dvec_SD(s+5),Dvec_SD(s+5),'o','Color','b')
        hold on;
    else
        errorbar(Dvec(s+5),(Hvec(s+5)),Hvec_SD(s+5),Hvec_SD(s+5),Dvec_SD(s+5),Dvec_SD(s+5),'o','Color','r')
        hold on;
    end
end

xlabel('deformation (nm)')
ylabel('height (nm)')
h(1) = plot(NaN,NaN,'ob');
h(2) = plot(NaN,NaN,'or');
legend(h, ['>',num2str(strain_threshold),'% strain'],['<',num2str(strain_threshold),'% strain']);

%dlmwrite([pname,'m_average.txt'],Average_m);
%dlmwrite([pname,'m_std.txt'],SD_m);

%figure(3)
for i = 6:21
    %find all nonzero values, to set limits
    xdata = data_m(i,find((data_m(i,:,2)~=0)),2);
    ydata = data_m(i,find((data_m(i,:,1)~=0)),1);
    %normalize data
    ydata = ydata./xdata;
    %xdata = xdata/mean(xdata);
    figure(i)
    plot(xdata,ydata,'.')
    hold on;
    plot(xdata,mean(data_m(i,find((data_m(i,:,1)~=0)),1))./xdata);
    xlabel('height/average height')
    ylabel('percentage of height in deformation (%)')
    title(['SE',num2str(i)])
    %xlim([(min(xdata)-5) (max(xdata)+5)])
    %ylim([(min(ydata)-10) (max(ydata)+10)])
    hold on;
end
