imatges = imageDatastore('Training-Dataset\Images\*.jpg');
masqueres = imageDatastore('Training-Dataset\Masks-Ideal\*.bmp');

for k= 1:length(imatges)
    
    %Load the image and the mask
    image = imread('Training-Dataset\Images\0_A_hgr2B_id01_1.jpg');
    mask = imread('Training-Dataset\Masks-Ideal\0_A_hgr2B_id01_1.bmp');

    %Flatten them both
    P = numel(image)/3;
    image_f = reshape(image,P,3);
    mask_f = mask(:);
    %We get an array of only skin pixels
    final = image_f(~ mask_f); %->This doesnt work
    %final = rgb2ycbcr(final);
    histogram(final)    

end


function [output] = flatten(input)
    P = numel(input)/3;
    output = reshape(input,P,3);
end
