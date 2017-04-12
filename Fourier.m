
%#just change the file path to load the image.
v1 = imread('characters/V7.GIF'); s1 = imread('characters/S7.GIF'); t1 = imread('characters/T7.GIF'); %reading in the images 
ftv1 = fftshift( fft2(double(v1)) ); fts1 = fftshift( fft2(double(s1)) ); ftt1 = fftshift( fft2(double(t1)) ); %applying fourier transform and fourier shift

%%plotting the phase%%
V1_Phase = angle(ftv1); imagesc(V1_Phase);    % #angle() returns matrix of radians, plotted here
x = exp(1i*V1_Phase);                          % #inverse fft :: complex -> double so convert phase into complex plane using eulers formula e^jp = cos(x) + jsin(x)
Reconstruct_Just_Phase = ifft2(ifftshift(x)); % # Perform the inverse fft
imshow(Reconstruct_Just_Phase) %It shows outline but is hard to see



%%Magnitude%%
V1_Mag = abs(ftv1);
S1_Mag = abs(fts1);
T1_Mag = abs(ftt1);

V1_mean_temp = mean(V1_Mag);
V1_mean = mean(V1_mean_temp);
threshold = 0.5*V1_mean; % needs to be changed if noise cancellation is too much

[sizeLen,sizeWid] = size(V1_Mag);
V1_Red_Mag = threshold_set(V1_Mag,threshold,sizeLen,sizeWid);



%%%Figures for each letter, uncomment to show%%%
figure('Name','Fourier space of V reduced');
imagesc(log(V1_Red_Mag+1));
figure('Name','Fourier space of V not reduced');
imagesc(log(V1_Mag+1));
%figure('Name','Fourier space of T');
%imagesc(log(T1_Mag+1));

