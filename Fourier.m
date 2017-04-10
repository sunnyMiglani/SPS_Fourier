v1 = imread('characters/V1.GIF');
ftv1 = fftshift( fft2(double(v1)) );

Magq = abs(ftv1);

imagesc(log(abs(ftv1)+1))