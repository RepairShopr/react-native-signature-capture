#import "UIImage+Trim.h"
#import "PPSSignatureView.h"

#define             MIN_WIDTH 300
#define             MIN_HEIGHT 150

@implementation UIImage (Trim)

- (UIEdgeInsets)transparencyInsetsRequiringFullOpacity:(BOOL)fullyOpaque
{
	// Draw our image on that context
	NSInteger width  = (NSInteger)CGImageGetWidth([self CGImage]);
	NSInteger height = (NSInteger)CGImageGetHeight([self CGImage]);
	NSInteger bytesPerRow = width * (NSInteger)sizeof(uint8_t);

	// Allocate array to hold alpha channel
	uint8_t * bitmapData = calloc((size_t)(width * height), sizeof(uint8_t));

	// Create alpha-only bitmap context
	CGContextRef contextRef = CGBitmapContextCreate(bitmapData, (NSUInteger)width, (NSUInteger)height, 8, (NSUInteger)bytesPerRow, NULL, kCGImageAlphaOnly);

	CGImageRef cgImage = self.CGImage;
	CGRect rect = CGRectMake(0, 0, width, height);
	CGContextDrawImage(contextRef, rect, cgImage);

	// Sum all non-transparent pixels in every row and every column
	uint16_t * rowSum = calloc((size_t)height, sizeof(uint16_t));
	uint16_t * colSum = calloc((size_t)width,  sizeof(uint16_t));

	// Enumerate through all pixels
	for (NSInteger row = 0; row < height; row++) {

		for (NSInteger col = 0; col < width; col++) {

			if (fullyOpaque) {

				// Found non-transparent pixel
				if (bitmapData[row*bytesPerRow + col] == UINT8_MAX) {

					rowSum[row]++;
					colSum[col]++;

				}

			} else {

				// Found non-transparent pixel
				if (bitmapData[row*bytesPerRow + col]) {

					rowSum[row]++;
					colSum[col]++;

				}

			}

		}

	}

	// Initialize crop insets and enumerate cols/rows arrays until we find non-empty columns or row
	UIEdgeInsets crop = UIEdgeInsetsZero;

    // Top
	for (NSInteger i = 0; i < height; i++) {

		if (rowSum[i] > 0) {

			crop.top = i;
            break;

		}

	}

    // Bottom
	for (NSInteger i = height - 1; i >= 0; i--) {

		if (rowSum[i] > 0) {
			crop.bottom = MAX(0, height - i - 1);
            break;
		}

	}

    // Left
	for (NSInteger i = 0; i < width; i++) {

		if (colSum[i] > 0) {
			crop.left = i;
            break;
		}

	}

    // Right
	for (NSInteger i = width - 1; i >= 0; i--) {

		if (colSum[i] > 0) {

			crop.right = MAX(0, width - i - 1);
            break;

		}
	}

	free(bitmapData);
	free(colSum);
	free(rowSum);

    CGContextRelease(contextRef);

	return crop;
}

- (UIImage *)imageByTrimmingTransparentPixels
{
	return [self imageByTrimmingTransparentPixelsRequiringFullOpacity:NO];
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToFillSize:(CGSize)size
{
    CGFloat scale = MAX(size.width/image.size.width, size.height/image.size.height);
    CGFloat width = image.size.width * scale;
    CGFloat height = image.size.height * scale;
    CGRect imageRect = CGRectMake((size.width - width)/2.0f,
                                  (size.height - height)/2.0f,
                                  width,
                                  height);

    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [image drawInRect:imageRect];
    return image;
}

- (UIImage *)createNewImageFrom:(UIImage *)image withPoint:(CGPoint)point {

    NSInteger width  = (NSInteger)CGImageGetWidth(image.CGImage);
    NSInteger height = (NSInteger)CGImageGetHeight(image.CGImage);

    CGRect rect = CGRectMake(0.0f, 0.0f, MIN_WIDTH, MIN_HEIGHT);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
    CGContextFillRect(context, rect);

    [image drawInRect:CGRectMake(point.x, point.y, width, height)];

    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return img;
}

- (UIImage *)imageByTrimmingTransparentPixelsRequiringFullOpacity:(BOOL)fullyOpaque
{
	if (self.size.height < 2 || self.size.width < 2) {

		return self;

	}

	CGRect rect = CGRectMake(0, 0, self.size.width * self.scale, self.size.height * self.scale);
	UIEdgeInsets crop = [self transparencyInsetsRequiringFullOpacity:fullyOpaque];

    UIImage *img = self;

	if (crop.top == 0 && crop.bottom == 0 && crop.left == 0 && crop.right == 0) {

		// No cropping needed

	} else {

		// Calculate new crop bounds
		rect.origin.x += crop.left;
		rect.origin.y += crop.top;
		rect.size.width -= crop.left + crop.right;
		rect.size.height -= crop.top + crop.bottom;

		// Crop it
		CGImageRef newImage = CGImageCreateWithImageInRect([self CGImage], rect);

		// Convert back to UIImage
        img = [UIImage imageWithCGImage:newImage scale:self.scale orientation:self.imageOrientation];

        if ((rect.size.width < MIN_WIDTH) && (rect.size.height < MIN_HEIGHT)) {
            CGPoint point = CGPointMake((MIN_WIDTH - rect.size.width) / 2, (MIN_HEIGHT - rect.size.height) / 2);
            return [self createNewImageFrom:img withPoint:point];
        }

        CGImageRelease(newImage);
	}

    return img;
}

@end
