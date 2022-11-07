
%%%%%%%%%%%%%%%% Algorithm 1 %%%%%%%%%%%%%%%%

imatges = imageDatastore('Training-Dataset\Images\*.jpg');
mascaras = imageDatastore('Training-Dataset\Masks-Ideal\*.bmp');

Nbins = 128; %Number of bins in each histogram axis

total = 0;
histograma_pell = zeros(Nbins,Nbins);
histograma_fons = zeros(Nbins, Nbins);
margins= 0:1/(Nbins-1):1;


for k= 1:length(imatges.Files)
    
    %Load the image and the mask
    image = readimage(imatges,k);
    mask = readimage(mascaras,k);
    mask_f = mask(:);

    %Flatten the image
    P = numel(image)/3;
    total  = total +P;
    image_f = reshape(image,P,3);

    %We get an array of only the target pixels
    skin = image_f(~mask_f, :);
    background = image_f(mask_f,:);
    skin = im2double(skin);
    skin = rgb2ycbcr(skin);
    background = im2double(background);
    background = rgb2ycbcr(background);

    %Compute the histograms
    histograma_pell = histograma_pell + hist3(skin(:,2:3), 'Edges', {margins margins}); 
    histograma_fons = histograma_fons + hist3(background(:,2:3), 'Edges', {margins margins});

end

%Normalize the histogram
histograma_pell = histograma_pell / total;
histograma_fons = histograma_fons / total;

%Show the final histogram and the mask with the specified threshold
f1=figure(1);
bar3(histograma_pell);
xlabel('Cb');
ylabel('Cr');
zlabel('probability');

%Store the histograms and the configuration parameters
save('Nbins.mat', 'Nbins');
save('Histograms.mat', 'histograma_fons', 'histograma_pell');
clear





