clear all;
port = "COM5";
uart = serialport(port, 9600);
uart.Timeout = 20;
configureTerminator(uart, "LF");
sze = 8;
img = imread("dog.jpg");
resize_img = imresize(img,[sze,sze]);
data = uint8(resize_img);
%data = uint8(rgb2gray(resize_img)); //for grayscale

data_back = zeros(sze);
data_back(:,:,2) = zeros(sze);
data_back(:,:,3) = zeros(sze);

write(uart, uint8(10), "uint8" );
read(uart, 100, "uint8");

for i = 1:sze
     for j = 1:sze
         for k = 1:3
            write(uart, data(i, j, k), "uint8");
            read_mat = read(uart, 40, "uint8");
            data_back(i, j, k) = read_mat(30);
         end
    end
end

figure;
subplot(1, 2, 1);
imshow(data);
title('Original Image');

subplot(1, 2, 2);
imshow(uint8(data_back));
title('Processed Image');