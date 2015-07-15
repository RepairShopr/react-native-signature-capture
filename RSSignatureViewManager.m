#import "RSSignatureViewManager.h"
#import "RCTBridgeModule.h"
#import "RCTBridge.h"
#import "RCTEventDispatcher.h"

@implementation RSSignatureViewManager {
}

@synthesize bridge = _bridge;
@synthesize signView;

RCT_EXPORT_MODULE()

-(UIView *) view
{
	self.signView = [[RSSignatureView alloc] init];
	self.signView.manager = self;
	return signView;
}

- (dispatch_queue_t)methodQueue
{
	return dispatch_get_main_queue();
}

-(void) saveImage:(NSString *) aTempPath withEncoded: (NSString *) aEncoded {
	[self.bridge.eventDispatcher
	 sendDeviceEventWithName:@"onSaveEvent"
	 body:@{
			@"pathName": aTempPath,
			@"encoded": aEncoded
			}];
}

@end
