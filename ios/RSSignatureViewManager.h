#import "RSSignatureView.h"
#import <React/RCTViewManager.h>

@interface RSSignatureViewManager : RCTViewManager
-(void) saveImage:(nonnull NSNumber *)reactTag;
-(void) resetImage:(nonnull NSNumber *)reactTag;
-(void) publishSaveImageEvent:(NSString *) aTempPath withEncoded: (NSString *) aEncoded;
-(void) publishDraggedEvent;
@end
