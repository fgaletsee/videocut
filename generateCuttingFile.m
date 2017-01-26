%generate cutiing File
%Ersetzen

function generateCuttingFile(cutclass)

fid = fopen ("VorlageNeu.kdenlive");
text = char (fread (fid, "uchar")');
fclose (fid);
%Werte ersetzen
%Runtimeorginal
tmax=cutclass.tmax;


zeith=floor(tmax/60/60)
zeitmin=floor(tmax/60)
zeitsec=floor(tmax-zeitmin*60)
zeitms=floor((tmax-zeitmin*60-zeitsec)*60);
strzeitgesmat=[sprintf('%02d',zeith),':',sprintf('%02d',zeitmin),':',sprintf('%02d',zeitsec),':',sprintf('%02i',zeitms)];
text=strrep (text, "$runtimeorginal$",strzeitgesmat);

%framemax 
framemax=floor(tmax*cutclass.fps)

text=strrep (text, "$framemax$",num2str(framemax));
%filename
text=strrep (text, "$filename$",cutclass.filename);
str='';
%cutout
for k=1:size(cutclass.cut,1)
 str=[str,"\n<entry out=\"",num2str(cutclass.cut(k,2)) ,"\" producer=\"1_playlist3\" in=\"",num2str(cutclass.cut(k,1)),"\"/>"];
end
text=strrep (text, "$cutout$",str);

%newvideolength

newvideoframelegth=0;
for k=1:size(cutclass.cut,1)
newvideoframelegth=newvideoframelegth+cutclass.cut(k,2)-cutclass.cut(k,1);
end
newvideoframelegth=newvideoframelegth+size(cutclass.cut,1); %Add becuase of adding ;)
text=strrep (text, "$newvideoframelegth$",num2str(newvideoframelegth));
tneu=newvideoframelegth/cutclass.fps;

%Runtimeneu
zeith=floor(tneu/60/60)
zeitmin=floor(tneu/60)
zeitsec=floor(tneu-zeitmin*60)
zeitms=floor((tneu-zeitmin*60-zeitsec)*60);
strzeitneu=[sprintf('%02d',zeith),':',sprintf('%02d',zeitmin),':',sprintf('%02d',zeitsec),':',sprintf('%02i',zeitms)];
%text=strrep (text, "$runtimeorginal$",strzeitgesmat);


fid = fopen ("Vorlage_manipuliert.kdenlive", "w");
fprintf (fid, "%s\n", text);
fclose (fid);

