function [ labels, Test_Data ] = test_knn(MdL)

testFiles = dir('TestData/*.GIF');
Path = 'TestData/';


%Ring Assumptions
ring_Outer = 40; ring_Inner = 0;
%%Top Box Assumptions
BT_u0 = 1; BT_u1 = 400; BT_v0 = 300; BT_v1 = 340;
%%Right Box Assumptios
BR_u0 = 160; BR_u1 = 240; BR_v0 = 450; BR_v1 = 580; 
%%Sector Assumptions (L)
thetaL_1 = 120; thetaL_2 =160; radL_in = 0; radL_out = 125;
%(R)
thetaR_1 = 30; thetaR_2 = 70; radR_in = 0; radR_out = 125;


for i = 1 : numel(testFiles)
    Image = imread(strcat(Path,testFiles(i).name));                        
    FFTM  = log(abs(fftshift( fft2(double(Image)./255)))+1);                            
    Box_Top = Sum_Power( Extract_Box(FFTM, BT_u0, BT_u1, BT_v0, BT_v1));       %Extract a "Box" spectral feature
    Box_R = Sum_Power(Extract_Box(FFTM, BR_u0, BR_u1, BR_v0, BR_v1));                               
    Ring = Sum_Power(Extract_Ring(FFTM, ring_Outer, ring_Inner));
    SectorL = Sum_Power(Extract_sector(FFTM, radL_out, radL_in, thetaL_1, thetaL_2));
    SectorR = Sum_Power(Extract_sector(FFTM, radR_out, radR_in, thetaR_1, thetaR_2));
    Test_Data(i,1) = Box_Top;                                           
    Test_Data(i,2) = SectorL+SectorR;
end

labels = predict(MdL, Test_Data);

end

