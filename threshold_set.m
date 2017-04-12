function numb = threshold_set( matrix, threshold )
[sizeLen,sizeWid] = size(matrix);
numb = matrix;
for i = sizeLen
    for j = sizeWid
       if matrix(i,j) > threshold
           numb(i,j) = 0;
       end
    end
end
end

