
%%%%%%%%%%%%%%%% Algorithm 1 %%%%%%%%%%%%%%%%
imatges = imageDatastore('Training-Dataset\Images\*.jpg');
mascaras = imageDatastore('Training-Dataset\Masks-Ideal\*.bmp');

%Parameters
Nbins = 128; %Number of bins in each histogram axis
skin_thr = 0.00005; %Threshold probability for skin
background_thr = 0.0005;

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
    total = total + P;
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

%Show the final histogram and the mask with the specified threshold
figure(1);
bar3(histograma_pell);
xlabel('Cb');
ylabel('Cr');
zlabel('probability');
hist_mask = histograma_pell > skin_thr;
histograma_fons = histograma_fons > background_thr;
figure(2);
imshow(hist_mask, 'InitialMagnification', 1400);
figure(3); 
imshow(histograma_fons, 'InitialMagnification', 1400);

%Store the histogram and the configuration parameters
save('DB_Histogram.mat', 'histograma_pell');
save('Histogram_mask.mat', 'hist_mask');
save('Histogram_background.mat', 'histograma_fons');
save('metadata.mat','Nbins','skin_thr', 'background_thr');
clear;





