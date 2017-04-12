function numb = noise_filter( matrix, threshold)
numb = matrix;
[sizeLen,sizeWid] = size(matrix);
for i = 1:sizeLen
    for j = 1:sizeWid
       if matrix(i,j) < threshold % lesser than threshold as we want the central (a0) value to be saved
           numb(i,j) = 0;
       end
    end
end
end

