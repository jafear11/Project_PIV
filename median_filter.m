
%%%%%%%%%%%%%%%% Median filter %%%%%%%%%%%%%%%%

function [output] = median_filter(input, filter_size)
[M,N] = size(input);
output = input;
stride = round(filter_size/2);
mask_rows=zeros(M,N);
for i=1:M
    for j=1:(N-filter_size)
        filter = input(i,j:(j+filter_size));
        filter = sort(filter);
        output(i,j+stride) = filter(stride);
    end
end

for i=1:(M-filter_size)
    for j=1:N
        filter = input(i:(i+filter_size),j);
        filter = sort(filter);
        mask_rows(i+stride,j) = filter(stride);
    end
end
output = output | mask_rows;
end