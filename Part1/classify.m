function [ class, scores ] = classify(image, vocab_size, color_space, sift_method)
    
    dir = strcat('models/vocab_size_', string(vocab_size), '/');
    file = strcat('model_', color_space, '_', sift_method, '_');

    
    airplane_model = load(strcat(dir, file, 'airplanes'));
    airplane_model = airplane_model.model;
    
    cars_model = load(strcat(dir, file, 'cars'));
    cars_model = cars_model.model;
    
    faces_model = load(strcat(dir, file, 'faces'));
    faces_model = faces_model.model;
    
    motorbikes_model = load(strcat(dir, file, 'motorbikes'));
    motorbikes_model = motorbikes_model.model;
    
    
    vocabulary = load(strcat('vocabs/vocab_size_', string(vocab_size), '/vocab_', string(vocab_size), '_', color_space, '_', sift_method));
    vocabulary = vocabulary.visual_vocab;
    
    BoF = bag_of_features(image, vocabulary, color_space, sift_method)'; % Bag of features for the image
    BoF = BoF';

    [ ~, airplane_score ] = predict(airplane_model, BoF);
    [ ~, cars_score ] = predict(cars_model, BoF);
    [ ~, faces_score ] = predict(faces_model, BoF);
    [ ~, motorbikes_score ] = predict(motorbikes_model, BoF);

    scores = [ airplane_score(2), cars_score(2), faces_score(2), motorbikes_score(2) ];

    [ ~, class ] = max(scores);
end