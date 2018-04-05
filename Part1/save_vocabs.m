d = load('descriptors\descriptors_gray_sift.mat');
des = d.descriptors;
save_visual_vocabulary(des, 'gray', 'sift', 400, 1000000, 400);

d = load('descriptors\descriptors_norm_rgb_sift.mat');
des = d.descriptors;
save_visual_vocabulary(des, 'norm_rgb', 'sift', 1000, 6000000, 400);

d = load('descriptors\descriptors_RGB_sift.mat');
des = d.descriptors;
save_visual_vocabulary(des, 'RGB', 'sift', 1000, 6000000, 400);

d = load('descriptors\descriptors_opponent_sift.mat');
des = d.descriptors;
save_visual_vocabulary(des, 'opponent', 'sift', 1000, 6000000, 400);