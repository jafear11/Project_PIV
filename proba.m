
imatges = imageDatastore('Training-Dataset\Images\*.jpg');
masks = imageDatastore('Training-Dataset\Masks-Ideal\*.bmp');

error = zeros(length(imatges));

for k = 1:70
    image = readimage(imatges,k);
    mask = readimage(masks,k);
    guess = Algo2(image);
    figure(1);imshow(mask);
    figure(2);imshow(guess);
    unionMask = mask | guess;
    andMask = mask & guess;
    error(k) = nnz(andMask) / nnz(unionMask);
end
fprintf("The mean error is: " + mean(error) + "\n")

