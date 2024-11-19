# Gender Voice Recognition Project on Matlab
## Overview
The Gender Voice Recognition project is designed to predict the gender of a speaker based on their voice. The system uses audio files (in .wav or .mp3 format) as input, extracts relevant audio features (MFCCs - Mel-frequency cepstral coefficients), and classifies the speaker’s gender using a machine learning model. The project includes a graphical user interface (GUI) in MATLAB that allows users to load audio files, play them, visualize the waveform, and display the gender prediction result.

### This project employs a Support Vector Machine (SVM) classifier, trained on audio data with labeled gender information, to make predictions.

## Project Components
1. **MATLAB GUI (gender_recognition_gui.m)**
**Purpose:** This is the main GUI script that manages user interactions. It includes features such as loading audio, playing audio, pausing, and stopping the audio. It also displays the predicted gender based on the audio input.
## Key Functions:
**loadAudio:** Loads and displays the audio waveform, and extracts the audio data.
**recognizeGender:** Predicts the gender by extracting MFCC features and using the trained SVM model.
playAudio, pauseAudio, stopAudio: Control the playback of the audio.
2. **Gender Recognition Model (gender_svm_model.mat)**
**Purpose:** This file contains the pre-trained Support Vector Machine (SVM) model used to predict the gender based on extracted features (MFCC).
Training the Model: The model is trained using features extracted from audio files labeled as "Male" or "Female". The MFCCs serve as the feature set for training the model.
3. **Dataset (Audio/)**
**Purpose:** The dataset folder contains audio files labeled as male and female voices. These audio files are used to train and evaluate the gender prediction model.
## Folder Structure:
* In audio file subfolders:
Male/ – Contains audio files of male voices.
Female/ – Contains audio files of female voices.
* In GUI Screen-shot folder: working of the model to predict male or female voice
4. **Feature Extraction (mfcc.m)**
**Purpose:** This script extracts MFCC features from audio signals. The extracted features are used for gender classification.
Method: MFCC is a widely-used feature extraction method in speech and audio processing. The mfcc.m function computes the MFCCs from the audio signal, which are then used by the SVM model for classification.
