function [ S, V, T ] = extractSpectralFeature()
S_files = dir('characters/Ss/');
S_Path = 'characters/Ss/';
V_files = dir('characters/Vs/');
V_Path = 'characters/Vs/';
T_files = dir('characters/Ts/');
T_Path = 'characters/Ts/';

%Variables so we can more easily modify spectral regions.
ring_Outer = 150; ring_Inner = 120;
box1u0 = 1; box1u1 = 125; v0 = 270; v1 = 370; 

% boxes : 0 -> 150 rows , 250 -> 400 columns
%         400 -> 250 length     same as above (width)

% The reason i starts from 3 is because dir() returns ".", ".." as the
% possible options in the directories, and this throws errors
% this is also why we use S(i-2,...) to avoid empty spaces in the S,V,T
% arrays

for i = 3 : numel(S_files)
    Image = imread(strcat(S_Path,S_files(i).name));                        %Read the file name
    FFTM  = fftshift( fft2(double(Image)));                                %FFT
    BoxOne = Extract_Box(FFTM, box1u0, box1u1, v0, v1);                    %Get Feature
    Box_Power = Sum_Power(abs(BoxOne));           %Sum the powers to get the value for this feature
    Ring = Extract_Ring(FFTM, ring_Outer, ring_Inner);
    Ring_Power = Sum_Power(abs(Ring));
    sector = Extract_sector(FFTM, 200, 75, 10, 40);
    sector_power = Sum_Power(abs(sector));
    S(i-2,1) = sector_power;%Box_Power;                                                  %Store the value in the return vector
    S(i-2,2) = Box_Power;%Ring_Power;
    S(i-2,3) = Ring_Power;
end
for i = 3 : numel(V_files)

    Image = imread(strcat(V_Path,V_files(i).name));                        %Read the file name
    FFTM  = fftshift( fft2(double(Image)));                                %FFT
    BoxOne = Extract_Box(FFTM, box1u0, box1u1, v0, v1);                               %Get Feature
    Box_Power = Sum_Power(abs(BoxOne));                                       %Sum the powers to get the value for this feature
    Ring = Extract_Ring(FFTM, ring_Outer, ring_Inner);
    Ring_Power = Sum_Power(abs(Ring));
    sector = Extract_sector(FFTM, 200, 75, 10, 40);
    sector_power = Sum_Power(abs(sector));
    V(i-2,1) = sector_power;%Box_Power;                                                  %Store the value in the return vector
    V(i-2,2) = Box_Power;%Ring_Power;
    V(i-2,3) = Ring_Power;
end
for i = 3 : numel(T_files)

    Image = imread(strcat(T_Path,T_files(i).name));                        %Read the file name
    FFTM  = fftshift( fft2(double(Image)));                                %FFT
    %    figure
    % imagesc(log(abs(FFTM)+1))
    BoxOne = Extract_Box(FFTM, box1u0, box1u1, v0, v1);                               %Get Feature
    Box_Power = Sum_Power(abs(BoxOne));                                       %Sum the powers to get the value for this feature
    Ring = Extract_Ring(FFTM, ring_Outer, ring_Inner);
    Ring_Power = Sum_Power(abs(Ring));
    sector = Extract_sector(FFTM, 200, 75, 10, 40);
    sector_power = Sum_Power(abs(sector));
    T(i-2,1) = sector_power; %Box_Power;                                                  %Store the value in the return vector
    T(i-2,2) = Box_Power;%Ring_Power;
    T(i-2,3) = Ring_Power;
end
end

