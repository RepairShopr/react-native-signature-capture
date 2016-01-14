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
1. rotateClockwise - If you want the signature to generate the captured signature in portait mode set the rotateClockwise property to true

2. square - If you want the signature to reduce in size and in a square image 400x400 set square property to true

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
          rotateClockwise={true}
          square={true}
          onSaveEvent={this._onSaveEvent}/>
    );
  }
});

AppRegistry.registerComponent('NPMTest', () => NPMTest);
```
##How to Setup Android
*Note: I used React Native 0.18.0-rc*

* **Create a project folder**

   `$ react-native init signature`
* **Run the Packager** - create a separate terminal tab and run the packager in the background

    `$ npm start`
* **Try to run the react native app on android** - Make sure that your Android studio can run the react native project

  a. Open Android Studio

  b. Click 'Open Existing Android Studio Project'

  c. Select the android/ folder on the signature/ project folder


  ![android project](https://www.evernote.com/shard/s24/sh/bf2c3fe0-45ed-48d5-8233-2bde0404fd5a/7592e2dff6c91cda/res/a68334d1-b527-451a-92a5-13188a91a768/skitch.png?resizeSmall&width=416)

  d. Run android project (assuming android emulator is already open)

  ![android emulator](https://www.evernote.com/shard/s24/sh/65450054-b625-4ab5-82c7-c018fb666e86/7be48b77ec3209ba/res/ecee7e2a-9fcf-4cc6-b4ab-ff6ba732e58a/skitch.png?resizeSmall&height=360 "android emulator")

* **install the npm**

```
npm install react-native-signature-capture --save
```

* Open `android/settings.gradle`

  ![settings.gradle](https://www.evernote.com/shard/s24/sh/13f5e3d8-4230-45f3-a4c7-934ddeb1df7e/bf0aa53a2a1a0d51/res/bed923df-35e4-4076-9c44-3b097c16209f/skitch.png?resizeSmall&width=280)

* Add reactnativesignaturecapture like below:

```
  include ':reactnativesignaturecapture',':app'
  project(':reactnativesignaturecapture').projectDir = new File(settingsDir, '../node_modules/react-native-signature-capture/android')
```

* Open `android/app/build.gradle`

  ![build.gradle](https://www.evernote.com/shard/s24/sh/c1a3437b-9e9f-472e-a640-13b9194804a9/f5579c89c8856afd/res/a451f235-b901-483d-a759-c739becd5190/skitch.png?resizeSmall&width=280)
```
...
dependencies {
    ...
    compile project(':reactnativesignaturecapture')
}
```

* Open MainActivity.java

  ![MainActivity.java](https://www.evernote.com/shard/s24/sh/c023412e-c79d-46e5-9119-87453180003c/c1ab69a99604fd80/res/7cc76cee-f669-4d06-bed8-9a57e4edc586/skitch.png?resizeSmall&width=280)

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
        new RSSignatureCapturePackage(this), // <------ add here
        new MainReactPackage());
    }
}
```

* Open index.android.js
```
...
import SignatureCapture from 'react-native-signature-capture';
...

class signature extends Component {
  render() {
    return (
      <SignatureCapture onSaveEvent={(data)=>{
        console.log(data);
      }}/>
    );
  }
}
...
```

* Run the Android Studio project

-------------

Library used:

https://github.com/jharwig/PPSSignatureView

https://github.com/gcacace/android-signaturepad
