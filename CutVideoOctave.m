%Script detects speech and removes silence in a Video!

clear
close all

%Chance for every video!
%File name
filename='2017-01-2519-44-20.mp4';
%frame rate of recorded video
fr=30;

unix(["ffmpeg -y  -i ",filename," -ac 1 ",filename,".wav"]) ;


tic
[y, fs, nbits] = wavread ([filename,".wav"]);

%only if wav file is sterio
if size(y,2)>1
ytmp=y;
y=[];
y=(ytmp(:,1)+ytmp(:,2))/2;
end



figure
plot(y)
cnt=1;
Nfft=1024;
dF=fs/Nfft;
dT=1/fs;
tmax=length(y)/fs;
framemax=floor(tmax*fr);
%generateSpeechzeuch
speech=generateSpeechzeuch(y,fs);


figure
plot(speech)
%Differenzieren um anfang zu erkennen
cnt=1;

difspeech=diff(speech);
for k=1:length(difspeech) 
if (difspeech(k)>0)
  %disp(["Start:",num2str(k)])
  frameidx(cnt,1)=k;
end
if (difspeech(k)<0)
  %disp(["Stop:",num2str(k)])
  frameidx(cnt,2)=k;
  cnt=cnt+1;
end
end
if (frameidx(end,2)==0)
frameidx(end,2)=length(difspeech);
end

zeitindex=frameidx*dT*Nfft/2;
residx=round(zeitindex*30);

cutclass.filename=filename;

for k=1:size(frameidx,1)
cutclass.cut(k,:)=[residx(k,1),residx(k,2)];
end

cutclass.tmax=length(y)/fs;
cutclass.fps=fr;


generateCuttingFile(cutclass);


