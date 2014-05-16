muzza
=====

## Pre Requisites

Install Android SDK

- Download SDK: http://developer.android.com/sdk/index.html?hl=sk#download
- Select Use an Existing IDE
- Unzip to desired folder
- Run ./tools/android update sdk --no-ui
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

    bower install

## Flow

    grunt serve

Add platform

    grunt platform:add:android

Prepare for Android

    grunt cordova

Run emulator

    grunt ripple


