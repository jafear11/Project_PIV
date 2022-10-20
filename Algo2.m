
%%%%%%%%%%%%%%%% Algorithm 2 %%%%%%%%%%%%%%%%
%%hola javi

function [mask] = Algo2(image)
load("metadata.mat");
load("Histogram_mask.mat");
image = im2double(image);
image = rgb2ycbcr(image);
[M,N]= size(image(:,:,1));
mask = zeros(M,N);
CBH=0;
CRH=0;
CBL=0;
CRL=0;
for i=1:M
    for j=1:N
        cb = image(i,j,2);
        cr = image(i,j,3);
        h1 = round((cb-cb_margin(1))/(cb_margin(2)-cb_margin(1))*(Nbins-1)+1);
        h2 = round((cr-cr_margin(1))/(cr_margin(2)-cr_margin(1))*(Nbins-1)+1);

        if (1<h1 && h1<Nbins && 1<h2 && h2<Nbins)
            mask(i,j) = ~hist_mask(h1,h2);
        else
            mask(i,j) = 1;
        end
    end
end

end
