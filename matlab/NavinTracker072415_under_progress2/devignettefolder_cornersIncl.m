function devignettefolder_cornersIncl(folder,cornerLengths)
%run through a folder of tifs and devignette all of them.
%creates a new file "foo-devig.tif" for every file "foo.tif"

%correct for vignetting for all .tifs in a folder
%needs a calibrationmatrix generated by devignettecalibrate.m
%
%Saul Kato
%04/18/2013

%%%%%%Modified Saul's code to include corner exclusion and to run from a
%%%%%%master directory  -  Steven Flavell, 3/13/14

cd(folder);
fnames=dir('*.tif');

mkdir('devig');

disp('using default calibration matrix');
ps=load('devignettecal.mat');
calibrationmatrix=ps.p;

for i=1:length(fnames)
    tifname=fnames(i).name;   
    X=tiffread2(tifname);
    Xout=devignette(X.data,calibrationmatrix);
    %%%Now remove corners from Xout
    Xout2=cornermask(Xout,cornerLengths);
    %%%
    outputfilename=['devig/' tifname(1:end-4) '-devig.tif'];
    imwrite(Xout2,outputfilename,'tif','Compression','none')
end

cd ..

end


function imgout=devignette(imgin,calibrationmatrix)

imgout=zeros(size(imgin),'uint16');
for i=1:size(imgin,1)
    for j=1:size(imgin,2)
        imgout(i,j)=uint16((double(imgin(i,j))-calibrationmatrix(2,i,j))/calibrationmatrix(1,i,j));
    end
end

end

function imgout_crnr=cornermask(X,cornerLengths)

    imgout_crnr=X;
    
    Xwidth = length(X(:,1));
    Xheight = length(X(1,:));
    
    %corner 1
    for j=1:cornerLengths(1)   
            imgout_crnr(j,1:cornerLengths(1)-j+1)=0;
    end

    %corner 2
    for j=1:cornerLengths(2)    
            imgout_crnr(j,Xwidth-cornerLengths(2)+j-1:Xwidth)=0;
    end
    
    %corner 3
    for j=Xheight-cornerLengths(3) : Xheight
            imgout_crnr(j,Xwidth-  (j-Xheight+cornerLengths(3) ) :Xwidth)=0;
    end
    
    %corner 4
    for j=Xheight-cornerLengths(4) : Xheight
            imgout_crnr(j,1:  1+j+(cornerLengths(4)-Xheight)     )=0;
    end

end