
#import <UIKit/UIKit.h>

@interface UIImage (Trim)

- (UIEdgeInsets)transparencyInsetsRequiringFullOpacity:(BOOL)fullyOpaque;
- (UIImage *)imageByTrimmingTransparentPixels;
- (UIImage *)imageByTrimmingTransparentPixelsRequiringFullOpacity:(BOOL)fullyOpaque;

@end
