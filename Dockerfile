FROM ubuntu:xenial
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# setup keys
RUN apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116

# setup sources.list
RUN echo "deb http://packages.ros.org/ros/ubuntu xenial main" > /etc/apt/sources.list.d/ros-latest.list

# install additional tools
RUN apt-get update
RUN apt-get install -y git

# install ros Desktop-Full Install
RUN apt-get install -y ros-kinetic-desktop-full

# initialize rosdep
RUN rosdep init
RUN rosdep update

# environment setup
RUN echo "source /opt/ros/kinetic/setup.bash" >> ~/.bashrc

# install dependencies for building packages
RUN apt-get install -y python-rosinstall python-rosinstall-generator python-wstool build-essential

# install additional dependencies - see https://www.binarytides.com/install-wxwidgets-ubuntu/
RUN apt-get update
RUN apt-get install -y ros-kinetic-octomap*
RUN apt-get install -y python-rospkg
RUN apt-get update
RUN apt-get install -y qt5-default libeigen3-dev g++ ninja-build cmake clang-format-3.6 ccache libflann-dev qtdeclarative5-dev qtdeclarative5-qtquick2-plugin qml-module-qtquick-{controls,dialogs} libboost-all-dev
# download, build and install wxWidgets 3.1.1 release candidate
RUN mkdir -p ~/wxWidgets && \
    cd ~/wxWidgets
RUN apt-get install -y wget
RUN apt-get install -y tar
RUN wget https://github.com/wxWidgets/wxWidgets/releases/download/v3.1.1-rc/wxWidgets-3.1.1-rc.tar.bz2 && \
    tar xvjf wxWidgets-3.1.1-rc.tar.bz2 && \
    cd wxWidgets-3.1.1-rc && \
    ./configure --disable-shared --enable-unicode --with-opengl && \
    make && \
    make install

# final refresh and install catkin tools
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu `lsb_release -sc` main" > /etc/apt/sources.list.d/ros-latest.list'
RUN wget http://packages.ros.org/ros.key -O - | apt-key add -
RUN apt-get update
RUN apt-get install -y python-catkin-tools
RUN rosdep update
RUN apt-get update
