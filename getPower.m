function [ powerM ] = getPower(  )                                         %Needs to be run while in the character directory
files = dir('*.GIF');
for i = 1 : numel(files)
    Image = imread(files(i).name);                                         %Read the file name
    FFTM  = fftshift( fft2(double(Image)));                                %FFT
    Box = Extract_Box(FFTM, 100, 300, 200, 500);                           %Get Feature
    Power = Sum_Power(abs(Box));                                           %Sum the powers to get the value for this feature
    powerM(i) = Power;                                                     %Store the value in the return vector
end

end

