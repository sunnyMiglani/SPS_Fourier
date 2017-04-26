function [ S, V, T ] = extractSpectralFeature()
S_files = dir('characters/Ss/');
S_Path = 'characters/Ss/';
V_files = dir('characters/Vs/');
V_Path = 'characters/Vs/';
T_files = dir('characters/Ts/');
T_Path = 'characters/Ts/';
for i = 3 : numel(S_files)
    Image = imread(strcat(S_Path,S_files(i).name));                                       %Read the file name
    FFTM  = fftshift( fft2(double(Image)));                                %FFT
    Box = Extract_Box(FFTM, 30, 70, 240, 400);                             %Get Feature
    Box_Power = Sum_Power(abs(Box));                                       %Sum the powers to get the value for this feature
    Ring = Extract_Ring(FFTM, 150, 50);
    Ring_Power = Sum_Power(abs(Ring));
    S(i) = Box_Power + Ring_Power;                                                      %Store the value in the return vector

end
for i = 3 : numel(V_files)

    Image = imread(strcat(V_Path,V_files(i).name));                                       %Read the file name
    FFTM  = fftshift( fft2(double(Image)));                                %FFT
    Box = Extract_Box(FFTM, 30, 70, 240, 400);                             %Get Feature
    Box_Power = Sum_Power(abs(Box));                                       %Sum the powers to get the value for this feature
    Ring = Extract_Ring(FFTM, 150, 50);
    Ring_Power = Sum_Power(abs(Ring));
    V(i) = Box_Power + Ring_Power;                                                      %Store the value in the return vector

end
for i = 3 : numel(T_files)

    Image = imread(strcat(T_Path,T_files(i).name));                                       %Read the file name
    FFTM  = fftshift( fft2(double(Image)));                                %FFT
    Box = Extract_Box(FFTM, 30, 70, 240, 400);                             %Get Feature
    Box_Power = Sum_Power(abs(Box));                                       %Sum the powers to get the value for this feature
    Ring = Extract_Ring(FFTM, 150, 50);
    Ring_Power = Sum_Power(abs(Ring));
    T(i) = Box_Power + Ring_Power;                                                      %Store the value in the return vector
end
end

