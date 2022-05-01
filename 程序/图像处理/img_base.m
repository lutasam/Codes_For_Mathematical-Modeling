clc
%% ͼ�����������ͼ���ȡ��ת������ʽ��
% ��ȡͼƬ
A = imread('img.jpg');

% չʾͼƬ
figure, imshow(A);

% ͼ��ĳ������ͨ����
height = size(A, 1);
width = size(A, 2);
number_of_channels = size(A, 3);

% ͼ��ߴ���������
B = imresize(A, 2.0);
figure, imshow(B);

% ��ʱ����ת
C = imrotate(A, 90);
figure, imshow(C);

% ƽ��ͼ��
A_trans = imtranslate(A, [5 15]);

% д��ͼ��
imwrite(A_trans, 'newimg.jpg');
figure,imshow(A_trans);

% ��֤ͨ�����Ƿ�Ϊ3
number_of_channels = size(A, 3)
 
% ��RGBͼ��ת��Ϊ�Ҷ�ͼ��
A_gray = rgb2gray(A);
number_of_channels2 = size(A_gray, 3)
figure, subplot(1, 2, 1), imshow(A), title('Input RGB image');
subplot(1, 2, 2), imshow(A_gray), title('Converted Grayscale image');

% ��ȡR��G��B����ͨ��
R = A(:, :, 1);
G = A(:, :, 2);
B = A(:, :, 3);
 
% ��RGBת��ΪHSV
A_hsv = rgb2hsv(A);
 
% ��ȡH,S,V
H = A_hsv(:, :, 1);
S = A_hsv(:, :, 2);
V = A_hsv(:, :, 3);
 
% չ��RGBͼ���HSVͼ��
figure, subplot(1, 2, 1), imshow(A), title('Read RGB image');
subplot(1, 2, 2), imshow(A_hsv), title('Converted HSV image');
 
% չ��HSV����ͨ�����
figure, subplot(1, 3, 1), imshow(S), title('Saturation channel');
subplot(1, 3, 2), imshow(H), title('Hue channel');
subplot(1, 3, 3), imshow(V), title('Value channel');