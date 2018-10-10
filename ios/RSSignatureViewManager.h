#import "RSSignatureView.h"
#import <React/RCTViewManager.h>

@interface RSSignatureViewManager : RCTViewManager
@property (nonatomic, strong) RSSignatureView *signView;
-(void) saveImage:(nonnull NSNumber *)reactTag;
-(void) resetImage:(nonnull NSNumber *)reactTag;
-(void) publishSaveImageEvent:(NSString *) aTempPath withEncoded: (NSString *) aEncoded
                  trimmedPath:(NSString *) trimmedPath withTrimmedEncoded: (NSString *) aTrimmedEncoded
                        width:(NSNumber *) trimmedWidth
                       height:(NSNumber *) trimmedHeight;
-(void) publishDraggedEvent;
@end
