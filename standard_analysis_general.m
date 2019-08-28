clear;
clc;
main_path = 'C:\Users\Chris\Desktop\school\Dalhousie\DATA_Chris\AFM_data\Spring summer 2018\SE\processed data\all_images_summary\all_modulus_summary\';
datasize = 256;

%%%Read in data from directory, output filenames, average and standard
%%%deviation, periodicity (dpeak) and RMS
[data,files]= data_read_general(main_path,14);
[Average,STD] = mean_std_general(data);
[dpeak,dpeak_check,RMS] = fourier_profile_general(data,datasize,30,10,20,0,0);

%%%apply check filter on frequency peak values%%%
dpeak = dpeak.*dpeak_check;
dpeak(dpeak==0) = NaN;

%%%Save data to main directory%%%
save([main_path,'pipeline_output.mat'],'files','data','Average','STD','dpeak','RMS')