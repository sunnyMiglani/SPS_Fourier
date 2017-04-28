function [ labels, Test_Data ] = test_knn(MdL)

testFiles = dir('TestData/*.GIF');
Path = 'TestData/';

%Variables so we can more easily modify spectral regions.
ring_Outer = 150; ring_Inner = 120;
box1u0 = 1; box1u1 = 125; v0 = 270; v1 = 370; 

for i = 1 : numel(testFiles)
    Image = imread(strcat(Path,testFiles(i).name));                        %Read the file name
    FFTM  = log(abs(fftshift( fft2(double(Image))))+1);                                 %FFT
    BoxOne = Extract_Box(FFTM, box1u0, box1u1, v0, v1);                    %Get Feature
    Box_Power = Sum_Power(abs(BoxOne));           %Sum the powers to get the value for this feature
    Ring = Extract_Ring(FFTM, ring_Outer, ring_Inner);
    Ring_Power = Sum_Power(abs(Ring));
    sector = Extract_sector(FFTM, 200, 75, 10, 40);
    sector_power = Sum_Power(abs(sector));
    Test_Data(i,1) = sector_power; %Box_Power;                                                  %Store the value in the return vector
    Test_Data(i,2) = Box_Power;%Ring_Power;
    Test_Data(i,3) = Ring_Power;
end

labels = predict(MdL, Test_Data);

end

