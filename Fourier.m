
%#just change the file path to load the image.

v1 = imread('characters/V2.GIF'); s1 = imread('characters/S2.GIF'); t1 = imread('characters/T5.GIF'); %reading in the images 

ftv1 = fftshift( fft2(double(v1)) ); fts1 = fftshift( fft2(double(s1)) ); ftt1 = fftshift( fft2(double(t1)) ); %applying fourier transform and fourier shift

%%plotting the phase%%
%V1_Phase = angle(ftv1); imagesc(V1_Phase);    % #angle() returns matrix of radians, plotted here
%x = exp(1i*V1_Phase);                          % #inverse fft :: complex -> double so convert phase into complex plane using eulers formula e^jp = cos(x) + jsin(x)
%Reconstruct_Just_Phase = ifft2(ifftshift(x)); % # Perform the inverse fft
%imshow(Reconstruct_Just_Phase); %It shows outline but is hard to see



%%Magnitude%%
V1_Mag = abs(ftv1);
S1_Mag = abs(fts1);
T1_Mag = abs(ftt1);

V1_Phase = angle(ftv1);
S1_Phase = angle(fts1);
T1_Phase = angle(ftt1);


%Extrac a box region.
box = Extract_Box_Original_Size(ftt1, 100, 300, 200, 500);
box_power = Sum_Power(abs(box));
inverse_box = ifft2(ifftshift(box));
imshow(real(inverse_box));

%Filter the noise out from the images%
% NOTE: We choose a lower threshold to ignore all the values that are not
% needed to be a proper classifier.

V1_mean = mean(mean(V1_Mag)); % Mean applied twice since in a 2D array, it gets mean of 1D per mean() call #Weird
thresholdV1 = 0.195*V1_mean; %Value's of threshold are calculated manually
V1_Red_Mag = noise_filter(V1_Mag,thresholdV1);

S1_mean = mean(mean(S1_Mag));
thresholdS1 = 0.195*S1_mean;
S1_Red_Mag = noise_filter(S1_Mag,thresholdS1);

T1_mean = mean(mean(T1_Mag)); 
thresholdT1 = 0.195*T1_mean;
T1_Red_Mag = noise_filter(T1_Mag,thresholdT1);

% This is done to go back from the fourier space to real image 
FreqDomain = V1_Mag.*exp(1i*V1_Phase);
x_image = ifft2(ifftshift(FreqDomain)); % # Perform the inverse fft
figure('Name','Image Before Change');
imshow(x_image);

FreqDomainChanged = V1_Red_Mag.*exp(1i*V1_Phase);
x_image = ifft2(ifftshift(FreqDomainChanged)); % # Perform the inverse fft
figure('Name','Image After Change');
imshow(x_image);




%%%Figures for each letter, uncomment to show%%%
figure('Name','Fourier space of V reduced');
imagesc(log(V1_Red_Mag+1));
figure('Name','Fourier space of V not reduced');
imagesc(log(V1_Mag+1));
figure('Name','Fourier space of S reduced');
imagesc(log(S1_Red_Mag+1));
figure('Name','Fourier space of S not reduced');
imagesc(log(S1_Mag+1));
figure('Name','Fourier space of T reduced');
imagesc(log(T1_Red_Mag+1));
figure('Name','Fourier space of T not reduced');
imagesc(log(T1_Mag+1));
figure('Name','Fourier space of T');
imagesc(log(T1_Mag+1));

