#import "RSSignatureView.h"
#import <React/RCTViewManager.h>

@interface RSSignatureViewManager : RCTViewManager
@property (nonatomic, strong) RSSignatureView *signView;
-(void) saveImage:(nonnull NSNumber *)reactTag;
-(void) resetImage:(nonnull NSNumber *)reactTag;
-(void) publishSaveImageEvent:(NSString *) aTempPath withEncoded: (NSString *) aEncoded;
-(void) publishDraggedEvent;
@end
