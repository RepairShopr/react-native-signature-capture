#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

@class RSSignatureViewManager;

@interface PPSSignatureView : GLKView

@property (assign, nonatomic) UIColor *strokeColor;
@property (assign, nonatomic) BOOL hasSignature;
@property (nonatomic, strong) RSSignatureViewManager *manager;

- (void)erase;

- (NSArray *) signatureImage;
- (NSArray *) signatureImage: (BOOL) rotatedImage;
- (NSArray *) signatureImage: (BOOL) rotatedImage withSquare:(BOOL)square;

@end
