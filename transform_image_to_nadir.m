% from https://stackoverflow.com/questions/20445147/transform-image-using-roll-pitch-yaw-angles-image-rectification/20469709

% Load image
img = imread('initial_image.jpg');

% Given the following values of the camera sensor
% Roll:     -10
% Pitch:    -30
% Yaw:      166 (angular deviation from north)

% theta = rotate the camera frame the remainder of (90-Pitch) degrees in
%         the counter-clockwise direction of the y-axis (-90-(-30)=-60)
theta = -60

% phi = the positive Roll angle clockwise of the x-axis (0-(-10)=10)
phi = 10

% psi = the z-axis Yaw rotation is only relevant if you have a
%         north-seeking platform
psi = 0

% Full rotation matrix. Z-axis included, but not used.
% NOTE: R_z() not tested, may need to be moved because order matters in transforms
%R_rot = R_y(-60)*R_x(10)*R_z(0);
R_rot = R_y(theta)*R_x(phi)*R_z(psi);

% Strip the values related to the Z-axis from R_rot
R_2d  = [   R_rot(1,1)  R_rot(1,2) 0;
            R_rot(2,1)  R_rot(2,2) 0;
            0           0          1    ];

% Generate transformation matrix
tform = affine2d(R_2d);
% see python matplotlib.transforms.Affine2D()

% Warp (matlab syntax) using transformation matrix
outputImage = imwarp(img, tform);
% matlab imwarp() == python skimage.transform.warp()
% https://github.com/pycroscopy/pyUSID/blob/master/docs/matlab_to_python.rst

% Display image
figure(1), imshow(outputImage);


%*** Rotation Matrix Functions ***%

%% Matrix for Yaw-rotation about the Z-axis
function [R] = R_z(psi)
    R = [cosd(psi) -sind(psi) 0;
         sind(psi)  cosd(psi) 0;
         0          0         1];
end

%% Matrix for Pitch-rotation about the Y-axis
function [R] = R_y(theta)
    R = [cosd(theta)    0   sind(theta);
         0              1   0          ;
         -sind(theta)   0   cosd(theta)];
end

%% Matrix for Roll-rotation about the X-axis
function [R] = R_x(phi)
    R = [1  0           0;
         0  cosd(phi)   -sind(phi);
         0  sind(phi)   cosd(phi)];
end
