clc;
clear;
clf;

s = [7,2,7,7,4,7,6,5];
sampsize = cumsum(3*s);
SE_list = [];

fid = fopen('C:\Users\Chris\Desktop\school\Dalhousie\DATA_Chris\AFM_images\SE\sample_data_SE14_21_raw.txt');
data = textscan(fid,'%f', 'Delimiter','\t');
data_raw = transpose(reshape(data{1},[13,length(data{1})/13]));

fid = fopen('C:\Users\Chris\Desktop\school\Dalhousie\DATA_Chris\AFM_images\SE\sample_data_SE14_21_strain.txt');
data = textscan(fid,'%f', 'Delimiter','\t');
data_strain = transpose(reshape(data{1},[14,length(data{1})/14]));

fprintf( ['1. Machine strain \n','2. End-to-end strain \n','3.fiducial strain \n','4.D band (nm) \n',...
    '5.Cross sec (nm)^2 \n','6.Deformation (nm) \n', '7.SD Deformation (nm) \n','8.Height (nm) \n',...
    '9.SD Height (nm) \n','10.Modulus (MPa) \n','11.SD Modulus (MPa) \n','12.RMS Modulus (MPa) \n',...
    '13.(mod-RMS)/(mod + rms) \n']);

x = input('independent axis:  ');
y = input('dependent axis:  ');

SE = -2;
disp('')
disp('Enter SE numbers to include in plot, enter 0 to include all, -1 to end inclusions')

while (SE ~= 0 && SE ~= -1)
    SE ~= -1
    SE = input('SE to include: ');
    SE_list = [SE_list SE];
end
fprintf(['1. Raw data \n','2. Strain data \n'])
z = input('Enter which dataset to take data from: ')

if z == 1
    fid = fopen('C:\Users\Chris\Desktop\school\Dalhousie\DATA_Chris\AFM_images\SE\sample_data_SE14_21_raw.txt');
    data = textscan(fid,'%f', 'Delimiter','\t');
    data = transpose(reshape(data{1},[13,length(data{1})/13]));
    n = ["Machine strain";"End-to-end strain";"fiducial strain";"D band (nm)";...
    "Cross sec (nm)^2";"Deformation (nm)"; "SD Deformation (nm)";"Height (nm)";...
    "SD Height (nm)";"Modulus (MPa)";"SD Modulus (MPa)";"RMS Modulus (MPa)";...
    "(mod-RMS)/(mod + rms)"];
elseif z == 2
    fid = fopen('C:\Users\Chris\Desktop\school\Dalhousie\DATA_Chris\AFM_images\SE\sample_data_SE14_21_strain.txt');
    data = textscan(fid,'%f', 'Delimiter','\t');
    data = transpose(reshape(data{1},[14,length(data{1})/14]));
    n = ["Machine strain";"End-to-end strain";"fiducial strain";"D band strain";...
    "Cross sec strain";"Deformation strain"; "SD Deformation strain";"Height strain";...
    "SD Height strain";"Modulus strain";"SD Modulus strain";"RMS Modulus strain";...
    "(mod-RMS)/(mod + rms) strain"; "Width strain"];
end


figure(1)
if SE == 0
    plot(data(:,x),data(:,y),'.','Color','k','MarkerSize',10)
    xlabel(n(x))
    ylabel(n(y))
    title([n(x),' versus ',n(y)])
else
    for j = 1:(length(SE_list)-1)
        rang = (sampsize(SE_list(j)-13)- 3*s(SE_list(j)-13)+1):sampsize(SE_list(j)-13);
        plot(data(rang,x),data(rang,y),'.','Color','k','MarkerSize',10)
        hold on;
    end
    xlabel(n(x))
    ylabel(n(y))
    title([n(x),' versus ',n(y)])
    hold off;
end


