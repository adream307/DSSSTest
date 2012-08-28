function showfft(src,sample_fs)
% fft example
% input:
%      src       -- souce
%      sample_fs -- sample frequence
SRC=fft(src);
SRC=abs(SRC);
SRC=SRC/length(SRC);
FS=linspace(0,sample_fs,length(src));
len=floor(length(src)/2);
figure
plot(FS(1:len),SRC(1:len));
grid on