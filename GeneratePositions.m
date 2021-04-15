function [X,Y,PDFMae]=GeneratePositions(n)
% n=3
%% Parameters

W=80; % Size of the microcalc window
xtr=0:200; % Dimensions (transition)
diffxtr=diff(xtr);
D=[diffxtr(1),min(diffxtr(1:end-1),diffxtr(2:end)),diffxtr(end)];

PDFMicrocalc=1-mat2gray(fspecial('gauss',W,10));
PDFMae=fspecial('gauss',200,30);

for rls=1:n
    
%% Round 1 - X
PDF=sum(PDFMae(:,:,rls),1);
PDF=PDF/sum(PDF(:));

CDFP=cumsum(PDF);

randu=rand(1,1);
idx=min(sum(repmat(randu,[1 size(CDFP,2)])>=repmat(CDFP,[1 1]),2)+1,numel(xtr));
zout=xtr(idx);
randu=rand(1,1)-0.5;
randu=randu+rand(1,1)-0.5;
zout=zout+randu.*D(idx);
clear idx

X(rls)=round(min(max(zout,1+W/2),200-W/2));

%% Round 2 - Y

PDF=PDFMae(:,round(X(rls)),rls);
PDF=PDF'/sum(PDF(:));

CDFP=cumsum(PDF);

randu=rand(1,1);
idx=min(sum(repmat(randu,[1 size(CDFP,2)])>=repmat(CDFP,[1 1]),2)+1,numel(xtr));
zout=xtr(idx);
randu=rand(1,1)-0.5;
randu=randu+rand(1,1)-0.5;
zout=zout+randu.*D(idx);
clear idx

Y(rls)=round(min(max(zout,1+W/2),200-W/2));

%% Update MotherPDF

temp=PDFMae(:,:,rls);
temp(1+X(rls)-W/2:X(rls)+W/2,1+Y(rls)-W/2:Y(rls)+W/2)=temp(1+X(rls)-W/2:X(rls)+W/2,1+Y(rls)-W/2:Y(rls)+W/2).*PDFMicrocalc;
PDFMae(:,:,rls+1)=temp/sum(temp(:));

end
