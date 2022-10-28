
%%%%%%%%%%%%%%%% Algorithm 1 %%%%%%%%%%%%%%%%

imatges = imageDatastore('Training-Dataset\Images\*.jpg');
mascaras = imageDatastore('Training-Dataset\Masks-Ideal\*.bmp');

%Parameters
Nbins = 128; %Number of bins in each histogram axis
skin_thr = 0.0003; %Probability threshold for skin pixels
background_thr = 0.001; %Probability threshold for bg pixels

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

    %We get an array of only skin pixels
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
hist_mask = histograma_pell > skin_thr;
histograma_fons_mask = histograma_fons > background_thr;

%Show the final histogram and the mask with the specified threshold
f1=figure(1);
bar3(histograma_pell);
xlabel('Cb');
ylabel('Cr');
zlabel('probability');


%Show the masks for both histograms
f2=figure(2);
imshow(hist_mask, 'InitialMagnification', 1400);

f3=figure(3); 
imshow(histograma_fons_mask, 'InitialMagnification', 1400);

%Store the histograms and the configuration parameters
save('Metadata.mat', 'Nbins', 'hist_mask', 'histograma_fons_mask');
clear all





