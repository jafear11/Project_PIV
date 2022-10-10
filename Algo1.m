
%%%%%%%%%%%%%%%% Algorithm 1 %%%%%%%%%%%%%%%%
imatges = imageDatastore('Training-Dataset\Images\*.jpg');
mascaras = imageDatastore('Training-Dataset\Masks-Ideal\*.bmp');
Nbins = 32;
histograma = zeros(Nbins,Nbins);


for k= 1:length(imatges.Files)
    
    %Load the image and the mask
    image = readimage(imatges,k);
    mask = readimage(mascaras,k);
    mask_f = mask(:);

    %Flatten the image
    P = numel(image)/3;
    image_f = reshape(image,P,3);

    %We get an array of only skin pixels
    final = image_f(~mask_f, :);
    final = im2double(final);
    final = rgb2ycbcr(final);
    colorbar
    histograma = histograma + hist3(final(:,2:3),'Nbins',[Nbins,Nbins]); %%%PROBLEMS WITH NORMALIZATION

end

bar3(histograma)
