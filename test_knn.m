function [ labels, Test_Data ] = test_knn(MdL)

testFiles = dir('TestData/*.GIF');
Path = 'TestData/';

%Variables so we can more easily modify spectral regions.
ring_Outer = 100; ring_Inner = 75;
box1u0 = 1; box1u1 = 140; v0 = 300; v1 = 375; 
box2u0 = 260; box2u1 = 400;

for i = 1 : numel(testFiles)
    Image = imread(strcat(Path,testFiles(i).name));                        %Read the file name
    FFTM  = fftshift( fft2(double(Image)));                                %FFT
    BoxOne = Extract_Box(FFTM, box1u0, box1u1, v0, v1);                    %Get Feature
    BoxTwo = Extract_Box(FFTM, box2u0, box2u1, v0, v1);                    %Get Feature
    Box_Power = Sum_Power(abs(BoxOne)) + Sum_Power(abs(BoxTwo));           %Sum the powers to get the value for this feature
    Ring = Extract_Ring(FFTM, ring_Outer, ring_Inner);
    Ring_Power = Sum_Power(abs(Ring));
    Test_Data(i,1) = Box_Power;                                                  %Store the value in the return vector
    Test_Data(i,2) = Ring_Power;
end

labels = predict(MdL, Test_Data);

end

