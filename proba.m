imatges = imageDatastore('Training-Dataset\Images\*.jpg');


for k = 5:length(imatges.Files)
    imatge = readimage(imatges,k);
    imshow(Algo2(imatge))
    pause(0.1)
end