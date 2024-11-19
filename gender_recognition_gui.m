function enhanced_gender_recognition_gui
    % Create the main GUI window
    fig = uifigure('Name', 'Gender Voice Recognition', ...
        'Position', [500, 300, 500, 400]);

    % Title label
    titleLbl = uilabel(fig, 'Text', 'Gender Voice Recognition', ...
        'FontSize', 18, 'FontWeight', 'bold', ...
        'HorizontalAlignment', 'center', ...
        'Position', [50, 350, 400, 30]);

    % Add a button to load audio
    btnLoad = uibutton(fig, 'Text', 'Load Audio', ...
        'Position', [50, 280, 100, 30], ...
        'ButtonPushedFcn', @(~, ~) loadAudio(fig));

    % Add audio control buttons
    btnPlay = uibutton(fig, 'Text', 'Play', ...
        'Position', [200, 280, 70, 30], ...
        'Enable', 'off', 'ButtonPushedFcn', @(btn, ~) playAudio(fig, btn));

    btnPause = uibutton(fig, 'Text', 'Pause', ...
        'Position', [280, 280, 70, 30], ...
        'Enable', 'off', 'ButtonPushedFcn', @(btn, ~) pauseAudio(btn));

    btnStop = uibutton(fig, 'Text', 'Stop', ...
        'Position', [360, 280, 70, 30], ...
        'Enable', 'off', 'ButtonPushedFcn', @(btn, ~) stopAudio(btn));

    % Add axes for the waveform
    ax = uiaxes(fig, 'Position', [50, 100, 400, 150]);
    ax.Title.String = 'Audio Waveform';
    ax.XLabel.String = 'Time (s)';
    ax.YLabel.String = 'Amplitude';

    % Add a label for recognition results
    lblResult = uilabel(fig, 'Text', 'Gender: Not Detected', ...
        'Position', [50, 50, 400, 30], ...
        'FontSize', 14, 'FontWeight', 'bold', ...
        'HorizontalAlignment', 'center');

    % Store app data
    fig.UserData = struct('Axes', ax, 'Label', lblResult, ...
        'AudioData', [], 'SampleRate', [], ...
        'Player', [], 'PlayButton', btnPlay, ...
        'PauseButton', btnPause, 'StopButton', btnStop);
end

function loadAudio(fig)
    % Load the audio file
    [file, path] = uigetfile({'*.wav;*.mp3', 'Audio Files (*.wav, *.mp3)'});
    if isequal(file, 0)
        return; % Exit if no file is selected
    end
    [audio, fs] = audioread(fullfile(path, file)); % Read audio

    % Normalize and trim silence
    audio = audio(abs(audio) > 0.01);
    fig.UserData.AudioData = audio;
    fig.UserData.SampleRate = fs;

    % Plot waveform
    ax = fig.UserData.Axes;
    t = (0:length(audio)-1) / fs; % Time vector
    plot(ax, t, audio);
    title(ax, 'Audio Waveform');
    xlabel(ax, 'Time (s)');
    ylabel(ax, 'Amplitude');

    % Enable audio controls
    fig.UserData.PlayButton.Enable = 'on';
    fig.UserData.PauseButton.Enable = 'off';
    fig.UserData.StopButton.Enable = 'off';

    % Recognize gender
    lblResult = fig.UserData.Label;
    lblResult.Text = 'Processing...';
    gender = recognizeGender(audio, fs);
    lblResult.Text = ['Gender: ', gender];
end

function gender = recognizeGender(audio, fs)
    % Load the trained model
    load('D:\Matlab\gender_svm_model.mat', 'svmModel');

    % Extract MFCC features
    mfccFeatures = mfcc(audio, fs, 'NumCoeffs', 13);
    testFeature = mean(mfccFeatures, 1);

    % Predict gender
    prediction = predict(svmModel, testFeature);
    if prediction == 1
        gender = 'Male';
    else
        gender = 'Female';
    end
end

function playAudio(fig, btn)
    % Create audio player
    if isempty(fig.UserData.Player)
        audio = fig.UserData.AudioData;
        fs = fig.UserData.SampleRate;
        fig.UserData.Player = audioplayer(audio, fs);
    end

    % Play audio
    play(fig.UserData.Player);
    btn.Enable = 'off'; % Disable Play button
    fig.UserData.PauseButton.Enable = 'on';
    fig.UserData.StopButton.Enable = 'on';
end

function pauseAudio(btn)
    % Pause the audio
    player = btn.Parent.UserData.Player;
    if ~isempty(player) && isplaying(player)
        pause(player);
    end
end

function stopAudio(btn)
    % Stop the audio
    player = btn.Parent.UserData.Player;
    if ~isempty(player)
        stop(player);
    end

    % Reset buttons
    btn.Parent.UserData.PlayButton.Enable = 'on';
    btn.Parent.UserData.PauseButton.Enable = 'off';
    btn.Parent.UserData.StopButton.Enable = 'off';
end
