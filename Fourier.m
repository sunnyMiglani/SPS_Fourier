
%%%%%%%%%%%%%%%%Loading images to test sector extractions%%%%%%%%%%%%%%%%%%
v1 = imread('characters/Vs/V7.GIF'); s1 = imread('characters/Ss/S7.GIF'); t1 = imread('characters/Ts/T4.GIF'); 
ftv1 = fftshift( fft2(double(v1)) ); fts1 = fftshift( fft2(double(s1)) ); ftt1 = fftshift( fft2(double(t1)) ); %applying fft

%%Magnitude%%
V1_Mag = abs(ftv1); S1_Mag = abs(fts1); T1_Mag = abs(ftt1);

%%%%%%%%%%%%%%%%Spectral feature paramaters for testing%%%%%%%%%%%%%%%%%%%%

%Ring Assumptions
ring_Outer = 40; ring_Inner = 0;
%%Top Box Assumptions
BT_u0 = 1; BT_u1 = 200; BT_v0 = 310; BT_v1 = 330;
%%Right Box Assumptios
BR_u0 = 190; BR_u1 = 210; BR_v0 = 1; BR_v1 = 640; 
%%Sector Assumptions (L)
thetaL_1 = 145; thetaL_2 =172.5; radL_in = 0; radL_out = 300;
%(R)
thetaR_1 = 7.5; thetaR_2 = 35; radR_in = 0; radR_out = 300;

%Extract a box region.
 box = Extract_Box_Original_Size((abs(fts1)), BT_u0, BT_u1, BT_v0, BT_v1);
 figure('Name', 's7'); imagesc(log((abs(fts1)+1)));
 power_boxOne = Sum_Power(box);
 figure('Name', 'boxOne'); imagesc(((box))); 
 box = Extract_Box_Original_Size((abs(fts1)), BR_u0, BR_u1, BR_v0, BR_v1);
 power_boxtwo = Sum_Power(box);
 figure('Name', 'boxTwo'); imagesc(log((box)+1)); 
 
%Extract a Sector region.
sector1 = Extract_sector((abs(ftv1)), radL_out, radL_in, thetaL_1, thetaL_2);  %theta 1 push anticlockwise
sector2 = Extract_sector((abs(ftv1)), radR_out, radR_in, thetaR_1, thetaR_2);  %theta 1 push anticlockwise
sector_power = Sum_Power((sector1)) + Sum_Power((sector2));
figure('Name', 'sectorOne'); imagesc(log((sector1)+1));
figure('Name', 'sectorTwo'); imagesc(log((sector2)+1));

%Extract a ring region
ring = Extract_Ring((abs(fts1)),ring_Outer, ring_Inner);
ring_power = Sum_Power((ring));
inverse_ring = ifft2(ifftshift(ring));
figure('Name', 'ring'); imagesc(log((ring)+1));

%%%%%%%%%%%%%%%%%%%%%% - testing the features - %%%%%%%%%%%%%%%%%%%%%%%%%%%

% Extract the features for all the training data
[S, V, T] = extractSpectralFeature(); Training_Data = [S; V; T]; %Concat them in an array


rS = rescaleData(S); rT = rescaleData(T); rV = rescaleData(V);
%S = rS; V = rV; T= rT;

RD = [rS; rV; rT];
Training_Data = rescaleData(Training_Data);
S = Training_Data(1:10, 1:2); V = Training_Data(11:20, 1:2); T = Training_Data(21:30, 1:2);

% Grab the means (Centroid for each of the classes)
Mean_S = mean(S,1); Mean_V = mean(V,1); Mean_T = mean(T,1); meanArray = [Mean_S; Mean_V; Mean_T]; %make 2X3 matrix with them
figure('Name','Scatter of Features');
hold on;
scatter( S(:,1), S(:, 2),'filled', 'ro'); %Plot S features
scatter( V(:,1), V(:, 2),'filled', 'go'); %Plot V features
scatter( T(:,1), T(:, 2),'filled', 'bo'); %Plot T features
xlabel('Sector Values'); ylabel('Box Values'); legend('S', 'V', 'T'); %Other plot things

%voronoi(meanArray(:,1), meanArray(:,2));

%%%%%%%%%%%%%%%%%%%%%%%%%% - KNN Classifier - %%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Create the labels for the observed data points
cell_labels = cellstr([repmat('S', 10,1); repmat('V', 10,1); repmat('T', 10,1)]);

%Fit the KNN classifier
MdL = fitcknn(Training_Data, cell_labels, 'NumNeighbors',7,  'Standardize',1);%,,'Distance', 'mahalanobis' 'chebychev');

%Apply the classifier to Test Data
[labels,Test_Data] = test_knn(MdL);

Test_Classification = cell2mat(labels); %Convert to matrix so we can use "find"
ClusterSIndices = find(Test_Classification == 'S'); %Find the indecis classified as S
ClusterTIndices = find(Test_Classification == 'T'); %Find the indecis classified as T
ClusterVIndices = find(Test_Classification == 'V'); %Find the indecis classified as V

%Use the indecis discovered to extract the 2d features for each
%classification
Class_S = [Test_Data(ClusterSIndices, 1), Test_Data(ClusterSIndices,2)];
Class_T = [Test_Data(ClusterTIndices, 1), Test_Data(ClusterTIndices,2)];
Class_V = [Test_Data(ClusterVIndices, 1), Test_Data(ClusterVIndices,2)];

%Plot the points, color coding each class
scatter( Class_S(:,1), Class_S(:, 2),'r');
scatter( Class_V(:,1), Class_V(:, 2),'g');
scatter( Class_T(:,1), Class_T(:, 2),'b');

%%%%%%%%%%%%%%%%%%%%%%%%%%%KNN decision boundary%%%%%%%%%%%%%%%%%%%%%%%%%%%

xscale = xlim; yscale = ylim; %Generate linearly spaceed vectors for each point on x and y axis
xrange = linspace(xscale(:,1), xscale(:,2)); %100 points within the x axis (sector feature)
yrange = linspace(yscale(:,1), yscale(:,2)); %100 points within the y axis (box feature)

[XGRID, YGRID] = meshgrid(xrange, yrange); Test_Grid = [XGRID YGRID]; %Generate a meshgrid of testpoints

Test_Grid2 = reshape(Test_Grid, [],2);
Grid_Labels = predict(MdL, Test_Grid2); %Classify the test points so the surface is filled.

gridSIndices = find(cell2mat(Grid_Labels) == 'S'); %Extract S classification indexes
gridTIndices = find(cell2mat(Grid_Labels) == 'T'); %Extract T classification indexes
gridVIndices = find(cell2mat(Grid_Labels) == 'V'); %Extract V classification indexes

Class_S_Test = [Test_Grid2(gridSIndices, 1), Test_Grid2(gridSIndices, 2)]; %The features that have been classified as S
Class_T_Test = [Test_Grid2(gridTIndices, 1), Test_Grid2(gridTIndices, 2)]; %The features that have been classified as T
Class_V_Test = [Test_Grid2(gridVIndices, 1), Test_Grid2(gridVIndices, 2)]; %The features that have been classified as V

scatter( Class_S_Test(:,1), Class_S_Test(:, 2),'.','r');
scatter( Class_V_Test(:,1), Class_V_Test(:, 2),'.','g');
scatter( Class_T_Test(:,1), Class_T_Test(:, 2),'.','b');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%Maximum Likelihood%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%Get mean for each class
MU_S = mean(S,1); MU_V = mean(V,1); MU_T = mean(T,1);
%%Get covariance for each class
COV_S = cov(S); COV_V = cov(V); COV_T = cov(T); 

%x1 = xlim; y1 = ylim;
%xrange = linspace(x1(:,1), x1(:,2)); %100 points within the x axis (sector feature)
%yrange = linspace(y1(:,1), y1(:,2)); %100 points within the y axis (box feature)

%[gX, gY] = meshgrid(xrange, yrange);
%grdP = [gX gY];
%reshape(grdP, [], 2);

%%Model each class as a guassian %mvn = Multivariate Normal Pdf
Like_S = mvnpdf([XGRID(:) YGRID(:)], MU_S, COV_S).*(1/3); % For S
Like_V = mvnpdf([XGRID(:) YGRID(:)], MU_V, COV_V).*(1/3); % For V
Like_T = mvnpdf([XGRID(:) YGRID(:)], MU_T, COV_T).*(1/3); % For T

figure;
hold on;
surf(xrange, yrange, reshape(Like_S, length(xrange),length(yrange))) %surface plot
surf(xrange, yrange, reshape(Like_T, length(xrange),length(yrange)))
surf(xrange, yrange, reshape(Like_V, length(xrange),length(yrange)))
xlabel('Sector Values');
ylabel('Box Values');

ThreshS =  (1 / ( 2 * pi * sqrt( det( COV_S )))) * exp( -3 ); 
ThreshV =  (1 / ( 2 * pi * sqrt( det( COV_V )))) * exp( -3 ); 
ThreshT =  (1 / ( 2 * pi * sqrt( det( COV_T )))) * exp( -3 ); 

%contour(xrange,yrange, reshape(Like_S, length(xrange),length(yrange)), [ThreshS ThreshS],'r' ); %%The maximum likelihood lines
%contour(xrange,yrange, reshape(Like_V, length(xrange),length(yrange)), [ThreshS ThreshS],'g' )
%contour(xrange,yrange, reshape(Like_T, length(xrange),length(yrange)), [ThreshS ThreshS],'b' )

%calculate likelihood rations

LH_SV = (Like_S./Like_V);
LH_ST = (Like_S./Like_T);
LH_VT = (Like_V./Like_T);

figure('Name','ML boundaries S/V');
hold on;
scatter( S(:,1), S(:, 2),'filled', 'ro'); %Plot S features
scatter( V(:,1), V(:, 2),'filled', 'go'); %Plot V features
scatter( Class_S(:,1), Class_S(:, 2),'r');
scatter( Class_V(:,1), Class_V(:, 2),'g');
contour(xrange,yrange, reshape(LH_SV, length(xrange),length(yrange)),[1 1],'y' ); 
xlabel('Sector Values'); ylabel('Box Values'); legend('S', 'V'); %Other plot things

figure('Name','ML boundaries S/T');
hold on;
scatter( S(:,1), S(:, 2),'filled', 'ro'); %Plot S features
scatter( T(:,1), T(:, 2),'filled', 'bo'); %Plot T features
scatter( Class_T(:,1), Class_T(:, 2),'b');
scatter( Class_S(:,1), Class_S(:, 2),'r');
contour(xrange,yrange, reshape(LH_ST, length(xrange),length(yrange)),[1 1],'m' )
xlabel('Sector Values'); ylabel('Box Values'); legend('S', 'T'); %Other plot things

figure('Name','ML boundaries T/V');
hold on;
scatter( T(:,1), T(:, 2),'filled', 'bo'); %Plot T features
scatter( V(:,1), V(:, 2),'filled', 'go'); %Plot V features
scatter( Class_V(:,1), Class_V(:, 2),'g');
scatter( Class_T(:,1), Class_T(:, 2),'b');
contour(xrange,yrange, reshape(LH_VT, length(xrange),length(yrange)),[1 1],'cyan' )
xlabel('Sector Values'); ylabel('Box Values'); legend('T', 'V'); %Other plot things

NB = fitcnb(Training_Data,cell_labels); %Train and use a naive bayes classifier to explain the decision boundaries.
bayesb = predict(NB, Test_Data);



%more boundaries%
figure; hold on;
bayes_grid = predict(NB, Test_Grid2); %Classify the test points so the surface is filled.

gridS_b = find(cell2mat(bayes_grid) == 'S'); %Extract S classification indexes
gridT_b = find(cell2mat(bayes_grid) == 'T'); %Extract T classification indexes
gridV_b = find(cell2mat(bayes_grid) == 'V'); %Extract V classification indexes

Class_S_Test_b = [Test_Grid2(gridS_b, 1), Test_Grid2(gridS_b, 2)]; %The features that have been classified as S
Class_T_Test_b = [Test_Grid2(gridT_b, 1), Test_Grid2(gridT_b, 2)]; %The features that have been classified as T
Class_V_Test_b = [Test_Grid2(gridV_b, 1), Test_Grid2(gridV_b, 2)]; %The features that have been classified as V

scatter( Class_S_Test_b(:,1), Class_S_Test_b(:, 2),'.','r');
scatter( Class_T_Test_b(:,1), Class_T_Test_b(:, 2),'.','b');
scatter( Class_V_Test_b(:,1), Class_V_Test_b(:, 2),'.','g');

