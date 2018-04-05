function [output_image] = rgb2opponent(input_image)
% RGB2OPPONENT     Converts an RGB image into opponent color space.

output_image = zeros(size(input_image));

R = input_image(:, :, 1); 
G = input_image(:, :, 2); 
B = input_image(:, :, 3);

output_image(:, :, 1) = (R - G) / sqrt(2);
output_image(:, :, 2) = (R + G - 2 * B) / sqrt(6);
output_image(:, :, 3) = (R + G + B) / sqrt(3);

end

