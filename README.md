# Computer Vision Assignments
Here you can find the code I wrote during the Computer Vision and Photogrammetry course

Code of the first assignment includes:

1)Simple operations in homogeneous coordinates. 
2)Finding the points of infinity of a square and the the line of infinity. Then finding the points of intersection of the square diagonals with the line of infinity. 
3)Assuming pinhole camera we are using the collinearity condition to simulate the photograph taken of the square with a camera of 4912x3264 pixel. After that we calculate the vanishing points of the square in the simulated photograph.

Code of the second assignment (project_2.m file) includes:

1)Least squares method to calculate the Homography matrix and the inverse homography matrix of the "chess.jpg" image, using the space and image coordinates of 8 points on the chess board.
2)Using the inverse homography matrix and Nearest Neighbor resampling to reconstruct the surface of the chess board, correcting the perspective deformations of the original image. The result is then save in a new image called "chess_final.jpg"
