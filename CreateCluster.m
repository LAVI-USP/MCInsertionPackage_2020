function [ROI,PDFMae]=CreateCluster(PathIndividualCalcs)

N=datasample(4:6,1,'Replace',false);
[X,Y,PDFMae]=GeneratePositions(N);

ROI=zeros(200);
calcs=datasample(1:50,N,'Replace',false);
contrasts=[1 datasample(linspace(.5,1,100),N-1,'Replace',false)];

StackROI=[];

for k=1:N
    Calc=double(imread([PathIndividualCalcs '\Calc' num2str(calcs(k)) '.png']));
    Calc=contrasts(k)*Calc(:,:,1)/max(max(Calc(:,:,1)));
    ROI(1+X(k)-5:X(k)+5,1+Y(k)-5:Y(k)+5)=ROI(1+X(k)-5:X(k)+5,1+Y(k)-5:Y(k)+5)+Calc;
    StackROI=cat(3,StackROI,ROI);
end

