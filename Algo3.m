
%%%%%%%%%%%%%%%% Algorithm 3 %%%%%%%%%%%%%%%%

directory = dir('Validation-Dataset\Images\*.jpg');
path = what('Validation-Dataset\Images').path;
mkdir('Masks');
ImageFolder = '.\Masks';

for k = 1:length(directory)
    file = strcat(path,'\' ,directory(k).name);
    image = imread(file);
    guess = Algo2(image);
    figure(1);imshow(guess);
    file_name = strrep(directory(k).name, '.jpg', '.bmp');
    fullFileName = fullfile(ImageFolder, file_name);
    imwrite(guess,fullFileName,'bmp');
end
clear;
close all
