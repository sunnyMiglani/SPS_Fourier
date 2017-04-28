function [ S, V, T ] = extractSpectralFeature()
S_files = dir('characters/Ss/');
S_Path = 'characters/Ss/';
V_files = dir('characters/Vs/');
V_Path = 'characters/Vs/';
T_files = dir('characters/Ts/');
T_Path = 'characters/Ts/';

%Variables so we can more easily modify spectral regions.
ring_Outer = 150; ring_Inner = 75;
box1u0 = 1; box1u1 = 140; v0 = 250; v1 = 350; 
box2u0 = 260; box2u1 = 400;

% boxes : 0 -> 150 rows , 250 -> 400 columns
%         400 -> 250 length     same as above (width)

% The reason i starts from 3 is because dir() returns ".", ".." as the
% possible options in the directories, and this throws errors
% this is also why we use S(i-2,...) to avoid empty spaces in the S,V,T
% arrays

for i = 3 : numel(S_files)
    Image = imread(strcat(S_Path,S_files(i).name));                        %Read the file name
    FFTM  = fftshift( fft2(double(Image)));                                %FFT
    BoxOne = Extract_Box(FFTM, box1u0, box1u1, v0, v1);                               %Get Feature
    BoxTwo = Extract_Box(FFTM, box2u0, box2u1, v0, v1);                               %Get Feature
    Box_Power = Sum_Power(abs(BoxOne)) + Sum_Power(abs(BoxTwo));                                       %Sum the powers to get the value for this feature
    Ring = Extract_Ring(FFTM, ring_Outer, ring_Inner);
    Ring_Power = Sum_Power(abs(Ring));
    S(i-2,1) = Box_Power;                                                  %Store the value in the return vector
    S(i-2,2) = Ring_Power;
end
for i = 3 : numel(V_files)

    Image = imread(strcat(V_Path,V_files(i).name));                        %Read the file name
    FFTM  = fftshift( fft2(double(Image)));                                %FFT
    BoxOne = Extract_Box(FFTM, box1u0, box1u1, v0, v1);                               %Get Feature
    BoxTwo = Extract_Box(FFTM, box2u0, box2u1, v0, v1);
    Box_Power = Sum_Power(abs(BoxOne))+ Sum_Power(abs(BoxTwo));                                       %Sum the powers to get the value for this feature
    Ring = Extract_Ring(FFTM, ring_Outer, ring_Inner);
    Ring_Power = Sum_Power(abs(Ring));
    V(i-2,1) = Box_Power;                                                  %Store the value in the return vector
    V(i-2,2) = Ring_Power;
end
for i = 3 : numel(T_files)

    Image = imread(strcat(T_Path,T_files(i).name));                        %Read the file name
    FFTM  = fftshift( fft2(double(Image)));                                %FFT
    %    figure
    % imagesc(log(abs(FFTM)+1))
    BoxOne = Extract_Box(FFTM, box1u0, box1u1, v0, v1);                               %Get Feature
    BoxTwo = Extract_Box(FFTM, box2u0, box2u1, v0, v1);
    Box_Power = Sum_Power(abs(BoxOne)) + Sum_Power(abs(BoxTwo));                                       %Sum the powers to get the value for this feature
    Ring = Extract_Ring(FFTM, ring_Outer, ring_Inner);
    Ring_Power = Sum_Power(abs(Ring));
    T(i-2,1) = Box_Power;                                                  %Store the value in the return vector
    T(i-2,2) = Ring_Power;
end
end

