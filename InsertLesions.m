clear;
close all;
clc;

%% This code does the whole thing - it generates artificial clusters,
% finds candidate positions depending on the breast density and
% insert the lesion in a clinical case.

%% OBS: This code uses LIBRA to estimate density. Please refer to
% https://www.pennmedicine.org/departments-and-centers/department-of-radiology/radiology-research/labs-and-centers/biomedical-imaging-informatics/cbig-computational-breast-imaging-group
% for more information.


Contrast=0.4;for k=2:15 Contrast(k)=Contrast(k-1)*0.85; end
NumPat=1;
Save=1;

PathIndividualCalcs='Individual Calcifications';
PathPatientCases='PatientData';
PathDensityMask= [PathPatientCases filesep 'PatientDensity'];
PathOutput='Output';
PathToolkit=['dcmtk-3.6.6-linux-x86_64-static' filesep 'bin'];
PathLibra = 'LIBRA-1.0.4';

addpath(genpath(PathLibra));
addpath('aux_files');

for P=1:NumPat
    
    [Mask,PDFMae]=CreateCluster(PathIndividualCalcs); % Creates the cluster (PDFMae just for visual understanding of the position PDF)
    SimulationInfo{P}.Mask=Mask; % Saves simulation info inside a structure for later reference
    
    Patient=single(dicomread([PathPatientCases filesep 'Mammo_' num2str(P)])); % Loads image
    Header = dicominfo([PathPatientCases filesep 'Mammo_' num2str(P)]);
    
    if exist([PathDensityMask filesep 'Result_Images' filesep 'Masks_Mammo_' num2str(P) '.mat'])==0
        
        if strncmp(computer,'PC',2)
            system(['libra.exe ' '"' PathPatientCases '/Mammo_' num2str(P) '"' ' ' '"' PathDensityMask '"' ' 1']);
        else  % isunix
            libra_startup
        
            % Runs LIBRA to get density mask
            libra([PathPatientCases filesep 'Mammo_' num2str(P)], PathDensityMask, 1);
        end
        
        load([PathDensityMask filesep 'Result_Images' filesep 'Masks_Mammo_' num2str(P) '.mat']); % Loads density map

    else
        load([PathDensityMask filesep 'Result_Images' filesep 'Masks_Mammo_' num2str(P) '.mat']); % Loads density map
    end
    
    %% This makes sure that the cluster is not inserted too close to the skin or
    % too close to the chestwall.
    res.BreastMask(:,end)=0;
    res.BreastMask(:,1)=0;
    ErodedMask=imerode(res.BreastMask, strel('disk',floor(size(Mask,1)/2)));
    CleanDensity=bwmorph(res.DenseMask,'clean');
    PossiblePoints=ErodedMask.*CleanDensity;
    
    %% This chooses one of the possible coordinates to be the position of
    % the center of the cluster.
    [I J]=find(PossiblePoints==1);
    Poss=[I J];
    Point = datasample(1:size(Poss,1),1,'Replace',false);
    Coordinates=Poss(Point,:);
    SimulationInfo{P}.Coordinates=Coordinates; % Saves simulation info inside a structure for later reference
    
    for cc=1:length(Contrast) % This loop will insert the exact same cluster at the exact same location at different contrasts
        
        disp(['Processing patient ' num2str(NumPat) ' from ' num2str(NumPat) ', contrast ' num2str(cc) ' from ' num2str(length(Contrast))]);
        
        %%
        MaskN=Mask;
        MaskN(Mask~=0)=MaskN(MaskN~=0)*(Contrast(cc));
        MaskN=abs(MaskN-1);
        
        %%
        ImgL=Patient;
        ImgL(Coordinates(1)-ceil(size(Mask,1)/2):Coordinates(1)+floor(size(Mask,1)/2)-1,Coordinates(2)-ceil(size(Mask,1)/2):Coordinates(2)+floor(size(Mask,1)/2)-1)=Patient(Coordinates(1)-ceil(size(Mask,1)/2):Coordinates(1)+floor(size(Mask,1)/2)-1,Coordinates(2)-ceil(size(Mask,1)/2):Coordinates(2)+floor(size(Mask,1)/2)-1).*MaskN;
        if Save
            
            if(~exist(PathOutput,'dir'))
                mkdir(PathOutput)
            end
            
            Address_Original=[PathPatientCases filesep 'Mammo_' num2str(P)];
            Address_New=[PathOutput filesep 'Mammo_' num2str(P) '_Lesion' num2str(100*Contrast(cc)) '.dcm'];
            
            dicomwrite(uint16(ImgL), Address_New, Header, 'CreateMode', 'copy');

            %generateDicom(ImgL,Address_Original,Address_New,PathToolkit)
            
        end
    end
end
if Save
    save([PathOutput filesep 'SimulationInfo.mat'],'SimulationInfo')
end
