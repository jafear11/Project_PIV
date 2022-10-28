
%%%%%%%%%%%%%%%% Algorithm 2 %%%%%%%%%%%%%%%%

function [mask] = Algo2(image)

%Load the database
load("metadata.mat");
load("Histogram_mask.mat");
load("Histogram_background.mat");
load("Histogram_background_mask.mat");
load("DB_Histogram.mat");

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
        h1 = round(cb*(Nbins-1) + 1);
        h2 = round(cr*(Nbins-1) + 1);

        %We check if that color has passed the threshold in our histogram
        %mask.

        %mask(i,j) = ~hist_mask(h1,h2);

                if(histograma_fons_mask(h1,h2))
                    mask(i,j) = 1;
                else
                    mask(i,j) = ~hist_mask(h1,h2);
                end
        %         if(~hist_mask(h1,h2))
        %             mask(i,j) = 0;
        %         else
        %             mask(i,j) = histograma_fons_mask(h1,h2);
        %         end

        %mask(i,j) = (histograma_fons(h1,h2)/Scale)> histograma_pell(h1,h2);

    end
end

