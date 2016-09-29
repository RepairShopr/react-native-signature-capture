/**
 * Created by dilip on 29/09/16.
 */

'use strict';

var ReactNative = require('react-native');
var React = require('react');
var {
  PropTypes
} = React;
var {
  requireNativeComponent,
  View,
  UIManager,
  DeviceEventEmitter
} = ReactNative;

class SignatureCapture extends React.Component {

  constructor() {
    super();
    this.onChange = this.onChange.bind(this);
  }

  onChange(event) {

    if(event.nativeEvent.pathName){

      if (!this.props.onSaveEvent) {
        return;
      }
      this.props.onSaveEvent({
        pathName: event.nativeEvent.pathName,
        encoded: event.nativeEvent.encoded,
      });
    }

    if(event.nativeEvent.dragged){
      if (!this.props.onDragEvent) {
        return;
      }
      this.props.onDragEvent({
        dragged: event.nativeEvent.dragged
      });
    }
  }

  componentDidMount() {
    this.subscription = DeviceEventEmitter.addListener(
      'onSaveEvent',
      this.props.onSaveEvent
    );
  }

  componentWillUnmount() {
    if (this.subscription) {
      this.subscription.remove()
      this.subscription = null;
    }
  }

  render() {
    return (
      <RSSignatureView {...this.props} style={{ flex: 1 }} onChange={this.onChange} />
    );
  }

  saveImage() {
    UIManager.dispatchViewManagerCommand(
      ReactNative.findNodeHandle(this),
      UIManager.RSSignatureView.Commands.saveImage,
      [],
    );
  }

  resetImage() {
    UIManager.dispatchViewManagerCommand(
      ReactNative.findNodeHandle(this),
      UIManager.RSSignatureView.Commands.resetImage,
      [],
    );
  }
}

SignatureCapture.propTypes = {
  ...View.propTypes,
  rotateClockwise: PropTypes.bool,
  square: PropTypes.bool,
  saveImageFileInExtStorage: PropTypes.bool,
  viewMode: PropTypes.string,
  showNativeButtons: PropTypes.bool,
  maxSize:PropTypes.number,
  saveFilePath: PropTypes.string,
  fileName: PropTypes.string
};

var RSSignatureView = requireNativeComponent('RSSignatureView', SignatureCapture, {
  nativeOnly: { onChange: true }
});

module.exports = SignatureCapture;
