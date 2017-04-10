
%#just change the file path to load the image.
v1 = imread('characters/V2.GIF'); s1 = imread('characters/S2.GIF'); t1 = imread('characters/T2.GIF');
ftv1 = fftshift( fft2(double(v1)) ); fts1 = fftshift( fft2(double(s1)) ); ftt1 = fftshift( fft2(double(t1)) );

%%plotting the phase%%
V1_Phase = angle(ftv1); imagesc(V1_Phase);    % #angle() returns matrix of radians, plotted here
x = exp(i*V1_Phase);                          % #inverse fft :: complex -> double so convert phase into complex plane using eulers formula e^jp = cos(x) + jsin(x)
Reconstruct_Just_Phase = ifft2(ifftshift(x)); % # Perform the inverse fft
imshow(Reconstruct_Just_Phase) %It shows outline but is hard to see

%%Magnitude%%
V1_Mag = abs(ftv1);

%%%Figures for each letter, uncomment to show%%%
%figure('Name','Fourier space of V');
%imagesc(log(abs(ftv1)+1)); figure('Name','Fourier space of S');
%imagesc(log(abs(fts1)+1)); figure('Name','Fourier space of T');
%imagesc(log(abs(ftt1)+1));