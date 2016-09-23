var React, { PropTypes, Component } import 'react';
var ReactNative, {
  requireNativeComponent,
  View,
  UIManager,
  DeviceEventEmitter
} import 'react-native';


class SignatureCapture extends Component {

    constructor() {
        super();
        this.onChange = this.onChange.bind(this);
    }

    onChange(event) {

        if(event.nativeEvent.pathName){
            if (this.props.onSaveEvent) {
              this.props.onSaveEvent({
                  pathName: event.nativeEvent.pathName,
                  encoded: event.nativeEvent.encoded,
              });
            }
        }

        if(event.nativeEvent.dragged){
            if (this.props.onDragEvent) {
              this.props.onDragEvent({
                  dragged: event.nativeEvent.dragged
              });
            }
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
            <RSSignatureView {...this.props} onChange={this.onChange} />
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
    maxSize:PropTypes.number
};

var RSSignatureView = requireNativeComponent('RSSignatureView', SignatureCapture, {
    nativeOnly: { onChange: true }
});

export default SignatureCapture;
