% Load the trained model
load('gender_svm_model.mat', 'svmModel');

% Load a test audio file
[audio, fs] = audioread('D:\Matlab\audio\male-laugh-242216.mp3');
audio = audio(abs(audio) > 0.01); % Remove silence

% Extract features
mfccFeatures = mfcc(audio, fs, 'NumCoeffs', 13);
testFeature = mean(mfccFeatures, 1);

% Predict gender
prediction = predict(svmModel, testFeature);
if prediction == 1
    disp('Predicted: Male');
else
    disp('Predicted: Female');
end
