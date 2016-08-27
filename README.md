# react-native-signature-capture -

Android support is available:

<img src="http://i.giphy.com/xT0GUKJFFkdDv25FNC.gif" />

iOS:
<img src="http://i.giphy.com/3oEduIyWb48Ws3bSuc.gif" />

React Native library for capturing signature

User would sign on the app and when you press the save button it returns the base64 encoded png

## Usage

First you need to install react-native-signature-capture:

```javascript
npm install react-native-signature-capture --save
```

In XCode, in the project navigator, right click Libraries ➜ Add Files to [your project's name] Go to node_modules ➜ react-native-signature-capture and add the .xcodeproj file

In XCode, in the project navigator, select your project. Add the lib*.a from the signature-capture project to your project's Build Phases ➜ Link Binary With Libraries Click .xcodeproj file you added before in the project navigator and go the Build Settings tab. Make sure 'All' is toggled on (instead of 'Basic'). Look for Header Search Paths and make sure it contains both $(SRCROOT)/../react-native/React and $(SRCROOT)/../../React - mark both as recursive.

Run your project (Cmd+R)

## Properties

**saveImageFileInExtStorage** : Make this props true, if you want to save the image file in external storage. Default is false. Warning: Image file will be visible in gallery or any other image browsing app

**showNativeButtons** : If this props is made to true, it will display the native buttons "Save" and "Reset".

**viewMode** : "portrait" or "landscape" change the screen orientation based on boolean value

**maxSize**  : sets the max size of the image maintains aspect ratio, default is 500

## Methods

**saveImage()** : when called it will save the image and returns the base 64 encoded string on onSaveEvent() callback
**resetSign()** : when called it will clear the image on the canvas

## Callback Props
**onSaveEvent** : Triggered when saveImage() is called, which return Base64 Encoded String and image file path.
**onDragEvent** : Triggered when user marks his signature on the canvas. This will not be called when the user does not perform any action on canvas.



## Examples

```javascript
'use strict';

var React = require('react-native');
var SignatureCapture = require('react-native-signature-capture');
var {
  AppRegistry,
} = React;

var NPMTest = React.createClass({
  _onSaveEvent: function(result) {
    //result.encoded - for the base64 encoded png
    //result.pathName - for the file path name
    console.log(result);
  },

  render: function() {
    return (
                  <SignatureCapture
                    ref="sign"
                    onSaveEvent={this._onSaveEvent}
                    onDragEvent={this._onDragEvent}
                    saveImageFileInExtStorage={false}
                    showNativeButtons={false}
    );
  }
});

AppRegistry.registerComponent('NPMTest', () => NPMTest);
```
##How to Setup Android

* **Create a project folder**

   `$ react-native init signature`
* **Run the Packager** - create a separate terminal tab and run the packager in the background

    `$ npm start`
* **Try to run the react native app on android** - Make sure that your Android studio can run the react native project

  a. Open Android Studio

  b. Click 'Open Existing Android Studio Project'

  c. Select the android/ folder on the signature/ project folder

  d. Run android project (assuming android emulator is already open)

* **install the npm**

```
npm install react-native-signature-capture --save
```

* Open `android/settings.gradle`

* Add reactnativesignaturecapture like below:

```
  include ':reactnativesignaturecapture',':app'
  project(':reactnativesignaturecapture').projectDir = new File(settingsDir, '../node_modules/react-native-signature-capture/android')
```

* Open `android/app/build.gradle`

```
...
dependencies {
    ...
    compile project(':reactnativesignaturecapture')
}
```

* Open MainApplication.java

```
import com.rssignaturecapture.RSSignatureCapturePackage;  // <--- import

public class MainActivity extends ReactActivity {
  ......

  /**
   * A list of packages used by the app. If the app uses additional views
   * or modules besides the default ones, add more packages here.
   */
    @Override
    protected List<ReactPackage> getPackages() {
      return Arrays.<ReactPackage>asList(
        new RSSignatureCapturePackage(), // <------ add here
        new MainReactPackage());
    }
}
```

* Open index.android.js
```
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


* Run the Android Studio project

-------------

Library used:

https://github.com/jharwig/PPSSignatureView

https://github.com/gcacace/android-signaturepad
