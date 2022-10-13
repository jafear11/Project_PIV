
%%%%%%%%%%%%%%%% Algorithm 1 %%%%%%%%%%%%%%%%
imatges = imageDatastore('Training-Dataset\Images\*.jpg');
mascaras = imageDatastore('Training-Dataset\Masks-Ideal\*.bmp');
Nbins = 32;
histograma = zeros(Nbins,Nbins);
x= 0.4:(0.65-0.4)/(Nbins-1) :0.65;
y= 0.35:(0.6-0.35)/(Nbins-1) :0.6;
size=0;

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
    size=size+length(final(:,1));
    histograma = histograma + hist3(final(:,2:3), 'Edges', {y x}); %%%PROBLEMS WITH NORMALIZATION

end
bar3(x,histograma);
xlabel('Cb')
ylabel('Cr')
zlabel('num of pixels')
colormap
colorbar

%Check for dimensionality reduction
origin=640*480*length(imatges.Files);
size=origin/size;
fprintf("Dimensionality reduction "+size+"\n")


