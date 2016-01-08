# react-native-signature-capture -

##### iOS ONLY FOR THE MOMENT - see https://github.com/RepairShopr/react-native-signature-capture/issues/3 #####

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

If you want the signature to generate the captured signature in portait mode set the rotateClockwise property to true
If you want the signature to reduce in size and in a square image 400x400 set suare property to true

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

Library used:
https://github.com/jharwig/PPSSignatureView
