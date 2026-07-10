# Kinematic Model of a Moving Drone's Telemetry Stream
This notebook represents a kinematic model of telemetry data from a moving drone. A kinematic model describes the movement of objects using variables such as position, velocity, and acceleration, without considering the underlying forces that cause the motion. In this case, we are predicting the next position of the drone based on its current position and velocity.

## Methodology

### Data Preprocessing

The first step of the notebook is the data preprocessing, where the mavlink data of the drone and the ground control station (GCS) are loaded. We add a prefix to their packet type to be easily identified (UAV_/GCS_). The `time_boot_ms` column which provides the system time since boot, is normalized by the minimum time to start the timestamp from zero. All of them are then combined into one dataframe, sorted by time in ascending order, and some columns are converted into their correct units.

### Conversion to East, North, Up (ENU) coordinates

In the field of aerial vehicles, including drones, a common coordinate system used is the East, North, Up (ENU) system. In this system:

- The x-axis points towards the North.
- The y-axis points towards the East.
- The z-axis points Upwards.

To transform the GPS (latitude, longitude, altitude) coordinates into ENU, we use the `geodetic2enu` function from the `pymap3d` library. The conversion needs a reference point, which is in this case the starting point of the drone.

> ⚠️ E, N, U is not in the same order as X, Y, Z. The result of `pymap3d.geodetic2enu()` must be unpacked like `y, x, z = pymap3d.geodetic2enu()`

### Kinematic Prediction

To predict the position of the drone in the next timestamp, we use a basic kinematic equation:

```position_next = position_current + velocity_current * time_to_next```

Where `time_to_next` is the difference in time between two consecutive timestamps. This equation assumes that the drone moves at a constant velocity, thus it's a simple approximation that does not consider any changes in velocity (acceleration).

In this example, we are forecasting the drone's location for the upcoming timestamp. This allows us to compare our prediction with the actual reported location at that subsequent timestamp.

### Evaluation

The predictions are evaluated by calculating the Euclidean distance between the predicted and actual positions. The Euclidean distance between two points in 3D space is calculated as follows:

```distance = sqrt((x1-x2)^2 + (y1-y2)^2 + (z1-z2)^2)```

The distances are then converted into centimeters and visualized by a histogram.

#### What these distances mean
The distances calculated in this model represent the adjustments anticipated in real-time drone operations. Specifically, the gimbal on the drone will follow each predicted vector until it reaches the predicted location. Then it will need to "jump" to the next actual reported location. These 'jumps' are represented by the distances we have calculated. 

Assuming that the reported locations are completely accurate, these distances provide a good estimation of the potential error expected in the model. They could be used to inform the design parameters of the receiving device on the drone. However, it's important to consider some degree of error in the reported location data itself. Additionally, the mechanical inaccuracies or latency in the drone's pan-tilt unit can also contribute to the overall model error. Therefore, due to the combined implications of location data inaccuracies and the mechanical response of the drone's pan-tilt unit, the calculated error should not be solely used to determine the design requirements of the receiving device on the drone.

### Visualization

Although drone motion in 3D space is best visualized with a 3D plot, 2D plots might be more convenient in some situations. Thus, both 3D and 2D plots are made, where each point corresponds to a timestamp, and a line is drawn to the point that represents the predicted position for the next timestamp.

### Fourier Transform Analysis

I used the Fourier Transform as a tool to analyze the inconsistency in the vertical velocity ('vz') of the drone. Initially, the error in the z-direction of the drone movement wasn't making sense, so I used the spectral analysis to examine the dominant frequencies that make up the 'vz' signal. On plotting these frequencies, I noticed a significant spike at approximately 1.2Hz.

Interestingly, this dominant frequency at 1.2Hz matched the frequency observed from my smartphone's accelerometer while I was walking with the drone. In essence, the Fourier Transform helped me realize that the drone's vertical velocity was significantly influenced by my walking rhythm.
