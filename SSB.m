clear
[Y,Fs]=audioread('eric.wav');%Read the signal
Fvec=linspace(-Fs/2,Fs/2,length(Y));%frequency axis
Y_F=fftshift(fft(Y));%fft
filter1=linspace(-Fs/2,Fs/2,length(Y_F));%create an array of the same length of the signal
filter1(1:end)=1;%making all element =1
filter1([1:171353 239895:end])=0;%zeros at certain inecies to make an ideal filter at 4k
filter1=filter1';%trans
mt=filter1.*Y_F;%product in freq to filter the message
m=real(ifft(ifftshift(mt)));%returnning to time f=domain
% sound(t1,Fs);%play sound
figure;
subplot(2,1,1);
plot(Fvec,abs(mt));%plotting m(t) in freq=domain
title('Frequency Domain - Modulated Signal');
fc=100000;%carrier frequency
Fs_new=fc*5;%new sampling frequency
m=resample(m,Fs_new,Fs);%up sampling the message
t=[0:length(m)-1]/Fs_new;%creating time variable has the same length of upsampled message
c=cos(2*pi*fc*t);%creating the carrier
m=m';%trans
DSBSC=m.*c;%creating DSBSC by multiply carrier with the signal
DSBSC_F=fftshift(fft(DSBSC));%freq domain
Fvec2=linspace(-Fs_new/2,Fs_new/2,length(DSBSC_F));%frequency domain x axis 
subplot(2,1,2);
plot(Fvec2,abs(DSBSC_F));
title('Frequency Domain - DSBSC');
%SSB using ideal filter
f2=linspace(-Fs_new/2,Fs_new/2,length(DSBSC_F));%creating ideal filter to take LSB only
f2(1:end)=1;
f2([1:1285150 2998684:end])=0;%zero at certain inecies
SSB_F=f2.*DSBSC_F;%filtering DSB to make it SSB
SSBSC=real(ifft(ifftshift(SSB_F)));% return to time domain
figure;
plot(Fvec2,abs(SSB_F));
title('Frequency Domain - SSBSC');
%cohernt detection of SSBSC
out1=SSBSC.*c;% coherent detection multiply by the carrier
fout1=fftshift(fft(out1));%fft
persample=Fs_new/length(fout1);%calcualte the ratio hz/sample
target1=round((-4000+Fs_new/2)/persample);%get the  lower index to filter the messsage
target2=round((4000+Fs_new/2)/persample);%get the upper index
fout1([1:target1 target2:end])=0;%filtirng the signal
out1=real(ifft(ifftshift(fout1)));%returnning to time domaain
figure;
subplot(2,1,2)
plot(Fvec2,abs(fout1));
title('Frequency Domain - Recived SSB-SC');
subplot(2,1,1)
plot(Fvec2,abs(out1));
title('Time Domain - Recived SSB-SC');
out1=resample(out1,Fs,Fs_new);%back to original FS
%sound(out1,Fs);%play sound
%SSB-SC using butterWorth filter
[q, e] = butter(4,(fc/(Fs_new/2)));%create butter worth filter
SSB_Butter= filter(q,e,DSBSC);%filtering the signal with the butter worth lowpass filter
SSB_Butter_F=fftshift(fft(SSB_Butter));%fft
figure;
plot(Fvec2,abs(SSB_Butter_F))
title('Frequency Domain - SSBSC  ButterWorth Filter');
%cohernt detection of SSBSC From butter worth filter
out2=SSB_Butter.*c;%coherent detection multiply by the carrier
fout2=fftshift(fft(out2));%fft
fout2([1:target1 target2:end])=0;%filtirng the signal
out2=real(ifft(ifftshift(fout2)));%returnning to time domaain
figure;
subplot(2,1,2)
plot(Fvec2,abs(fout2));
title('Frequency Domain - Recived SSB-SC ButterWorth Filter');
subplot(2,1,1)
plot(Fvec2,abs(out2));
title('Time Domain - Recived SSB-SC ButterWorth Filter');
out2=resample(out2,Fs,Fs_new);%back to original FS
%sound(out2,Fs);%play sound
%Noise with the recieved signal
SSBSC_noise=awgn(SSBSC,0);%adding noise with zero SNR
%cohernt detection of SSBSC with noise
out1=SSBSC_noise.*c;%coherent detection multiply by the carrier
fout1=fftshift(fft(out1));%fft
fout1([1:target1 target2:end])=0;%filtirng the signal
out1=real(ifft(ifftshift(fout1)));%returnning to time domaain
figure;
subplot(3,2,1)
plot(Fvec2,abs(fout1));
title('F Domain-Recived SSB-SC SNR=0');
subplot(3,2,2)
plot(Fvec2,abs(out1));
title('T Domain-Recived SSB-SC SNR=0');
out1=resample(out1,Fs,Fs_new);%back to original FS
%sound(out1,Fs);%play sound
%Noise with the recieved signal
SSBSC_noise=awgn(SSBSC,10);%adding noise with 10 SNR
%cohernt detection of SSBSC with noise
out1=SSBSC_noise.*c;%coherent detection multiply by the carrier
fout1=fftshift(fft(out1));%fft
fout1([1:target1 target2:end])=0;%filtirng the signal
out1=real(ifft(ifftshift(fout1)));%returnning to time domaain
subplot(3,2,3)
plot(Fvec2,abs(fout1));
title('F Domain-Recived SSB-SC SNR=10');
subplot(3,2,4)
plot(Fvec2,abs(out1));
title('T Domain-Recived SSB-SC SNR=10');
out1=resample(out1,Fs,Fs_new);%back to original FS
%sound(out1,Fs);%play sound
%Noise with the recieved signal
SSBSC_noise=awgn(SSBSC,30);%adding noise with 30 SNR
%cohernt detection of SSBSC with noise
out1=SSBSC_noise.*c;%coherent detection multiply by the carrier
fout1=fftshift(fft(out1));%fft
fout1([1:target1 target2:end])=0;%filtirng the signal
out1=real(ifft(ifftshift(fout1)));%returnning to time domaain
subplot(3,2,5)
plot(Fvec2,abs(fout1));
title('F Domain-Recived SSB-SC SNR=30');
subplot(3,2,6)
plot(Fvec2,abs(out1));
title('T Domain-Recived SSB-SC SNR=30');
out1=resample(out1,Fs,Fs_new);%back to original FS
%%sound(out1,Fs);%play sound
%generate a SSB-TC
DC=2*max(m);%make the DC value dounle the max of the signal that make modulation index=0.5
DSBTC=(DC+m).*c;%create DSB-TC signal
DSBTC_F=fftshift(fft(DSBTC));%fft
%SSBTC using ideal filter
f2=linspace(-Fs_new/2,Fs_new/2,length(DSBTC_F));%crate the filter
f2(1:end)=1;
f2([1:1285150 2998684:end])=0;%zero at certain inecies
SSB_F=f2.*DSBTC_F;%filtering to get SSB-TC
SSBTC=real(ifft(ifftshift(SSB_F)));%returnning back to time domain
%recieve SSB-TC
env=abs(hilbert(SSBTC));%envelope detection
figure;
plot(Fvec2,env)
title('T Domain-Recived SSB-TC');
env=resample(env,Fs,Fs_new);%back to original FS
sound(env,Fs);%play sound



