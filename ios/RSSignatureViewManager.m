#import "RSSignatureViewManager.h"
#import "RCTBridgeModule.h"
#import "RCTBridge.h"
#import "RCTEventDispatcher.h"

@implementation RSSignatureViewManager

@synthesize bridge = _bridge;
@synthesize signView;

RCT_EXPORT_MODULE()

RCT_EXPORT_VIEW_PROPERTY(rotateClockwise, BOOL)
RCT_EXPORT_VIEW_PROPERTY(square, BOOL)

-(dispatch_queue_t) methodQueue
{
	return dispatch_get_main_queue();
}

-(UIView *) view
{
	self.signView = [[RSSignatureView alloc] init];
	self.signView.manager = self;
	return signView;
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
