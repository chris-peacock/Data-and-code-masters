clc
clear
clf

numstrain = 7;
strainskip = -1;
%number of pixels average
avrange = 30;
y = 11; %10+x = sample number

fname = 'SE13_fib1_';
pname = 'C:\Users\Chris\Desktop\school\Dalhousie\DATA_Chris\AFM_images\SE\071018_SE13\mod_summary\';
cd C:\Users\Chris\Desktop\school\Dalhousie\DATA_Chris\AFM_images\SE\071018_SE13\mod_summary\

%Import relevant length strain data
data_l = zeros(1,7);
fid_l = fopen('C:\Users\Chris\Desktop\school\Dalhousie\DATA_Chris\AFM_images\SE\fibstrain_data_1.txt');
data_length = textscan(fid_l,'%f', 'Delimiter','\t','HeaderLines',1);
data_l(1:7) = data_length{1}((9*(y-1)+2):(9*(y-1)+8));
data_l = 100*((data_l(1:7)/data_l(1))-1);
fclose('all')

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
reg2_dband = zeros(numstrain,1);
reg3_dband = zeros(numstrain,1);
reg4_dband = zeros(numstrain,1);
dpeak = zeros(numstrain,3);
RMS = zeros(numstrain,3);

if strainskip ~= -1
    numstrain = numstrain+1;
end
fclose('all')
x = 1;
for i = 1:numstrain
    strain = 5*(i-1);
    if strain == strainskip
        reg2_dband(i) = 0;
        reg3_dband(i) = 0;
        reg4_dband(i) = 0;
        ndata_all = 0;
    else
        %also 1:3 for some sets
        for j = 2:4
            %find datafile specific to strain, region number and sample
            %number
            thisfile_index = startsWith(files,[fname, int2str(strain), 'strain_',int2str(j)]);
            thisfile = files(find(thisfile_index==1));
            fid = fopen(strcat(pname,convertStringsToChars(thisfile)));
            data_pre = textscan(fid,'%f', 'Delimiter','\t','HeaderLines',12);
        
            for k = 1:((length(data_pre{1}))/2)
              for q = 1:2  
                (2*(k-1))+q;
                data(k,q) = data_pre{1}((2*(k-1))+q);
              end
            end

            X = data(1:length(data(:,1)),1)/1000; %default units: nanometres, div by 1000 for um
            Y = data(1:length(data),2); %default units: nanopascals, div by 10^15 for MPa
            %test function for Y
            %Y = (sin(32*pi*X));
            
            %cutting out long distance average of 31 pixels, to isolate dband signal
            Y_av = zeros((length(Y)-avrange),1);
            for z = 16:(length(Y)-(avrange/2))
                Y_av(z-15)= sum(Y((z-15):(z+(avrange/2))))/(avrange+1);
            end
            Y = Y(((avrange/2)+1):(length(Y)-(avrange/2)))-(Y_av);

            %length of interpolation of data (has issues if datasize too large when line profile short)
            datasize = 256;
            %length of fft (datapoints), needs to be twice the number of
            %interpolation points, since half of FFT is not plotted
            nfft= 2*datasize;%1024;

            %length of interpolation of data (has issues if datasize too large when line profile short)
            %{
            if length(X) < 2048
              datasize = 2^nextpow2(length(X));
            else
              datasize = 2048;
            end
            %}
            
            %Linear interpolation of data set, to length of datasize (power
            %of 2). c1 has ends cut because of avrange pixel average
            c1 = data(((avrange/2)+1):(length(X)-(avrange/2)),1)/1000;
            Xi = transpose(c1(1):((c1(end)-c1(1))/(datasize-1)):c1(end));
            Yi = interp1(X(((avrange/2)+1):(length(X)-(avrange/2))),Y,Xi);
            
            %root mean square of running-average-subtracted profile
            RMS(i,j-1) = rms((Yi-mean(Yi))/(1E15));
            
            %generates hanning window, to multiply data by
            window = transpose(0.5 - 0.5*cos(2*pi*linspace(0,1,datasize)));
            
            FFT= fft(window.*(Yi-mean(Yi)),nfft);

            %FFT is symmetric (positive, negative frequency) so throw away half
            FFT= FFT(1:nfft/2);%FFT= FFT(1:length(FFT)/2); 

            %modulus of FFT
            mFFT = abs(FFT).^2;

            %Frequency vector, steps of how many data in profile/number of points in fft
            f = (1/(Xi(end)-Xi(1)))*(0:((nfft/2)-1))*datasize/nfft; %f = (0:((nfft/2)-1))*length(data)/length(FFT);

            %Maximum of power spectra, beyond first 1/10 of fft datapoints
            frange = find((f>12)&(f<20));
            fmin = frange(1);
            fmax = frange(end);
            f_dpeak = f(find(mFFT == max(mFFT(fmin:fmax))));
            dpeak(i,j-1) = 1000/f_dpeak;
            
            figure(x)
            plot(f,mFFT)
            hold on
            plot(f_dpeak,mFFT(find(mFFT == max(mFFT(fmin:fmax)))),'*','Color','r')
            xlabel('frequency (1/\mum)')
            ylabel('Intensity')
            xlim([0,30])
            title(['strain = ',num2str(strain),', region ',num2str(j-1)])
            %}
            x = x +1;
        end
    end
end

figure (x+1)
subplot(3,1,1)
plot(data_l(1:length(dpeak(:,1))),dpeak(:,1),'*')
xlim([-1 (max(data_l)+3)])
ylim([60 72])
xlabel('feducial strain (%)')
ylabel('dband length (nm)')
title(['SE',num2str(y+10),' region 1'])
subplot(3,1,2)
plot(data_l(1:length(dpeak(:,1))),dpeak(:,2),'*')
xlim([-1 (max(data_l)+3)])
ylim([60 72])
xlabel('feducial strain (%)')
ylabel('dband length (nm)')
title(['SE',num2str(y+10),' region 2'])
subplot(3,1,3)
plot(data_l(1:length(dpeak(:,1))),dpeak(:,3),'*')
xlim([-1 (max(data_l)+3)])
ylim([60 72])
xlabel('feducial strain (%)')
ylabel('dband length (nm)')
title(['SE',num2str(y+10),' region 3'])

%dlmwrite([pname,'dpeak_FFT.txt'],transpose(dpeak));
%dlmwrite([pname,'RMS_m.txt'],transpose(RMS));