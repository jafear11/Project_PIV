
%%%%%%%%%%%%%%%% Algorithm 2 %%%%%%%%%%%%%%%%

function [mask] = Algo2(image)

%Load the histograms and Nbins
load("metadata.mat");

%Transform the image to the correct color space
image = im2double(image);
image = rgb2ycbcr(image);
[M,N]= size(image(:,:,1));
mask = zeros(M,N);

for i=1:M
    for j=1:N

        %Normalize Cb and Cr to our histogram bounds
        cb = image(i,j,2);
        cr = image(i,j,3);
        h1 = round(cb*(Nbins-1) + 1);
        h2 = round(cr*(Nbins-1) + 1);

        %We check if the color has passed the threshold in our histogram
        %mask.
        if(histograma_fons_mask(h1,h2))
            mask(i,j) = 1;
        else
            mask(i,j) = ~hist_mask(h1,h2);
        end
        
    end
end

