
%%%%%%%%%%%%%%%% Algorithm 3 %%%%%%%%%%%%%%%%

function[] = Algo3(thr,nfact,show)
tic;
%Default arguments
if nargin==0
    thr = 0.00005;
    nfact = 2;
    show=false;
end

load("Histograms.mat");

%Compute comparative matrix
hist_skin_thr = histograma_pell > thr;
hist_bg_thr = histograma_fons > nfact*histograma_pell;

directory = dir('Validation-Dataset\Images\*.jpg');
path = what('Validation-Dataset\Images').path;
mkdir('Masks');
ImageFolder = '.\Masks';
%Structuring elements
SE1 = ones(7,7); 
SE2 = ones(2,2);


for k = 1:length(directory)

    %Load the image and compute the estimated mask
    file = strcat(path,'\' ,directory(k).name);
    image = imread(file);
    guess = Algo2(image, hist_skin_thr, hist_bg_thr);

    %Morphological operations
    guess = imclose(guess, SE1);
    guess = imdilate(guess, SE2);
    
    if(show)
        figure(1);
        imshow(guess);
    end

    %Store the mask
    file_name = strrep(directory(k).name, '.jpg', '.bmp');
    fullFileName = fullfile(ImageFolder, file_name);
    imwrite(guess,fullFileName,'bmp');
end
clear;
close all
toc;
end

