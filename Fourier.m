
%#just change the file path to load the image.
v1 = imread('characters/Vs/V7.GIF'); s1 = imread('characters/Ss/S7.GIF'); t1 = imread('characters/Ts/T4.GIF'); %reading in the images 

ftv1 = fftshift( fft2(double(v1)) ); fts1 = fftshift( fft2(double(s1)) ); ftt1 = fftshift( fft2(double(t1)) ); %applying fourier transform and fourier shift

%%plotting the phase%%

%%Magnitude%%
V1_Mag = abs(ftv1);
S1_Mag = abs(fts1);
T1_Mag = abs(ftt1);


%Ring Assumptions
ring_Outer = 75; ring_Inner = 0;
%%Top Box Assumptions
BT_u0 = 1; BT_u1 = 400; BT_v0 = 300; BT_v1 = 340; 
%%Right Box Assumptios
BR_u0 = 190; BR_u1 = 210; BR_v0 = 0; BR_v1 = 640; 
%%Sector Assumptions (L)
thetaL_1 = 120; thetaL_2 =160; radL_in = 0; radL_out = 200;
%(R)
thetaR_1 = 20; thetaR_2 = 60; radR_in = 0; radR_out = 200;


%Extract a box region.
 box = Extract_Box_Original_Size((abs(fts1)), BT_u0, BT_u1, BT_v0, BT_v1);
 figure('Name', 's7'); imagesc(log((abs(fts1)+1)));
 power_boxOne = Sum_Power(box);
 figure('Name', 'boxOne'); imagesc(log((box)+1)); 
 box = Extract_Box_Original_Size((abs(fts1)), BR_u0, BR_u1, BR_v0, BR_v1);
 power_boxOne = Sum_Power(box) + power_boxOne;
 figure('Name', 'boxTwo'); imagesc(log((box)+1)); 
 



%Extract a Sector region.
sector1 = Extract_sector((abs(ftt1)), radL_out, radL_in, thetaL_1, thetaL_2);  %theta 1 push anticlockwise
sector2 = Extract_sector((abs(ftt1)), radR_out, radR_in, thetaR_1, thetaR_2);  %theta 1 push anticlockwise
sector_power = Sum_Power((sector1)) + Sum_Power((sector2));
figure('Name', 'sectorOne'); imagesc(log((sector1)+1));
figure('Name', 'sectorTwo'); imagesc(log((sector2)+1));


%Extract a ring region
ring = Extract_Ring((abs(fts1)),ring_Outer, ring_Inner);
ring_power = Sum_Power((ring));
inverse_ring = ifft2(ifftshift(ring));
figure('Name', 'ring'); imagesc(log((ring)+1));

%%%%%%%%%%%%%%% - Voronoi plots and testing the features - %%%%%%%%%%%%%%%%

% Extract the features for all the training data
[S, V, T] = extractSpectralFeature();

%Concat them in an array
Training_Data = [S; V; T];

% Grab the means (Centroid for each of the classes)
Cluster_S = mean(S,1); Cluster_V = mean(V,1); Cluster_T = mean(T,1);

%Concat the centroids into a single array that can be passed to the voronoi
%diagram so we can get an idea of the classification boundaries based on
%out spectral features.
meanArray = [Cluster_S; Cluster_V; Cluster_T];
figure('Name','3D Scatter of Features');
hold on;
scatter( S(:,1), S(:, 2),'filled', 'ro');
scatter( V(:,1), V(:, 2),'filled', 'go');
scatter( T(:,1), T(:, 2),'filled', 'bo');
xlabel('Sector Values');
ylabel('Box Values');
legend('S', 'V', 'T');

% Comparison of various pairs of features

% Ring vs Sector Values --> Clusters are not great. They're quite close
% together and it can easily cause problems during classification

% Sector vs Box Values --> Clusters are much better, very little
% interaction between the points. Good decision boundary with veronoi

% Ring vs Box Values --> Not as great clusters as Sector V Box. But Still
% better than Ring V Sector. Would prefer Sector vs Box Values



%  scatter( S(:,1), S(:, 2),'filled', 'ro');
%  scatter( V(:,1), V(:, 2), 'filled', 'go');
%  scatter( T(:,1), T(:, 2),'filled', 'bo');

% plot(Cluster_S(:,1),Cluster_S(:,2), 'rd', 'MarkerSize', 7);
% plot(Cluster_V(:,1),Cluster_V(:,2), 'gd', 'MarkerSize', 7);
% plot(Cluster_T(:,1),Cluster_T(:,2), 'bd', 'MarkerSize', 7);

%voronoi(meanArray(:,1), meanArray(:,2));

%%%%%%%%%%%%%%%%%%%%%%%%%% - KNN Classifier - %%%%%%%%%%%%%%%%%%%%%%%%%%%%


%Create the labels for the observed data points
cell_labels = cellstr([repmat('S', 10,1); repmat('V', 10,1); repmat('T', 10,1)]);

%Fit the KNN classifier
MdL = fitcknn(Training_Data, cell_labels, 'NumNeighbors', 5, 'Standardize',1);%, 1, 'Distance', 'cityblock');


[labels,Test_Data] = test_knn(MdL);



labels_cells = cell2mat(labels);
ClusterSIndices = find((labels_cells) == 'S'); ClusterTIndices = find(labels_cells == 'T'); ClusterVIndices = find(labels_cells == 'V');


ClusterS = [Test_Data(ClusterSIndices, 1), Test_Data(ClusterSIndices,2)]; %The features that have been classified as S
ClusterT = [Test_Data(ClusterTIndices, 1), Test_Data(ClusterTIndices,2)];
ClusterV = [Test_Data(ClusterVIndices, 1), Test_Data(ClusterVIndices,2)];

scatter( ClusterS(:,1), ClusterS(:, 2),'rd');
scatter( ClusterV(:,1), ClusterV(:, 2),'gd');
scatter( ClusterT(:,1), ClusterT(:, 2),'bd');

%Attempt at decision boundary
YY = (0.5e4: 0.01e4: 4.5e4);
XX = (0.5e5: 0.01e5: 3.5e5);
[X,Y] = meshgrid(XX,YY);
BP = [X Y];
BP_2dim = reshape(BP, [], 2);

labelsgrd = predict(MdL, BP_2dim);

gridSIndices = find(cell2mat(labelsgrd) == 'S'); gridTIndices = find(cell2mat(labelsgrd) == 'T'); gridVIndices = find(cell2mat(labelsgrd) == 'V');

Cs = [BP_2dim(gridSIndices, 1), BP_2dim(gridSIndices, 2)]; %The features that have been classified as S
CT = [BP_2dim(gridTIndices, 1), BP_2dim(gridTIndices, 2)];
CV = [BP_2dim(gridVIndices, 1), BP_2dim(gridVIndices, 2) ];

%FF = reshape(BP, [], 2)
%scatter( BP_2dim(:,1), BP_2dim(:, 2),'r') %---contains all the correct points
figure; hold on;
scatter( Cs(:,1), Cs(:, 2),'filled','r');
scatter( CV(:,1), CV(:, 2),'filled','g');
scatter( CT(:,1), CT(:, 2),'filled','b');
xlabel('Sector Values');
ylabel('Box Values');
legend('S', 'V', 'T');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%Maximum Likelihood%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%Get mean for each class
MU_S = mean(S,1); MU_V = mean(V,1); MU_T = mean(T,1);
%%Get covariance for each class
COV_S = cov(S); COV_V = cov(V); COV_T = cov(T); 

x1 = xlim; y1 = ylim;
xrange = linspace(x1(:,1), x1(:,2)); %100 points within the x axis (sector feature)
yrange = linspace(y1(:,1), y1(:,2)); %100 points within the y axis (box feature)

[gX, gY] = meshgrid(xrange, yrange);
grdP = [gX gY];
reshape(grdP, [], 2);

%%Model each class as a guassian
Like_S = mvnpdf([gX(:) gY(:)], MU_S, COV_S); % For S
Like_V = mvnpdf([gX(:) gY(:)], MU_V, COV_V); % For V
Like_T = mvnpdf([gX(:) gY(:)], MU_T, COV_T); % For T

figure;
hold on;
surf(xrange, yrange, reshape(Like_S, length(xrange),length(yrange)))
surf(xrange, yrange, reshape(Like_T, length(xrange),length(yrange)))
surf(xrange, yrange, reshape(Like_V, length(xrange),length(yrange)))
xlabel('Sector Values');
ylabel('Box Values');


figure;
hold on

ThreshS =  (1 / ( 2 * pi * sqrt( det( COV_S )))) * exp( -3 ); 
ThreshV =  (1 / ( 2 * pi * sqrt( det( COV_V )))) * exp( -3 ); 
ThreshT =  (1 / ( 2 * pi * sqrt( det( COV_T )))) * exp( -3 ); 

%contour(xrange,yrange, reshape(Like_S, length(xrange),length(yrange)), [ThreshS ThreshS],'r' ); %%The maximum likelihood lines
%contour(xrange,yrange, reshape(Like_V, length(xrange),length(yrange)), [ThreshS ThreshS],'g' )
%contour(xrange,yrange, reshape(Like_T, length(xrange),length(yrange)), [ThreshS ThreshS],'b' )

%calculate likelihood rations

LH_SV = Like_S./Like_V
LH_ST = Like_S./Like_T
LH_VT = Like_V./Like_T

%contour(xrange,yrange, reshape(LH_SV, length(xrange),length(yrange)),[1 1],'y' ); %%The maximum likelihood lines
%contour(xrange,yrange, reshape(LH_ST, length(xrange),length(yrange)),[1 1],'g' )
contour(xrange,yrange, reshape(LH_VT, length(xrange),length(yrange)),[1 1],'b' )


