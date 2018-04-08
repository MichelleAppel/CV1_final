function create_html_files(vocab_size, color_space, sift_method)

    if nargin < 1
        vocab_size = 200;
    end
    if nargin < 2
        color_space = 'gray';
    end
    if nargin < 3
        sift_method = 'sift';
    end
        
    file_name = strcat('results/vocab_size_', int2str(vocab_size), ...
    '/results_', color_space, '_', sift_method, '_airplanes.mat');
    airplanes_results = load(file_name);
    airplanes_results = flipud(airplanes_results.sorted_results);
    airplanes_file_names = airplanes_results(:, 5);

    file_name = strcat('results/vocab_size_', int2str(vocab_size), ...
    '/results_', color_space, '_', sift_method, '_cars.mat');
    cars_results = load(file_name);
    cars_results = flipud(cars_results.sorted_results);
    cars_file_names = cars_results(:, 5);
    
    file_name = strcat('results/vocab_size_', int2str(vocab_size), ...
    '/results_', color_space, '_', sift_method, '_faces.mat');
    faces_results = load(file_name);
    faces_results = flipud(faces_results.sorted_results);
    faces_file_names = faces_results(:, 5);
    
    file_name = strcat('results/vocab_size_', int2str(vocab_size), ...
    '/results_', color_space, '_', sift_method, '_motorbikes.mat');
    motorbikes_results = load(file_name);
    motorbikes_results = flipud(motorbikes_results.sorted_results);
    motorbikes_file_names = motorbikes_results(:, 5);

    airplanes_MAP = round(avg_precision(vocab_size, color_space, sift_method, 'airplanes'), 2);
    cars_MAP = round(avg_precision(vocab_size, color_space, sift_method, 'cars'), 2);
    faces_MAP = round(avg_precision(vocab_size, color_space, sift_method, 'faces'), 2);
    motorbikes_MAP = round(avg_precision(vocab_size, color_space, sift_method, 'motorbikes'), 2);
    mean_MAP = round((airplanes_MAP+cars_MAP+faces_MAP+motorbikes_MAP)/4, 2);

    file_name = strcat('../html_formats/ordered_', int2str(vocab_size), ...
        '_', color_space, '_', sift_method, '.html');
    if exist(file_name, 'file') == 0
        disp('File does not exist, creating file.')
        f = fopen(file_name, 'w');

        fprintf(f, '<!DOCTYPE html>\n');
        fprintf(f, '<html lang="en">\n');
        fprintf(f, '\t<head>\n');
        fprintf(f, '\t\t<meta charset="utf-8">\n');
        fprintf(f, '\t\t<title>Image list prediction</title>');
        fprintf(f, '\t<style type="text/css">');
        fprintf(f, '\timg {\n');
        fprintf(f, '\t\twidth:200px;\n');
        fprintf(f, '\t}\n');
        fprintf(f, '\t</style>\n');
        fprintf(f, '\t</head>\n');
        fprintf(f, '\t<body>\n');
        fprintf(f, '\n');
        fprintf(f, '<h2>Michelle Appel, Nils Hulzebosch</h2>\n');
        fprintf(f, '<h1>Settings</h1>');
        fprintf(f, '<table>');

        if strcmp(sift_method, 'sift')
            fprintf(f, '<tr><th>SIFT step size</th><td>N/A</td></tr>');
            fprintf(f, '<tr><th>SIFT block sizes</th><td>N/A</td></tr>');
        else
            fprintf(f, '<tr><th>SIFT step size</th><td>15 px</td></tr>');
            fprintf(f, '<tr><th>SIFT block sizes</th><td>4, 6, 8, 10 pixels</td></tr>');
        end

        fprintf(f, strcat('<tr><th>SIFT method</th><td>', ...
            color_space, '-', sift_method, '</td></tr>'));
        fprintf(f, strcat('<tr><th>Vocabulary size</th><td>', ...
            int2str(vocab_size), ' words</td></tr>'));
        fprintf(f, '<tr><th>Vocabulary fraction</th><td>0.70</td></tr>');
        fprintf(f, '<tr><th>SVM training data</th><td>500 positive, 167 negative per class</td></tr>');
        fprintf(f, '<tr><th>SVM kernel type</th><td>Linear</td></tr>');
        fprintf(f, '</table>');
        fprintf(f, strcat('<h1>Prediction lists (MAP: ', num2str(mean_MAP), ')</h1>'));
        fprintf(f, '<table>');
        fprintf(f, '<thead>');
        fprintf(f, '<tr>');
        fprintf(f, strcat('<th>Airplanes (AP: ', num2str(airplanes_MAP), ')</th>', ...
                          '<th>Cars (AP: ', num2str(cars_MAP), ')</th>', ...
                          '<th>Faces (AP: ', num2str(faces_MAP), ')</th>', ...
                          '<th>Motorbikes (AP: ', num2str(motorbikes_MAP), ')</th>'));
        fprintf(f, '</tr>');
        fprintf(f, '</thead>');
        fprintf(f, '<tbody>');

        for i = 1:200
            line = strcat('<tr>', ...
                '<td><img src="../Caltech4/ImageData/', airplanes_file_names{i},    '.jpg" /></td>', ...
                '<td><img src="../Caltech4/ImageData/', cars_file_names{i},         '.jpg" /></td>', ...
                '<td><img src="../Caltech4/ImageData/', faces_file_names{i},        '.jpg" /></td>', ...
                '<td><img src="../Caltech4/ImageData/', motorbikes_file_names{i},   '.jpg" /></td>', ...
                '</tr>\n');
            fprintf(f, line);
        end
        
        fprintf(f, '</tbody>');
        fprintf(f, '</table>');
        fprintf(f, '</body>');
        fprintf(f, '</html>');
        
        fclose(f);
    else
        disp('File already exists.');
    end

end

