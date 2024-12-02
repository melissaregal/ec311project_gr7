clear all;

% UART communication
uart = serialport('COM4', 9600); 
uart.Timeout = 30;
flush(uart); % Clear UART buffers

% 8x8 grayscale image (values 0 to 255) (Test Image)
gray_image = uint8([  0,  32,  64,  96, 128, 160, 192, 224;
                     32,  64,  96, 128, 160, 192, 224, 255;
                     64,  96, 128, 160, 192, 224, 255, 224;
                     96, 128, 160, 192, 224, 255, 224, 192;
                    128, 160, 192, 224, 255, 224, 192, 160;
                    160, 192, 224, 255, 224, 192, 160, 128;
                    192, 224, 255, 224, 192, 160, 128,  96;
                    224, 255, 224, 192, 160, 128,  96,  64]);

% OG 8x8 image
disp('Original 8x8 grayscale image:');
disp(gray_image);

% Display each pixel of the original image
disp('Pixel values of the original 8x8 image:');
for row = 1:size(gray_image, 1)
    for col = 1:size(gray_image, 2)
        fprintf('Pixel (%d, %d): %d\n', row, col, gray_image(row, col));
    end
end

% Reshape for UART communication
data = reshape(gray_image', [], 1); % Reshape to 1D array

% Send the 8x8 image via UART
disp('Sending 8x8 image data...');
write(uart, data, 'uint8'); % Send as uint8

% Receive the processed 8x8 image data
disp('Waiting to receive processed data...');
processed_data = read(uart, numel(data), 'uint8'); % Read the same number of elements

% Reshape back to 8x8 for verification
processed_image = reshape(processed_data, size(gray_image'))';

% Display the processed 8x8 image
disp('Processed 8x8 grayscale image:');
disp(processed_image);

% Display each pixel of the processed image
disp('Pixel values of the processed 8x8 image:');
for row = 1:size(processed_image, 1)
    for col = 1:size(processed_image, 2)
        fprintf('Pixel (%d, %d): %d\n', row, col, processed_image(row, col));
    end
end

% Visualize the original and processed images
figure;
subplot(1, 2, 1);
imshow(gray_image, [0, 255]);
title('Original 8x8 Image');

subplot(1, 2, 2);
imshow(processed_image, [0, 255]);
title('Processed 8x8 Image');
