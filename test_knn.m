function [ labels, Test_Data ] = test_knn(MdL)

testFiles = dir('TestData/*.GIF');
Path = 'TestData/';

%Ring Assumptions
ring_Outer = 150; ring_Inner = 120;
%%Top Box Assumptions
BT_u0 = 1; BT_u1 = 170; BT_v0 = 300; BT_v1 = 340; 
%%Right Box Assumptios
BR_u0 = 180; BR_u1 = 220; BR_v0 = 395; BR_v1 = 640; 
%%Sector Assumptions (L)
thetaL_1 = 10; thetaL_2 =30; radL_in = 150; radL_out = 310;
%(R)
thetaR_1 = 150; thetaR_2 = 170; radR_in = 150; radR_out = 310;

for i = 1 : numel(testFiles)
    Image = imread(strcat(Path,testFiles(i).name));                        
    FFTM  = abs(fftshift( fft2(double(Image))));                            
    Box_Top = Sum_Power( Extract_Box(FFTM, BT_u0, BT_u1, BT_v0, BT_v1));       %Extract a "Box" spectral feature
    Box_R = Sum_Power(Extract_Box(FFTM, BR_u0, BR_u1, BR_v0, BR_v1));                               
    Ring = Sum_Power(Extract_Ring(FFTM, ring_Outer, ring_Inner));
    Sectorl = Sum_Power(Extract_sector(FFTM, radL_out, radL_in, thetaL_1, thetaL_2));
    Sectorr = Sum_Power(Extract_sector(FFTM, radR_out, radR_in, thetaR_1, thetaR_2));
    Test_Data(i,1) = Sectorl+ Sectorr;                                                 
    Test_Data(i,2) = Box_Top;
    Test_Data(i,3) = Ring;
end

labels = predict(MdL, Test_Data);

end

