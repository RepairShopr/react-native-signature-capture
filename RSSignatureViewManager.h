#import "RSSignatureView.h"
#import "RCTViewManager.h"

@interface RSSignatureViewManager : RCTViewManager
@property (nonatomic, strong) RSSignatureView *signView;
-(void) saveImage:(NSString *) aTempPath withEncoded: (NSString *) aEncoded;
@end
