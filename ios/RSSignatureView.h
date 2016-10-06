#import "PPSSignatureView.h"
#import <UIKit/UIKit.h>
#import "RCTView.h"
#import "RCTBridge.h"

@class RSSignatureViewManager;

@interface RSSignatureView : RCTView
@property (nonatomic, strong) PPSSignatureView *sign;
@property (nonatomic, strong) RSSignatureViewManager *manager;
-(void) onSaveButtonPressed;
-(void) onClearButtonPressed;
-(void) saveImage;
-(void) erase;
@end
