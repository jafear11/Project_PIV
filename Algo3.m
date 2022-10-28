
%%%%%%%%%%%%%%%% Algorithm 3 %%%%%%%%%%%%%%%%

directory = dir('Validation-Dataset\Images\*.jpg');
path = what('Validation-Dataset\Images').path;
mkdir('Masks');
ImageFolder = '.\Masks';
SE = ones(5,5); %Structuring element for opening

for k = 1:length(directory)
    
    %Load the image and compute the estimated mask
    file = strcat(path,'\' ,directory(k).name);
    image = imread(file);
    guess = Algo2(image);

    %Morphological open for mask cleaning
    guess = imopen(guess, SE);
    figure(1);imshow(guess);
    
    %Store the mask
    file_name = strrep(directory(k).name, '.jpg', '.bmp');
    fullFileName = fullfile(ImageFolder, file_name);
    imwrite(guess,fullFileName,'bmp');
end
clear;
close all

