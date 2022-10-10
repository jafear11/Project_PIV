imatges = imageDatastore('Training-Dataset\Images\*.jpg');
masqueres = imageDatastore('Training-Dataset\Masks-Ideal\*.bmp');

for k= 1:length(images)
    image = imread(imatges.Files(k).name);
    

end
