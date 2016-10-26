#!/bin/bash
# Install the Intel Realsense library librealsense on a Jetson TX1 Development Kit
# Copyright (c) 2016 Jetsonhacks 
# MIT License
# Usage:
# ./installLibRealSense.sh <catkin workspace>
# If <catkin workspace> is omitted "catkin_ws" assumed
# ROS should already be installed, and a catkin workspace created
# Figure out where to install librealsense
# Save the directory we're installing from:
INSTALL_DIR=$PWD
# Now go get ready to install librealsense
source /opt/ros/kinetic/setup.bash
DEFAULTDIR=catkin_ws
CLDIR="$1"
if [ ! -z "$CLDIR" ]; then 
 DEFAULTDIR="$CLDIR"
fi
# Check to see if qualified path already
if [ -d "$DEFAULTDIR" ] ; then
   echo "Fully qualified path"
else
   # Have to add path qualification
   DEFAULTDIR=$HOME/$DEFAULTDIR
fi
echo "DEFAULTDIR: $DEFAULTDIR"



if [ -e "$DEFAULTDIR" ] ; then
  echo "$DEFAULTDIR exists" 
  CATKIN_WORKSPACEHIDDEN=$DEFAULTDIR/.catkin_workspace
  if [ -e "$CATKIN_WORKSPACEHIDDEN" ] ; then
	# This appears to be a Catkin_Workspace
	echo "Found catkin workspace in directory: $DEFAULTDIR"
  else
	echo "$DEFAULTDIR does not appear to be a Catkin Workspace"
        echo "The directory does not contain the hidden file .catkin_workspace"
	echo "Terminating Installation"
	exit 1
  fi
else 
  echo "Catkin Workspace named $DEFAULTDIR does not exist"
  echo "Please create a Catkin Workspace before installation"
  echo "Terminating Installation"
  exit 1
fi
if [ "${DEFAULTDIR: -1}" != "/" ] ; then
	DEFAULTDIR=$DEFAULTDIR/
fi

INSTALLDIR="$DEFAULTDIR"src
if [ -e "$INSTALLDIR" ] ; then
  echo "Installing librealsense in: $INSTALLDIR"
else
  echo "$INSTALLDIR does not appear to be a source of a Catkin Workspace"
  echo "The source directory src does not exist"
  echo "Terminating Installation"
  exit 1
fi 

echo "Starting installation of librealsense"

cd $INSTALLDIR
git clone https://github.com/IntelRealSense/librealsense.git
cd librealsense
# Checkout version 1.11.0 of librealsense, last tested version
git checkout v1.11.0
# git checkout 74ff66da50210e6b9edc3157411bad95c209740f
# Patches uvc-v4l2.cpp to avoid crash; removes -sse flag from .pro file 
patch -p1 -i $INSTALL_DIR/patches/arm.patch
# Patch the ROS package file to not include the Linux kernel 4.4 headers
patch -i $INSTALL_DIR/patches/linuxheaders.patch
# Copy over the udev rules so that camera can be run from user space
sudo cp config/99-realsense-libusb.rules /etc/udev/rules.d/
sudo udevadm control --reload-rules && udevadm trigger
# Now build the library
cd ../..
echo "Currently in: $PWD"
source devel/setup.bash
catkin_make
echo "Librealsense installed."

cd $INSTALLDIR
echo "Starting installation of RealSense ROS package"
echo "Installing support packages"
sudo apt-get update
sudo apt-get install ros-kinetic-cv-bridge -y
sudo apt-get install ros-kinetic-image-transport -y
sudo apt-get install ros-kinetic-camera-info-manager -y
sudo apt-get install ros-kinetic-tf -y
sudo apt-get install ros-kinetic-pcl-ros -y
sudo apt-get install ros-kinetic-rgbd-launch -y

git clone https://github.com/intel-ros/realsense.git
cd realsense
git checkout 1.5.0
cd ../..
rosdep install --skip-keys=librealsense --from-paths -i src/librealsense
catkin_make
echo "RealSense ROS Package installed"

