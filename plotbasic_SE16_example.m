clc;
clear;

%in nm
dlim_m = 80;
%in nm^2
clim_m = 8E4;

%Import relevant length strain data (1), full length
data_l_1 = zeros(11,7);
fid_l = fopen('C:\Users\Chris\Desktop\school\Dalhousie\DATA_Chris\AFM_images\height_mod_summary_MASTER\fibstrain_data_1.txt');
data_length = textscan(fid_l,'%f', 'Delimiter','\t','HeaderLines',1);
data_length = data_length{1};
fclose('all');

for i = 1:(length(data_length)/9)
    data_l_1(i,:) =  data_length((9*(i-1)+2):(9*(i-1)+8));
    data_l_1(i,:) = 100*((data_l_1(i,:)/data_l_1(i,1))-1);
end

data_l_1 = data_l_1(6,:);

%Import relevant length strain data (1), full length
data_l_2 = zeros(11,7);
fid_2 = fopen('C:\Users\Chris\Desktop\school\Dalhousie\DATA_Chris\AFM_images\height_mod_summary_MASTER\fibstrain_data_2.txt');
data_length = textscan(fid_2,'%f', 'Delimiter','\t','HeaderLines',1);
data_length = data_length{1};
fclose('all');

for i = 1:(length(data_length)/9)
    data_l_2(i,:) =  data_length((9*(i-1)+2):(9*(i-1)+8));
    data_l_2(i,:) = 100*((data_l_2(i,:)/data_l_2(i,1))-1);
end

data_l_2 = data_l_2(6,:);

%Import relevant d-band data
data_d = zeros(3,7);
fid_d = fopen('C:\Users\Chris\Desktop\school\Dalhousie\DATA_Chris\AFM_images\height_mod_summary_MASTER\dpeak_FFT.txt');
data_dband = textscan(fid_d,'%f', 'Delimiter',',');
data_dband = data_dband{1};
fclose('all');

for i = 1:(length(data_dband)/7)
    data_d(i,:) =  data_dband((7*(i-1)+1):(7*(i-1)+7));
end

%Import relevant cross- sec data
data_c = zeros(3,7);
fid_c = fopen('C:\Users\Chris\Desktop\school\Dalhousie\DATA_Chris\AFM_images\height_mod_summary_MASTER\cross_area.txt');
data_cross = textscan(fid_c,'%f', 'Delimiter',',');
data_cross = data_cross{1};
fclose('all');

for i = 1:(length(data_cross)/7)
    data_c(i,:) =  data_cross((7*(i-1)+1):(7*(i-1)+7));
end

%%%%%%%%%%%%%%%dband%%%%%%%%%%%%%%

figure(1)
subplot(3,1,1)
plot(linspace(0,30,7),data_d(1,:),'*')
xlabel('Machine strain (%)')
ylabel('d band length (nm)')
ylim([50 dlim_m])
subplot(3,1,2)
plot(linspace(0,30,7),data_d(2,:),'*')
xlabel('Machine strain (%)')
ylabel('d band length (nm)')
ylim([50 dlim_m])
subplot(3,1,3)
plot(linspace(0,30,7),data_d(3,:),'*')
xlabel('Machine strain (%)')
ylabel('d band length (nm)')
ylim([50 dlim_m])

figure(2)
subplot(3,1,1)
plot(data_l_1,data_d(1,:),'*')
xlabel('End-to-end fibril strain (%)')
ylabel('d band length (nm)')
ylim([50 dlim_m])
subplot(3,1,2)
plot(data_l_1,data_d(2,:),'*')
xlabel('End-to-end fibril strain (%)')
ylabel('d band length (nm)')
ylim([50 dlim_m])
subplot(3,1,3)
plot(data_l_1,data_d(3,:),'*')
xlabel('End-to-end fibril strain (%)')
ylabel('d band length (nm)')
ylim([50 dlim_m])

figure(3)
subplot(3,1,1)
plot(data_l_2,data_d(1,:),'*')
xlabel('Feducial fibril strain (%)')
ylabel('d band length (nm)')
ylim([50 dlim_m])
subplot(3,1,2)
plot(data_l_2,data_d(2,:),'*')
xlabel('Feducial fibril strain (%)')
ylabel('d band length (nm)')
ylim([50 dlim_m])
subplot(3,1,3)
plot(data_l_2,data_d(3,:),'*')
xlabel('Feducial fibril strain (%)')
ylabel('d band length (nm)')
ylim([50 dlim_m])

%%%%%%%%%%%%%%%cross section%%%%%%%%%%%%%%

figure(4)
subplot(3,1,1)
plot(linspace(0,30,7),data_c(1,:),'*')
xlabel('Machine strain (%)')
ylabel('cross section area (nm^2)')
ylim([50 clim_m])
subplot(3,1,2)
plot(linspace(0,30,7),data_c(2,:),'*')
xlabel('Machine strain (%)')
ylabel('cross section area (nm^2)')
ylim([50 clim_m])
subplot(3,1,3)
plot(linspace(0,30,7),data_c(3,:),'*')
xlabel('Machine strain (%)')
ylabel('cross section area (nm^2)')
ylim([50 clim_m])

figure(5)
subplot(3,1,1)
plot(data_l_1,data_c(1,:),'*')
xlabel('End-to-end fibril strain (%)')
ylabel('cross section area (nm^2)')
ylim([50 clim_m])
subplot(3,1,2)
plot(data_l_1,data_c(2,:),'*')
xlabel('End-to-end fibril strain (%)')
ylabel('cross section area (nm^2)')
ylim([50 clim_m])
subplot(3,1,3)
plot(data_l_1,data_c(3,:),'*')
xlabel('End-to-end fibril strain (%)')
ylabel('cross section area (nm^2)')
ylim([50 clim_m])

figure(6)
subplot(3,1,1)
plot(data_l_2,data_c(1,:),'*')
xlabel('Feducial fibril strain (%)')
ylabel('cross section area (nm^2)')
ylim([50 clim_m])
subplot(3,1,2)
plot(data_l_2,data_c(2,:),'*')
xlabel('Feducial fibril strain (%)')
ylabel('cross section area (nm^2)')
ylim([50 clim_m])
subplot(3,1,3)
plot(data_l_2,data_c(3,:),'*')
xlabel('Feducial fibril strain (%)')
ylabel('cross section area (nm^2)')
ylim([50 clim_m])