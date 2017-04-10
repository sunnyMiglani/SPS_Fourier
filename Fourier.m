v1 = imread('characters/V1.GIF'); s1 = imread('characters/S1.GIF'); t1 = imread('characters/T1.GIF');
ftv1 = fftshift( fft2(double(v1)) ); fts1 = fftshift( fft2(double(s1)) ); ftt1 = fftshift( fft2(double(t1)) );

Magq = abs(ftv1);

figure('Name','Fourier space of V');
imagesc(log(abs(ftv1)+1)); figure('Name','Fourier space of S');
imagesc(log(abs(fts1)+1)); figure('Name','Fourier space of T');
imagesc(log(abs(ftt1)+1));