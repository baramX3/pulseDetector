# Pulse Detector
This is a repository for detecting pulse from a video recorded on a smartphone camera.

## Workflow
Before beginning the processing, a video of at least 40 seconds must be obtained.

The pulse detector is done in a two-step process:
1. Extract mean pixel intensities of every frame from a video recorded on a smartphone
2. Extract the pulse based on a periodic pattern in the mean pixel intensity across the video

During the first step, utilize the jupyter notebook `mean_pixel_int_calculator.ipynb`. The file takes in inputs of video files and outputs .csv file with the mean pixel intensities (in greyscale) of a video. One .csv file is created per video.

During the second step, utilize the matlab script `pulse_calculator.m`. The file takes in inputs of .cvs files (generated from above) and outputs an estimated pulse rate. The file can also be used to visualize the power spectrum of the Fourier Transform used to extract the pulse rate.

## Requirments and guidelines
When recording the video:
1. It is recommended to firmly press the index finger up against the camera in a well-lit environment
2. Flashlight on a smartphone may be turned on if the environment is not well-lit
3. Lock the auto-exposure and auto-focus function of the video before recording
4. Record a video for minimum 40 seconds

To run `mean_pixel_int_calculator.ipynb`:
1. Python 3.0 or above must be installed
2. Edit the `file_dir` and `file_extension` variable accordingly

To run `pulse_calculator.m`:
1. MatLab must be intalled
2. Input .csv files must be placed in the working directory

