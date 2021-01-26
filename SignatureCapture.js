
'use strict';

var ReactNative = require('react-native');
var React = require('react');
var PropTypes = require('prop-types');
var {
    requireNativeComponent,
    View,
    UIManager,
    DeviceEventEmitter
} = ReactNative;

class SignatureCapture extends React.Component {

    constructor() {
        super();
        this.onSave = this.onSave.bind(this);
        this.onDrag = this.onDrag.bind(this);
    }

    onSave(event) {
        if (!this.props.onSaveEvent) {
            return;
        }
        this.props.onSaveEvent({
            pathName: event.pathName,
            encoded: event.nativeEvent.encoded,
        });
    }

    onDrag(event) {
        if (!this.props.onDragEvent) {
            return;
        }
        this.props.onDragEvent({
            dragged: event.dragged
        });
    }

    render() {
        return (
            <RSSignatureView {...this.props} onSave={this.onSave} onDrag={this.onDrag} />
        );
    }

    saveImage() {
        UIManager.dispatchViewManagerCommand(
            ReactNative.findNodeHandle(this),
            UIManager.getViewManagerConfig('RSSignatureView').Commands.saveImage,
            [],
        );
    }

    resetImage() {
        UIManager.dispatchViewManagerCommand(
            ReactNative.findNodeHandle(this),
            UIManager.getViewManagerConfig('RSSignatureView').Commands.resetImage,
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
    showBorder: PropTypes.bool,
    showNativeButtons: PropTypes.bool,
    showTitleLabel: PropTypes.bool,
    maxSize:PropTypes.number,
    onSaveEvent: PropTypes.func,
    onDragEvent: PropTypes.func,
    minStrokeWidth: PropTypes.number,
    maxStrokeWidth: PropTypes.number,
    strokeColor: PropTypes.string,
    backgroundColor: PropTypes.string
};

var RSSignatureView = requireNativeComponent('RSSignatureView', SignatureCapture, {
    nativeOnly: { onSave: true, onDrag: true }
});

module.exports = SignatureCapture;
