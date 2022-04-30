clear; close all; clc;


%============================
% SETTING UP THE PROBLEM
%============================

%creating the square in homogeneous coordinates
sq_hom = [-25 25 25 -25 -25; -25 -25 25 25 -25; 1 1 1 1 1];


%plotting the initial square
figure
plot(sq_hom(1,:),sq_hom(2,:));
xlabel('X');
ylabel('Y');
title('Original Square-Euclidean space')
grid;
axis([-40,40,-40,40]);

%applying a rotation around Z axis with k=pi/6
k = pi/6;
rot_matrix = [cos(k), -sin(k), 0; sin(k), cos(k), 0; 0, 0 ,1];
sq_rot = rot_matrix*sq_hom;

%plotting the rotated square
figure
plot(sq_rot(1,:),sq_rot(2,:));
xlabel('X');
ylabel('Y');
title('Exercise Square-Euclidean space');
grid;
axis([-40,40,-40,40]);

%==============
% QUESTION 1
%==============

%first direction:
%line 1 from first and second columns of sq_rot
%line 2 from third and fourth columns of sq_rot
line_1_1 = cross(sq_rot(:,1),sq_rot(:,2));
line_2_1 = cross(sq_rot(:,3),sq_rot(:,4));

%calculating the lines of the first direction
x = linspace(-40,40,1000);
y1 = -(line_1_1(1,1)/line_1_1(2,1))*x-(line_1_1(3,1)/line_1_1(2,1));
y2 = -(line_2_1(1,1)/line_2_1(2,1))*x-(line_2_1(3,1)/line_2_1(2,1));

%plotting the first direction lines
figure
plot(sq_rot(1,:),sq_rot(2,:),'DisplayName','Square');
hold on
plot(x,y1,'DisplayName','Line 1');
plot(x,y2,'DisplayName','Line 2');
hold off
xlabel('X');
ylabel('Y');
title('First direction lines - Euclidean space');
grid;
legend('Location','best');
axis([-40,40,-40,40]);

%homogeneous coordinates of the first point of infinity
x_inf_1 = cross(line_1_1,line_2_1);

%second direction:
%line 1 from first and fourth columns of sq_rot
%line 2 from second and third columns of sq_rot
line_1_2 = cross(sq_rot(:,1),sq_rot(:,4));
line_2_2 = cross(sq_rot(:,2),sq_rot(:,3));

%calculating the lines of the second direction
y1 = -(line_1_2(1,1)/line_1_2(2,1))*x-(line_1_2(3,1)/line_1_2(2,1));
y2 = -(line_2_2(1,1)/line_2_2(2,1))*x-(line_2_2(3,1)/line_2_2(2,1));

%plotting the second direction
figure
plot(sq_rot(1,:),sq_rot(2,:),'DisplayName','Square');
hold on
plot(x,y1,'DisplayName','Line 1');
plot(x,y2,'DisplayName','Line 2');
hold off
xlabel('X');
ylabel('Y');
title('Second direction lines - Euclidean space');
grid;
legend('Location','best');
axis([-40,40,-40,40]);

%homogeneous coordinates of the second point of infinity
x_inf_2 = cross(line_1_2,line_2_2);

%homogeneous coordinates of the line of infinity
inf_line = cross(x_inf_1,x_inf_2);

%square diagonals
diag_1 = cross(sq_rot(:,1),sq_rot(:,3));
diag_2 = cross(sq_rot(:,2),sq_rot(:,4));

%calculating the diagonals lines
yd1 = -(diag_1(1,1)/diag_1(2,1))*x-(diag_1(3,1)/diag_1(2,1));
yd2 = -(diag_2(1,1)/diag_2(2,1))*x-(diag_2(3,1)/diag_2(2,1));

%plotting the diagonals
figure
plot(sq_rot(1,:),sq_rot(2,:),'DisplayName','Square');
hold on
plot(x,yd1,'DisplayName','Diagonal 1');
plot(x,yd2,'DisplayName','Diagonal 2');
hold off
xlabel('X');
ylabel('Y');
title('Diagonal lines - Euclidean space');
grid;
legend('Location','best');
axis([-40,40,-40,40]);

%intersection points of the diagonals with the line of infinity
x_1 = cross(inf_line,diag_1);
x_2 = cross(inf_line,diag_2);


%==============
% QUESTION 2
%==============

%camera parameters
c = 4195.17;
x_0 = -4.85;
y_0 = 16.63;
d1 = 4912;
d2 = 3264;

%boundaries of the photo
x_bound = d1/2;
y_bound = d2/2;
photo_bound = [-x_bound,x_bound,x_bound,-x_bound,-x_bound;y_bound,y_bound,-y_bound,-y_bound,y_bound];

%==================================================
% Uncomment the following code section to see
% the results of all possible angle combinations.
% There are 64 figures and only 2-3 of them include
% good results. We chose the best result and plot
% only that later.
%==================================================

% %camera position in the 3d space (above the box)
% X_0 = 50; %we also tried 0 and 35
% Y_0 = -35; %we also tried -25, -20 and 0
% Z_0 = 55; %we also tried 40,45,50,55,70
% %rotation angles
% ph_matrix = [-pi/6, -pi/7.2, -pi/9, -pi/12, pi/12, pi/9, pi/7.2, pi/6];
% om_matrix = [-pi/6, -pi/7.2, -pi/9, -pi/12, pi/12, pi/9, pi/7.2, pi/6];
% 
% %trying different rotations
% for i=1:size(ph_matrix,2)
%     ph = ph_matrix(i);
%     for j=1:size(om_matrix,2)
%         om = om_matrix(j);
%         %rotation around y axis
%         R_ph = [cos(ph),0,-sin(ph);0,1,0;sin(ph),0,cos(ph)];
%         %rotation around x axis
%         R_omega = [1,0,0;0,cos(om),sin(om);0,-sin(om),cos(om)];
%         %total rotation matrix
%         R_tot = R_ph*R_omega;
%         %third row of rotation matrix, needed for 1/k
%         rot_3 = R_tot(3,:);
%         %initialization of square coordinates in the photo
%         photo_cor = zeros(size(sq_rot));
% 
%         %simulating the photograph
%         for index=1:size(sq_rot,2)
%             k_tr = -c/(rot_3*([(sq_rot(1:2,index) - [X_0;Y_0]);-Z_0])); %1/k scale
%             photo_cor(:,index) = [x_0;y_0;0] + k_tr*(R_tot*[(sq_rot(1:2,index)- [X_0;Y_0]);-Z_0]);
%         end
%         %plotting the photo
%         figure
%         plot(photo_bound(1,:),photo_bound(2,:),'DisplayName','Photo Boundaries');
%         hold on
%         plot(photo_cor(1,:),photo_cor(2,:),'DisplayName','Square');
%         title(['Photo with rotations ω = ',num2str(om),' and φ = ',num2str(ph)])
%         legend('Location','best');
% 
%     end
% end



%============================================
% For X_0 = 50, Y_0 = -20 and Z_0 = 70 the
% best rotation angles are ω = pi/12 and 
% φ = pi/7.2. We plot the results for these
% parameters
%============================================

%rotation angles
om = pi/12;
ph = pi/7.2;

%camera position in the 3d space
X_0 = 50;
Y_0 = -20;
Z_0 = 70;

%rotation matrices
R_ph = [cos(ph),0,-sin(ph);0,1,0;sin(ph),0,cos(ph)];
R_omega = [1,0,0;0,cos(om),sin(om);0,-sin(om),cos(om)];
R_tot = R_ph*R_omega;

%third row of rotation matrix needed to calculate 1/k
rot_3 = R_tot(3,:);

%initializing the photo coordinates
photo_cor = zeros(size(sq_rot));

%using the parameters to simulate the photograph
for index=1:size(sq_rot,2)
    k_tr = -c/(rot_3*([(sq_rot(1:2,index) - [X_0;Y_0]);-Z_0])); %1/k scale
    photo_cor(:,index) = [x_0;y_0;0] + k_tr*(R_tot*[(sq_rot(1:2,index)- [X_0;Y_0]);-Z_0]);
end

%plotting the result
figure
plot(photo_bound(1,:),photo_bound(2,:),'DisplayName','Photo Boundaries');
hold on
plot(photo_cor(1,:),photo_cor(2,:),'DisplayName','Square');
hold off
xlabel('x');
ylabel('y');
title(['Photo with rotations ω = ',num2str(om),'rad and φ = ',num2str(ph),'rad']);
legend('Location','best');
axis([-2500,2500,-2000,2000]);




%vanishing points
%homogeneous coordinates of the box in the image
x_hom = [photo_cor(1:2,:);ones(1,size(photo_cor,2))];

%first direction:
%line 1 from first and second columns of x_hom
%line 2 from third and fourth columns of x_hom
line11 = cross(x_hom(:,1),x_hom(:,2));
line21 = cross(x_hom(:,3),x_hom(:,4));

%calculating the lines of the first direction
x = linspace(-2500,2500,10000);
y1 = -(line11(1,1)/line11(2,1))*x-(line11(3,1)/line11(2,1));
y2 = -(line21(1,1)/line21(2,1))*x-(line21(3,1)/line21(2,1));

%plotting the lines of the first direction
figure
plot(photo_bound(1,:),photo_bound(2,:),'DisplayName','Photo Boundaries');
hold on
plot(photo_cor(1,:),photo_cor(2,:),'DisplayName','Square');
plot(x,y1,'DisplayName','Line 1');
plot(x,y2,'DisplayName','Line 2');
hold off
xlabel('x');
ylabel('y');
title('First direction');
legend('Location','best');
axis([-2500,2500,-2000,2000]);

%homogeneous coordinates of the first vanishing point
first_point = cross(line11,line21);


%second direction:
%line 1 from first and fourth columns of x_hom
%line 2 from second and third columns of x_hom
line12 = cross(x_hom(:,1),x_hom(:,4));
line22 = cross(x_hom(:,2),x_hom(:,3));

%calculating the lines of the second direction
x = linspace(-2500,2500,10000);
y1 = -(line12(1,1)/line12(2,1))*x-(line12(3,1)/line12(2,1));
y2 = -(line22(1,1)/line22(2,1))*x-(line22(3,1)/line22(2,1));

%plotting the lines of the second direction
figure
plot(photo_bound(1,:),photo_bound(2,:),'DisplayName','Photo Boundaries');
hold on
plot(photo_cor(1,:),photo_cor(2,:),'DisplayName','Square');
plot(x,y1,'DisplayName','Line 1');
plot(x,y2,'DisplayName','Line 2');
hold off
xlabel('x');
ylabel('y');
title('Second direction');
legend('Location','best');
axis([-2500,2500,-2000,2000]);

%homogeneous coordinates of the second vanishing point
second_point = cross(line12,line22);

%============================================
% For X_0 = 50, Y_0 = -35 and Z_0 = 55 the
% best rotation angles are ω = pi/6 and 
% φ = pi/7.2. We plot the results for these
% parameters
%============================================

%rotation angles
om = pi/6;
ph = pi/7.2;

%camera posotion in the 3d space
X_0 = 50;
Y_0 = -35;
Z_0 = 55;

%rotation matrices
R_ph = [cos(ph),0,-sin(ph);0,1,0;sin(ph),0,cos(ph)];
R_omega = [1,0,0;0,cos(om),sin(om);0,-sin(om),cos(om)];
R_tot = R_ph*R_omega;

%third row of the rotation matrix needed to calculate 1/k
rot_3 = R_tot(3,:);

%initializing the photo coordinates
photo_cor2 = zeros(size(sq_rot));

%using the best parameters to simulate the photograph
for index=1:size(sq_rot,2)
    k_tr = -c/(rot_3*([(sq_rot(1:2,index) - [X_0;Y_0]);-Z_0])); %1/k scale
    photo_cor2(:,index) = [x_0;y_0;0] + k_tr*(R_tot*[(sq_rot(1:2,index)- [X_0;Y_0]);-Z_0]);
end

%plotting the result
figure
plot(photo_bound(1,:),photo_bound(2,:),'DisplayName','Photo Boundaries');
hold on
plot(photo_cor2(1,:),photo_cor2(2,:),'DisplayName','Square');
hold off
xlabel('x');
ylabel('y');
title(['Photo with rotations ω = ',num2str(om),'rad and φ = ',num2str(ph),'rad']);
legend('Location','best');
axis([-2500,2500,-2000,2000]);

%vanishing points
%homogeneous coordinates of the box in the image
x_hom2 = [photo_cor2(1:2,:);ones(1,size(photo_cor2,2))];

%using long format. Explained in the report
format long

%first direction:
%line 1 from first and second columns of x_hom
%line 2 from third and fourth columns of x_hom
line112 = cross(x_hom2(:,1),x_hom2(:,2));
line212 = cross(x_hom2(:,3),x_hom2(:,4));

%calculating the lines of the first direction
y12 = -(line112(1,1)/line112(2,1))*x-(line112(3,1)/line112(2,1));
y22 = -(line212(1,1)/line212(2,1))*x-(line212(3,1)/line212(2,1));

%plotting the lines of the first direction
figure
plot(photo_bound(1,:),photo_bound(2,:),'DisplayName','Photo Boundaries');
hold on
plot(photo_cor2(1,:),photo_cor2(2,:),'DisplayName','Square');
plot(x,y12,'DisplayName','Line 1');
plot(x,y22,'DisplayName','Line 2');
hold off;
xlabel('x');
ylabel('y');
title('First direction');
legend('Location','best');
axis([-2500,2500,-2000,2000]);

%homogeneous coordinates of the first vanishing point
first_point2 = cross(line112,line212);


%second direction:
%line 1 from first and fourth columns of x_hom
%line 2 from second and third columns of x_hom
line122 = cross(x_hom2(:,1),x_hom2(:,4));
line222 = cross(x_hom2(:,2),x_hom2(:,3));

%calculating the lines of the second direction
y12 = -(line122(1,1)/line122(2,1))*x-(line122(3,1)/line122(2,1));
y22 = -(line222(1,1)/line222(2,1))*x-(line222(3,1)/line222(2,1));

%plotting the lines of the second direction
figure
plot(photo_bound(1,:),photo_bound(2,:),'DisplayName','Photo Boundaries');
hold on
plot(photo_cor2(1,:),photo_cor2(2,:),'DisplayName','Square');
plot(x,y12,'DisplayName','Line 1');
plot(x,y22,'DisplayName','Line 2');
hold off
xlabel('x');
ylabel('y');
title('Second direction');
legend('Location','best');
axis([-2500,2500,-2000,2000]);

%homogeneous coordinates of the second vanishing point
second_point2 = cross(line122,line222);






