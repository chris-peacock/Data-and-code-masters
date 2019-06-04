clear;
clc;
main_path = 'C:\Users\Chris\Desktop\school\Dalhousie\DATA_Chris\AFM_data\SE\all_images_summary\';
Dat = NaN(21,7,3,2,350,3);
Av = NaN(21,7,3,3);
SD = NaN(21,7,3,3);
datashape = [21,7,3,350];
datasize = 256;
charpos = {3:4,11:12,20};

for i = 1:3
    if i ==1
        directory_path = [main_path,'all_deformation_summary\'];
    elseif i==2
        directory_path = [main_path,'all_height_summary\'];
    elseif i==3
        directory_path = [main_path,'all_modulus_summary\'];
    end

    [data,files]= data_read(directory_path,datashape,charpos,14);
    [Average,STD] = mean_std(data);
    
    if i==3
        [dpeak,dpeak_check,RMS] = fourier_profile(data,datasize,30,10,20,0,0);
    end
    Dat(:,:,:,:,:,i) = data;
    Av(:,:,:,i) = Average;
    SD(:,:,:,i) = STD;
end

%%%apply check filter on frequency peak values%%%
dpeak = dpeak.*dpeak_check;
dpeak(dpeak==0) = NaN;

%%%Save data to main directory%%%
save([main_path,'pipeline_output.mat'],'files','Dat','Av','SD','dpeak','RMS')
