import React, {
  Component, PropTypes
} from 'react';

import ReactNative, {
  View, Text, Modal, Platform, Alert
} from 'react-native';

import SignatureCapture from 'react-native-signature-capture';

const toolbarHeight = Platform.select({
  android: 0,
  ios: 22
});

const modalViewStyle = {
  paddingTop: toolbarHeight,
  flex: 1
};

class SignatureView extends Component {

  static propTypes = {
    onSave: PropTypes.func
  }

  constructor(props) {
    super(props);

    this.state = {
      visible: false
    };
  }

  show(display) {
    this.setState({visible: display});
  }

  render() {
    const {visible} = this.state;

    return (
      <Modal transparent={false} visible={visible} onRequestClose={this._onRequreClose.bind(this)}>
        <View style={modalViewStyle}>
          <View style={{padding: 10, flexDirection: 'row'}}>
            <Text onPress={this._onPressClose.bind(this)}>{' x '}</Text>
            <View style={{flex: 1, alignItems: 'center'}}>
              <Text style={{fontSize: 14}}>Please write your signature.</Text>
            </View>
          </View>
          <SignatureCapture
              style={{flex: 1, width: '100%'}}
            onDragEvent={this._onDragEvent.bind(this)}
            onSaveEvent={this._onSaveEvent.bind(this)}
          />
        </View>
      </Modal>
    );
  }

  _onPressClose() {
    this.show(false);
  }

  _onRequreClose() {
    this.show(false);
  }

  _onDragEvent() {
    // This callback will be called when the user enters signature
   console.log("dragged");
  }

  _onSaveEvent(result) {
    //result.encoded - for the base64 encoded png
    //result.pathName - for the file path name
    this.props.onSave && this.props.onSave(result);
  }
}

export default SignatureView;
