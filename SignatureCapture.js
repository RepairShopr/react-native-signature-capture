'use strict';

import React, { PureComponent } from 'react';
import { requireNativeComponent, View, UIManager, DeviceEventEmitter, findNodeHandle } from 'react-native';
import PropTypes from 'prop-types';

export default class SignatureCapture extends PureComponent {
    subscriptions = [];

    static propTypes = {
        ...View.propTypes,
        rotateClockwise: PropTypes.bool,
        square: PropTypes.bool,
        saveImageFileInExtStorage: PropTypes.bool,
        viewMode: PropTypes.string,
        showBorder: PropTypes.bool,
        showNativeButtons: PropTypes.bool,
        showTitleLabel: PropTypes.bool,
        maxSize: PropTypes.number,
        minStrokeWidth: PropTypes.number,
        maxStrokeWidth: PropTypes.number,
        strokeColor: PropTypes.string,
        backgroundColor: PropTypes.string
    };

    onChange = event => {
        if (event.nativeEvent.pathName) {
            if (!this.props.onSaveEvent) {
                return;
            }
            this.props.onSaveEvent({
                pathName: event.nativeEvent.pathName,
                encoded: event.nativeEvent.encoded
            });
        }

        if (event.nativeEvent.dragged) {
            if (!this.props.onDragEvent) {
                return;
            }
            this.props.onDragEvent({
                dragged: event.nativeEvent.dragged
            });
        }
    };

    componentDidMount() {
        if (this.props.onSaveEvent) {
            const sub = DeviceEventEmitter.addListener('onSaveEvent', this.props.onSaveEvent);
            this.subscriptions.push(sub);
        }

        if (this.props.onDragEvent) {
            const sub = DeviceEventEmitter.addListener('onDragEvent', this.props.onDragEvent);
            this.subscriptions.push(sub);
        }
    }

    componentWillUnmount() {
        this.subscriptions.forEach(sub => sub.remove());
        this.subscriptions = [];
    }

    RSSignatureView = requireNativeComponent('RSSignatureView', SignatureCapture, {
        nativeOnly: { onChange: true }
    });

    render() {
        return <this.RSSignatureView {...this.props} onChange={this.onChange} />;
    }

    saveImage() {
        UIManager.dispatchViewManagerCommand(findNodeHandle(this), UIManager.RSSignatureView.Commands.saveImage, []);
    }

    resetImage() {
        UIManager.dispatchViewManagerCommand(findNodeHandle(this), UIManager.RSSignatureView.Commands.resetImage, []);
    }
}
