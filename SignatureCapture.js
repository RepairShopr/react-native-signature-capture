'use strict';

var React = require('react-native');

var {
  requireNativeComponent,
  DeviceEventEmitter,
  View
} = React;

var Component = requireNativeComponent('RSSSignatureView', null);

var styles = {
  signatureBox: {
    flex: 1
  },
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'stretch',
    backgroundColor: '#F5FCFF',
  }
};

var subscription;

var SignatureCapture = React.createClass({
  propTypes: {
    pitchEnabled: React.PropTypes.bool
  },

  componentDidMount: function() {
    subscription = DeviceEventEmitter.addListener(
        'onSaveEvent',
        this.props.onSaveEvent
    );
  },

  componentWillUnmount: function() {
    subscription.remove();
  },

  render: function() {
    return (
      <View style={styles.container}>
        <Component style={styles.signatureBox} />
      </View>
    )
  }
});

module.exports = SignatureCapture;