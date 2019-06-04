function [dpeak,dpeak_check,RMS] = fourier_profile(data,datasize,avrange,flow,fhigh,plot_decision,dcheck)
	%cutting out long distance average of 31 pixels, to isolate dband signal
    X_all = squeeze(data(:,:,:,1,:));
    Y_all = squeeze(data(:,:,:,2,:));
    S = size(Y_all);
    
    RMS = NaN(S(1),S(2),S(3));
    dpeak = NaN(S(1),S(2),S(3));
    dpeak_check = NaN(S(1),S(2),S(3));
    
    for i = 1:S(1)
        for j = 1:S(2)
            for k = 1:S(3)
                X = squeeze(X_all(i,j,k,:))/1000;
                X = X(find(X>=0));
                Y = squeeze(Y_all(i,j,k,:));
                Y = Y(find(Y>=0));
                Y_av = zeros((length(Y)-avrange),1);
                if length(Y)>0
                    for z = ((avrange/2) +1):(length(Y)-(avrange/2))
                        Y_av(z-(avrange/2))= sum(Y((z-(avrange/2)):(z+(avrange/2))))/(avrange+1);
                    end

                    %%%Local-average-subtracted profile%%%
                    Y1 = Y(((avrange/2)+1):(length(Y)-(avrange/2)))-(Y_av);

                    %length of fft (datapoints), needs to be twice the number of
                    %interpolation points, since half of FFT is not plotted
                    nfft= 2*datasize;
                    %Linear interpolation of data set, to length of datasize (power
                    %of 2). c1 has ends cut because of avrange pixel average
                    X1 = X(((avrange/2)+1):(length(X)-(avrange/2)),1);
                    Xi = transpose(X1(1):((X1(end)-X1(1))/(datasize-1)):X1(end));
                    Yi = interp1(X(((avrange/2)+1):(length(X)-(avrange/2))),Y1,Xi);

                    %root mean square of running-average-subtracted profile
                    RMS(i,j,k) = rms(Yi-mean(Yi));

                    %generates hanning window, to multiply data by
                    window = transpose(0.5 - 0.5*cos(2*pi*linspace(0,1,datasize)));

                    %FFT is symmetric (positive, negative frequency) so throw away half
                    FFT= fft(window.*(Yi-mean(Yi)),nfft);
                    FFT= FFT(1:nfft/2);
                    mFFT = abs(FFT).^2;

                    %Frequency vector, steps of how many data in profile/number of points in fft
                    f = (1/(Xi(end)-Xi(1)))*(0:((nfft/2)-1))*datasize/nfft; %f = (0:((nfft/2)-1))*length(data)/length(FFT);

                    %Maximum of power spectra, beyond first 1/10 of fft datapoints
                    frange = find((f>flow)&(f<fhigh));
                    fmin = frange(1);
                    fmax = frange(end);
                    f_dpeak = f(find(mFFT == max(mFFT(fmin:fmax))));
                    dpeak(i,j,k) = 1000/f_dpeak;

                    %%%If plot_decision==1, then plot the locally averaged
                    %%%profile and original profile%%%
                    if plot_decision
                        figure(1)
                        plot(Yi)
                        set(gca,'xtick',[])

                        figure(2)
                        plot(Y)
                        set(gca,'xtick',[])
                    end
                    if dcheck
                        figure(3)
                        plot(f,mFFT)
                        hold on;
                        plot(f_dpeak,mFFT(find(f==f_dpeak)),'*');
                        hold off;
                        xlabel('1/\mu m')
                        xlim([0 25])
                        dpeak_check(i,j,k) = input('good enough peak finding? (0 for no, 1 for yes):  ');
                    end
                end
            end
        end
    end
end