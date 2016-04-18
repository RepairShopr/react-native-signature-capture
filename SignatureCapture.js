
'use strict';

var React = require('react-native');
var {
    PropTypes,
    requireNativeComponent,
    View,
} = React;

var UIManager = require('UIManager');


class SignatureCapture extends React.Component {

    constructor() {
        super();
        this.onChange = this.onChange.bind(this);
    }

    onChange(event) {
        console.log("Signature  ON Change Event");
        
        
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

    render() {
        return (
            <RSSignatureView {...this.props} style={{ flex: 1 }} onChange={this.onChange} />
        );
    }

    saveImage() {
        UIManager.dispatchViewManagerCommand(
            React.findNodeHandle(this),
            UIManager.RSSignatureView.Commands.saveImage,
            [],
        );
    }

    resetImage() {
        UIManager.dispatchViewManagerCommand(
            React.findNodeHandle(this),
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

module.exports = SignatureCapture;
