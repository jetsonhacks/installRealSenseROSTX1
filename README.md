# installRealSenseROSTX1
Install librealsense and realsense ROS package on NVIDIA Jetson TX1
The installLibRealSenseROS script install librealsense and realsense as ROS packages. These scripts have been tested with a RealSense R200 camera.

This is the third step of a three step process.

The first step requires a kernel modification. librealsense requires a modified kernel which modularizes uvcvideo and adds the RealSense video modes to the uvcvideo driver.

The easiest way to accomplish this is to use the 'installLibrealsenseTX1' repository on the Github JetsonHacks account (https://github.com/jetsonhacks/installLibrealsenseTX1). There are scripts which download the kernel source, apply the necessary patches, make the kernel, and then copy the kernel images to the boot directory. There are also scripts to build the librealsense library itself, which is useful for testing purposes.

Because space is tight on the TX1, one probably does not want the kernel sources and images stored on the device. Typically the kernel is modified and built, then once everything has been installed the sources removed.

The second step is to install ROS on the Jetson TX1. There are convenience scripts to help do this on the Github JetsonHacks account in the installROSTX1 repository (https://github.com/jetsonhacks/installROSTX1). Note that the repository installs ros-base, if other configurations such as ros-desktop are desired, the scripts should be modified accordingly.

This step, the third step, is to install librealsense and realsense as ROS packages. The script installRealSenseROS.sh in this directory will install librealsense and realsense and dependencies in a Catkin Workspace. Note that the previous librealsense installation, though valid, then becomes superflous.

To install:

$ ./installRealSenseROS.sh \<catkin_ws_name\>

The script 'setupTX1.sh' simply turns off the USB autosuspend setting on the TX1 so that the camera is always available. 

This installs realsense version 1.5.
