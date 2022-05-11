close all; clear; format long; clc;

%reading the image we are going to use
I = imread('chess.jpg');

%plotting the original image
figure
imshow(I);
title('Original Image');

%==============================================================
% Findind the elements of the Homography matrix h, with h33 = 1
%==============================================================

%matrix with the point measurements in the Image coordinate system
b = [2341;1134;1872;952;1567;915;2351;1719;1588;1379;950;1168;2117;2294;
    1071;1542];

%design matrix A
A = [5, 25, 1, 0, 0, 0, -5*2341, -25*2341;
    0, 0, 0, 5, 25, 1, -5*1134, -25*1134;
    10, 15, 1, 0, 0, 0, -10*1872, -15*1872;
    0, 0, 0, 10, 15, 1, -10*952, -15*952;
    15, 10, 1, 0, 0, 0, -15*1567, -10*1567;
    0, 0, 0, 15, 10, 1, -15*915, -10*915;
    20, 30, 1, 0, 0, 0, -20*2351, -30*2351;
    0, 0, 0, 20, 30, 1, -20*1719, -30*1719;
    25, 15, 1, 0, 0, 0, -25*1588, -15*1588;
    0, 0, 0, 25, 15, 1, -25*1379, -15*1379;
    30, 5, 1, 0, 0, 0, -30*950, -5*950;
    0, 0, 0, 30, 5, 1, -30*1168, -5*1168;
    35, 30, 1, 0, 0, 0, -35*2117, -30*2117;
    0, 0, 0, 35, 30, 1, -35*2294, -30*2294;
    35, 10, 1, 0, 0, 0, -35*1071, -10*1071;
    0, 0, 0, 35, 10, 1, -35*1542, -10*1542];

%=======================================================================
%solving the system A*h = b using least squares method with
%the Moore–Penrose inverse matrix At = ((AT*A)^-1)*AT, where AT is the
%transpose of matrix A
%=======================================================================

%product of the traspose with the original matrix
ATA = transpose(A)*A;
%inverse of the product
ATA_inv = inv(ATA);
%Moore-Penrose inverse
MP_inverse = ATA_inv*transpose(A);

%approximate solution of the problem Ah = b
h = MP_inverse*b;

%residual errors
v = b - A*h;

%standard error
s0 = sqrt((transpose(v)*v)/(2*8-8));



%============================================================
% Findind the elements of the inverse homography matrix H
%============================================================

%matrix with the point measurments in space coordinates
b_space = [5;25;10;15;15;10;20;30;25;15;30;5;35;30;35;10];

%design matrix A
A_space = [2341, 1134, 1, 0, 0, 0, -2341*5, -1134*5;
    0, 0, 0, 2341, 1134, 1, -2341*25, -1134*25;
    1872, 952, 1, 0, 0, 0, -1872*10, -952*10;
    0, 0, 0, 1872, 952, 1, -1872*15, -952*15;
    1567, 915, 1, 0, 0, 0, -1567*15, -915*15;
    0, 0, 0, 1567, 915, 1, -1567*10,-915*10;
    2351, 1719, 1, 0, 0, 0, -2351*20,-1719*20;
    0, 0, 0, 2351, 1719, 1, -2351*30, -1719*30;
    1588, 1379, 1, 0, 0, 0, -1588*25, -1379*25;
    0, 0, 0, 1588, 1379, 1, -1588*15, -1379*15;
    950, 1168, 1, 0, 0, 0, -950*30, -1168*30;
    0, 0, 0, 950, 1168, 1, -950*5, -1168*5;
    2117, 2294, 1, 0, 0, 0, -2117*35, -2294*35;
    0, 0, 0, 2117, 2294, 1, -2117*30, -2294*30;
    1071, 1542, 1,0, 0, 0, -1071*35, -1542*35;
    0, 0, 0, 1071, 1542, 1, -1071*10, -1542*10];


%product of the traspose with the original matrix
ATA_space = transpose(A_space)*A_space;
%inverse of the product
ATA_inv_space = inv(ATA_space);
%Moore-Penrose inverse
MP_inverse = ATA_inv_space*transpose(A_space);

%approximate solution of the problem AΗ = b
H = MP_inverse*b_space;

%residual errors
v_space = b_space - A_space*H;

%standard error
s0_space = sqrt((transpose(v_space)*v_space)/(2*8-8));


%====================================================
%using the formulas:
%i = y;
%j = x;
%X = (H(1)*j + H(2)*i + H(3))/(H(7)*j + H(8)*i + 1)
%Y = (H(4)*j + H(5)*i + H(6))/(H(7)*j + H(8)*i + 1)
%to find X_min,X_max,Y_min,Y_max
%====================================================
%converting the image to double precision 
I_double = double(I);

%rows and columns of the original image
rows = size(I,1);
columns = size(I,2);

%size of the pixel
D = 0.03;

%====================================
%calculating X_min,Y_min,X_max,Y_max
%====================================

%pixel values of the corners of the original image
j_values = [1,columns,1,columns];
i_values = [1,1,rows,rows];

%displaying the pixel values of the corners
for index=1:size(j_values,2)
    disp(['Corner ',num2str(index),' has (i,j) = (',num2str(i_values(index)),' ' ...
        '',num2str(j_values(index)),').'])
end

%initializing arrays for the space coordinates of the corners
X_values = zeros(size(i_values));
Y_values = zeros(size(i_values));

%calculating the space coordinates of the corners and displaying the result
for index=1:size(i_values,2)
    i = i_values(index);
    j = j_values(index);
    X_values(index) = (H(1)*j + H(2)*i + H(3))/(H(7)*j + H(8)*i + 1);
    Y_values(index) = (H(4)*j + H(5)*i + H(6))/(H(7)*j + H(8)*i + 1);
    
    disp(['(i,j) = ',num2str(i),',',num2str(j),'-> (X,Y) = ' ...
        ,num2str(X_values(index)),',',num2str(Y_values(index))]);

end

%minimum values
X_min = min(X_values);
Y_min = min(Y_values);

%maximun values
X_max = max(X_values);
Y_max = max(Y_values);

%area of the new image
width_rec = X_max - X_min;
height_rec = Y_max - Y_min;

%pixel size of the new image
rows_rec = 2500;
columns_rec = 5000;

%initializing a new RGB image
im_rec = zeros([rows_rec,columns_rec,3]);

%resampling and rectification of the original image
for i_rec=1:rows_rec
    for j_rec=1:columns_rec
        %space coordinates of the pixels of the new empty image
        X = X_min + (j_rec - 1)*D;
        Y = Y_max - (i_rec - 1)*D;
        %pixel coordinates of the space coordinates in the original image
        j_im = (h(1)*X + h(2)*Y + h(3))/(h(7)*X + h(8)*Y + 1);
        i_im = (h(4)*X + h(5)*Y + h(6))/(h(7)*X + h(8)*Y + 1);
        
        %resampling method-Nearest Neighbor
        if (1 <= i_im & i_im <= rows) & (1<=j_im & j_im<columns)
            im_rec(i_rec,j_rec,1) = I_double(round(i_im),round(j_im),1);
            im_rec(i_rec,j_rec,2) = I_double(round(i_im),round(j_im),2);
            im_rec(i_rec,j_rec,3) = I_double(round(i_im),round(j_im),3);
        end
    end
end

%converting the final result to uint8 so we can display the result
final_image = uint8(im_rec);

%plotting the final result
figure
imshow(final_image)
title('Image after rectification')

%saving the rectified image
imwrite(final_image,'chess_final.jpg');





















