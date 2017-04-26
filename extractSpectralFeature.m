function [ S, V, T ] = extractSpectralFeature()
S_files = dir('characters/S''s/');
V_files = dir('characters/V''s/');
T_files = dir('characters/T''s/');
for i = 1 : numel(S_files)
    Image = imread(S_files(i).name);                                       %Read the file name
    FFTM  = fftshift( fft2(double(Image)));                                %FFT
    Box = Extract_Box(FFTM, 100, 300, 200, 500);                           %Get Feature
    Power = Sum_Power(abs(Box));                                           %Sum the powers to get the value for this feature
    S(i) = Power;                                                          %Store the value in the return vector
end
for i = 1 : numel(V_files)
    Image = imread(V_files(i).name);                                       %Read the file name
    FFTM  = fftshift( fft2(double(Image)));                                %FFT
    Box = Extract_Box(FFTM, 100, 300, 200, 500);                           %Get Feature
    Power = Sum_Power(abs(Box));                                           %Sum the powers to get the value for this feature
    V(i) = Power;                                                          %Store the value in the return vector
end
for i = 1 : numel(T_files)
    Image = imread(T_files(i).name);                                       %Read the file name
    FFTM  = fftshift( fft2(double(Image)));                                %FFT
    Box = Extract_Box(FFTM, 100, 300, 200, 500);                           %Get Feature
    Power = Sum_Power(abs(Box));                                           %Sum the powers to get the value for this feature
    T(i) = Power;                                                          %Store the value in the return vector
end
end

