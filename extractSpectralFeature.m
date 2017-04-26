function [ S, V, T ] = extractSpectralFeature()
S_files = dir('characters/Ss/');
S_Path = 'characters/Ss/';
V_files = dir('characters/Vs/');
V_Path = 'characters/Vs/';
T_files = dir('characters/Ts/');
T_Path = 'characters/Ts/';

% The reason i starts from 3 is because dir() returns ".", ".." as the
% possible options in the directories, and this throws errors
% this is also why we use S(i-2,...) to avoid empty spaces in the S,V,T
% arrays

for i = 3 : numel(S_files)
    Image = imread(strcat(S_Path,S_files(i).name));                                       %Read the file name
    FFTM  = fftshift( fft2(double(Image)));                                %FFT
    Box = Extract_Box(FFTM, 30, 70, 240, 400);                             %Get Feature
    Box_Power = Sum_Power(abs(Box));                                       %Sum the powers to get the value for this feature
    Ring = Extract_Ring(FFTM, 150, 50);
    Ring_Power = Sum_Power(abs(Ring));
    S(i-2,1) = Box_Power;                                                      %Store the value in the return vector
    S(i-2,2) = Ring_Power;
end
for i = 3 : numel(V_files)

    Image = imread(strcat(V_Path,V_files(i).name));                                       %Read the file name
    FFTM  = fftshift( fft2(double(Image)));                                %FFT
    Box = Extract_Box(FFTM, 10, 70, 240, 400);                             %Get Feature
    Box_Power = Sum_Power(abs(Box));                                       %Sum the powers to get the value for this feature
    Ring = Extract_Ring(FFTM, 150, 50);
    Ring_Power = Sum_Power(abs(Ring));
    V(i-2,1) = Box_Power;                                                      %Store the value in the return vector
    V(i-2,2) = Ring_Power;
end
for i = 3 : numel(T_files)

    Image = imread(strcat(T_Path,T_files(i).name));                                       %Read the file name
    FFTM  = fftshift( fft2(double(Image)));                                %FFT
    Box = Extract_Box(FFTM, 10, 70, 240, 500);                             %Get Feature
    Box_Power = Sum_Power(abs(Box));                                       %Sum the powers to get the value for this feature
    Ring = Extract_Ring(FFTM, 150, 50);
    Ring_Power = Sum_Power(abs(Ring));
    T(i-2,1) = Box_Power;                                                      %Store the value in the return vector
    T(i-2,2) = Ring_Power;
end
end

