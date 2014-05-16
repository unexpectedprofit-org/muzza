muzza
=====

## Pre Requisites

Install NodeJS

Install Android SDK

- Download SDK: http://developer.android.com/sdk/index.html?hl=sk#download
- Select Use an Existing IDE
- Unzip to desired folder
- Run ./tools/android update sdk --no-ui

    You may also want to see the ui or setup a proxy.

    - Run ./tools/android update sdk

- Add to your bash profile:

    export ANDROID_HOME="$HOME/applications/android-sdk-linux/tools"
    export ANDROID_PLATFORM_TOOLS="$HOME/applications/android-sdk-linux/platform-tools"
    export PATH="$ANDROID_HOME:$ANDROID_PLATFORM_TOOLS:$PATH"

Install ANT if you dont have it and set

    export ANT_HOME="$HOME/ant"
    export PATH="$PATH:$ANT_HOME/bin"

Install Compass

    gem install compass

## Setup

1- Checkout the project

    git clone https://github.com/unexpectedprofit-org/muzza.git
    cd muzza
    mkdir platforms
    mkdir plugins

2- Install dependencies

    npm install

note: you may need to run it as sudo. this depends on your setup.

    bower install

## Troubleshooting setup

Linux only - You may need to install the following:

    sudo apt-get install default-jdk

    sudo apt-get install ia32-libs (NA in ubuntu 14)
    sudo apt-get install lib32z1
    sudo apt-get install lib32stdc++6

## Flow

Build web version:

    grunt serve

Add platform

    grunt platform:add:android

Build mobile version:

    grunt build

(check www folder generated)
Note: grunt Build is running grunt cordova

Run Ripple emulator

    grunt ripple

Run Android emulator (this takesa while to stand up)

    grunt emulate:android

Run IOS emulator (requires additional setup)

    grunt emulate:ios
