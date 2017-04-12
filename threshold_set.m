function numb = threshold_set( matrix, threshold, sizeLen, sizeWid )
numb = matrix;
for i = 1:sizeLen
    for j = 1:sizeWid
       if matrix(i,j) < threshold
           numb(i,j) = 0;
       end
    end
end
end

