
%%%%%%%%%%%%%%%% Algorithm 2 %%%%%%%%%%%%%%%%

function [mask] = Algo2(image)

%Load the database
load("metadata.mat");
load("Histogram_mask.mat");

%Transform the image to the correct color space
image = im2double(image);
image = rgb2ycbcr(image);
[M,N]= size(image(:,:,1));
mask = zeros(M,N);

%We iterate through each pixel
for i=1:M
    for j=1:N
        %We get the Cb and Cr values and normalize them to our histogram
        %bounds
        cb = image(i,j,2);
        cr = image(i,j,3);
        h1 = round((cb-cb_margin(1))/(cb_margin(2)-cb_margin(1))*(Nbins-1)+1);
        h2 = round((cr-cr_margin(1))/(cr_margin(2)-cr_margin(1))*(Nbins-1)+1);

        %We check if that color has passed the threshold in our histogram
        %mask. It's important to check if the value is within bounds
        if (1<h1 && h1<Nbins && 1<h2 && h2<Nbins)
            mask(i,j) = ~hist_mask(h1,h2);
        else
            mask(i,j) = 1;
        end
    end
end
end

