# react-native-signature-captur

## About this
React Native library for capturing signature

This repo is an advanced version of <a href="https://github.com/RepairShopr/react-native-signature-capture/pull/97">react-native-signature-capture</a> which new props to set background color and as very good usage example

There is a <a href="https://github.com/RepairShopr/react-native-signature-capture/pull/97">Pull request 97</a> submitted to the parent repo, but as the repo is not active right now you can directly use it from here

User would sign on the app and when you press the save button it returns the base64 encoded png

### iOS
<img src="http://i.giphy.com/3oEduIyWb48Ws3bSuc.gif" />

### Android
<img src="http://i.giphy.com/xT0GUKJFFkdDv25FNC.gif" />

## Install

First you need to install react-native-signature-capture:

```sh
npm install react-native-signature-capture --save
```

Second you need to link react-native-signature-capture:

```sh
react-native link react-native-signature-capture
```

Use above `react-native link` command to automatically complete the installation, or link manually like so:

### iOS

1. In the XCode's "Project navigator", right click on your project's Libraries folder ➜ Add Files to <...>
2. Go to node_modules ➜ react-native-signature-capture ➜ ios ➜ select RSSignatureCapture.xcodeproj
3. Add libRSSignatureCapture.a to Build Phases -> Link Binary With Libraries
4. Compile and have fun

### Android

Add these lines in your file: android/settings.gradle

```
...

include ':reactnativesignaturecapture',':app'
project(':reactnativesignaturecapture').projectDir = new File(settingsDir, '../node_modules/react-native-signature-capture/android')
```

Add line in your file: android/app/build.gradle

```
...

dependencies {
    ...
    compile project(':reactnativesignaturecapture') // <-- add this line
}
```

Add import and line in your file: android/app/src/main/java/<...>/MainApplication.java

```java
...

import com.rssignaturecapture.RSSignatureCapturePackage; // <-- add this import

public class MainApplication extends Application implements ReactApplication {

    private final ReactNativeHost mReactNativeHost = new ReactNativeHost(this) {

        @Override
        protected List<ReactPackage> getPackages() {
            return Arrays.<ReactPackage>asList(
                new MainReactPackage(),
                new RSSignatureCapturePackage() // <-- add this line
            );
        }
  }

...
}
```

## Usage

Then you can use SignatureCapture component in your react-native's App, like this:
```javascript
...
import React, {Component} from 'react';
import SignatureCapture from 'react-native-signature-capture';

class CustomComponent extends Component {

  ...
  render() {
    return (
      <SignatureCapture
        {...someProps}
      />
    );
  }
}
```

### Properties

+ **saveImageFileInExtStorage** : Make this props true, if you want to save the image file in external storage. Default is false. Warning: Image file will be visible in gallery or any other image browsing app

+ **strokeColor** : sets the pencil color of the signature view. Supported Color format are  #RRGGBB #AARRGGBB 'red', 'blue', 'green', 'black', 'white', 'gray', 'cyan', 'magenta', 'yellow', 'lightgray', 'darkgray'.

+ **showNativeButtons** : If this props is made to true, it will display the native buttons "Save" and "Reset".

+ **showTitleLabel** : If this props is made to true, it will display the "x_ _ _ _ _ _ _ _ _ _ _" placeholder indicating where to sign.

+ **viewMode** : "portrait" or "landscape" change the screen orientation based on boolean value

+ **minStrokeWidth** : sets the width of the minimum stroke

+ **maxStrokeWidth** : sets the width of the maximum stroke

+ **maxSize**  : sets the max size of the image maintains aspect ratio, default is 500

+ **backgroundColor** (only in android for now) : sets the background color of the signature view. Supported Color format are  #RRGGBB #AARRGGBB 'red', 'blue', 'green', 'black', 'white', 'gray', 'cyan', 'magenta', 'yellow', 'lightgray', 'darkgray'.
+ + ```backgroundColor="transparent"```  -  background will be transparent

### Methods

+ **saveImage()** : when called it will save the image and returns the base 64 encoded string on onSaveEvent() callback

+ **resetImage()** : when called it will clear the image on the canvas

### Callback Props
+ **onSaveEvent** : Triggered when saveImage() is called, which return Base64 Encoded String and image file path.

+ **onDragEvent** : Triggered when user marks his signature on the canvas. This will not be called when the user does not perform any action on canvas.


### Example

```javascript
/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 */

var React = require('react');
var ReactNative = require('react-native');

var {Component} = React;

var {
    AppRegistry,
    StyleSheet,
    Text,
    View, TouchableHighlight
} = ReactNative;

import SignatureCapture from 'react-native-signature-capture';

class RNSignatureExample extends Component {
    render() {
        return (
            <View style={{ flex: 1, flexDirection: "column" }}>
                <Text style={{alignItems:"center",justifyContent:"center"}}>Signature Capture Extended </Text>
                <SignatureCapture
                    style={[{flex:1},styles.signature]}
                    ref="sign"
                    onSaveEvent={this._onSaveEvent}
                    onDragEvent={this._onDragEvent}
                    saveImageFileInExtStorage={false}
                    showNativeButtons={false}
                    showTitleLabel={false}
                    viewMode={"portrait"}/>

                <View style={{ flex: 1, flexDirection: "row" }}>
                    <TouchableHighlight style={styles.buttonStyle}
                        onPress={() => { this.saveSign() } } >
                        <Text>Save</Text>
                    </TouchableHighlight>

                    <TouchableHighlight style={styles.buttonStyle}
                        onPress={() => { this.resetSign() } } >
                        <Text>Reset</Text>
                    </TouchableHighlight>

                </View>

            </View>
        );
    }

    saveSign() {
        this.refs["sign"].saveImage();
    }

    resetSign() {
        this.refs["sign"].resetImage();
    }

    _onSaveEvent(result) {
        //result.encoded - for the base64 encoded png
        //result.pathName - for the file path name
        console.log(result);
    }
    _onDragEvent() {
         // This callback will be called when the user enters signature
        console.log("dragged");
    }
}

const styles = StyleSheet.create({
    signature: {
        flex: 1,
        borderColor: '#000033',
        borderWidth: 1,
    },
    buttonStyle: {
        flex: 1, justifyContent: "center", alignItems: "center", height: 50,
        backgroundColor: "#eeeeee",
        margin: 10
    }
});

AppRegistry.registerComponent('RNSignatureExample', () => RNSignatureExample);
```

-------------


Demo:

1. 

```javascript
<SignatureCapture
            style={{ flex: 1, width: '100%' }}
            onDragEvent={this._onDragEvent.bind(this)}
            onSaveEvent={this._onSaveEvent.bind(this)}
            minStrokeWidth={1}
            strokeColor="red" // Supported formats are: #RRGGBB #AARRGGBB 'red', 'blue', 'green', 'black', 'white', 'gray', 'cyan', 'magenta', 'yellow', 'lightgray', 'darkgray' 
            backgroundColor="transparent"  // Supported formats are: #RRGGBB #AARRGGBB 'red', 'blue', 'green', 'black', 'white', 'gray', 'cyan', 'magenta', 'yellow', 'lightgray', 'darkgray' 
          />
```

<img src="https://github.com/john1jan/react-native-signature-capture/blob/master/demo/Screenshot_1585649558.png" height=500/>



2.

```javascript
          <SignatureCapture
            style={{ flex: 1, width: '100%' }}
            onDragEvent={this._onDragEvent.bind(this)}
            onSaveEvent={this._onSaveEvent.bind(this)}
            minStrokeWidth={1}
            strokeColor="yellow" 
            backgroundColor="black"  
          />
```

<img src="https://github.com/john1jan/react-native-signature-capture/blob/master/demo/Screenshot_1585649598.png" height=500/>



```javascript
          <SignatureCapture
            style={{ flex: 1, width: '100%' }}
            onDragEvent={this._onDragEvent.bind(this)}
            onSaveEvent={this._onSaveEvent.bind(this)}
            minStrokeWidth={50}
            strokeColor="black"
            backgroundColor="magenta" 
          />
```

<img src="https://github.com/john1jan/react-native-signature-capture/blob/master/demo/Screenshot_1585649693.png" height=500/>

Please checkout the example folder (iOS/Android):
https://github.com/john1jan/react-native-signature-capture/tree/master/Example

Library used:

https://github.com/jharwig/PPSSignatureView

https://github.com/gcacace/android-signaturepad


