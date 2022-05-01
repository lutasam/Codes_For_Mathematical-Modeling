clc
%% 图像基本操作（图像读取，转换，格式）
% 读取图片
A = imread('img.jpg');

% 展示图片
figure, imshow(A);

% 图像的长、宽和通道数
height = size(A, 1);
width = size(A, 2);
number_of_channels = size(A, 3);

% 图像尺寸扩大两倍
B = imresize(A, 2.0);
figure, imshow(B);

% 逆时针旋转
C = imrotate(A, 90);
figure, imshow(C);

% 平移图像
A_trans = imtranslate(A, [5 15]);

% 写出图像
imwrite(A_trans, 'newimg.jpg');
figure,imshow(A_trans);

% 验证通道数是否为3
number_of_channels = size(A, 3)
 
% 将RGB图像转化为灰度图像
A_gray = rgb2gray(A);
number_of_channels2 = size(A_gray, 3)
figure, subplot(1, 2, 1), imshow(A), title('Input RGB image');
subplot(1, 2, 2), imshow(A_gray), title('Converted Grayscale image');

% 提取R，G，B三个通道
R = A(:, :, 1);
G = A(:, :, 2);
B = A(:, :, 3);
 
% 将RGB转化为HSV
A_hsv = rgb2hsv(A);
 
% 提取H,S,V
H = A_hsv(:, :, 1);
S = A_hsv(:, :, 2);
V = A_hsv(:, :, 3);
 
% 展现RGB图像和HSV图像
figure, subplot(1, 2, 1), imshow(A), title('Read RGB image');
subplot(1, 2, 2), imshow(A_hsv), title('Converted HSV image');
 
% 展现HSV三个通道结果
figure, subplot(1, 3, 1), imshow(S), title('Saturation channel');
subplot(1, 3, 2), imshow(H), title('Hue channel');
subplot(1, 3, 3), imshow(V), title('Value channel');