function [output_image] = rgb2normedrgb(input_image)
% RGB2NORMEDRGB     Converts an RGB image into normalized rgb.

output_image = zeros(size(input_image));

R = input_image(:, :, 1); 
G = input_image(:, :, 2); 
B = input_image(:, :, 3);

output_image(:, :, 1) = R ./ (R + G + B);
output_image(:, :, 2) = G ./ (R + G + B);
output_image(:, :, 3) = B ./ (R + G + B);

end

