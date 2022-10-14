
%%%%%%%%%%%%%%%% Algorithm 1 %%%%%%%%%%%%%%%%
imatges = imageDatastore('Training-Dataset\Images\*.jpg');
mascaras = imageDatastore('Training-Dataset\Masks-Ideal\*.bmp');

%Parameters
Nbins = 64; %Number of bins in each histogram axis
threshold = 1000; %Number of pixels necessary in the database for that color to be considered relevant
cb_margin = [0.35 0.6]; %Margin from which to make histogram bins in Cb axis
cr_margin = [0.4 0.65]; %Margin from which to make histogram bins in Cr axis

histograma = zeros(Nbins,Nbins);
cb= cb_margin(1):(0.6-0.35)/(Nbins-1) :cb_margin(2);
cr= cr_margin(1):(0.65-0.4)/(Nbins-1) :cr_margin(2);

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
    histograma = histograma + hist3(final(:,2:3), 'Edges', {cb cr}); %%%PROBLEMS WITH NORMALIZATION

end
figure(1);
bar3(cb,histograma);
xlabel('Cb')
ylabel('Cr')
zlabel('num of pixels')
colormap
colorbar
save('DB_Histogram.mat', 'histograma');
hist_mask = histograma > threshold;
figure(2);
imshow(hist_mask, 'InitialMagnification', 1400);
save('Histogram_mask.mat', 'hist_mask');
fid = fopen('metadata.txt', 'wt');
fprintf(fid, ...
    "Nbins: " + Nbins + "\n" + ...
    "Cb_margins: " + cb_margin(1) + "-" + cb_margin(2) + "\n" + ...
    "Cr_margins: " + cr_margin(1) + "-" + cr_margin(2)+ "\n");





