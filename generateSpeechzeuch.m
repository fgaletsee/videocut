function speech=generateSpeechzeuch(y,fs)
Nfft=1024;
dF=fs/Nfft;
dT=1/fs;

Nstart=ceil(65/dF)
Nstop=ceil(160/dF)

idxmax=floor(length(y)*2/Nfft);
Yges=zeros(idxmax,1);
Ysp=zeros(idxmax,1);


for k=1:idxmax-1
ysamp=y((k-1)*Nfft/2+1:(k-1)*Nfft/2+Nfft);
Ysamp=fft(ysamp);
Yges(k)=sum(abs(Ysamp(1:end)).^2);
Ysp(k)=sum(abs(Ysamp(Nstart:Nstop).^2));
end
toc


figure
plot(Yges)
figure
plot((Ysp./Yges)>0.15)
figure
plot((Ysp./Yges))



%Fenster schieben
ratiothreshold=0.15;
windowvorlauf=50;
windownachlauf=20;
windowsize=200;

ratio=(Ysp./Yges)>ratiothreshold;

winidxmax=length(ratio)-windowsize;


speech=zeros(winidxmax,1);
on=0;
for k=1:length(ratio)-windowsize  

if ((sum(ratio(k:k+windowvorlauf)) > 3) && on==0)
  speech(k)=1;
  on=1;
end

if ((sum(ratio(k:k+windowsize)) > 1) && on==1)
  speech(k)=1;
  on=1;
end

if ((sum(ratio(k:k+windowsize)) ==0) && on==1)
  speech(k:k+windownachlauf)=1;
  on=0;
end

end

return