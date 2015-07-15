#import "RSSignatureView.h"
#import "RCTConvert.h"
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "PPSSignatureView.h"
#import "RSSignatureViewManager.h"

#define DEGREES_TO_RADIANS(x) (M_PI * (x) / 180.0)

@implementation RSSignatureView {
	CAShapeLayer *_border;
	BOOL _loaded;
	EAGLContext *_context;
	UILabel *titleLabel;
}

@synthesize sign;
@synthesize manager;

- (instancetype)init
{
	if ((self = [super init])) {
		_border = [CAShapeLayer layer];
		_border.strokeColor = [UIColor blackColor].CGColor;
		_border.fillColor = nil;
		_border.lineDashPattern = @[@4, @2];
		
		[self.layer addSublayer:_border];
	}
	
	return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	if (!_loaded) {
		_context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
		
		CGSize screen = self.bounds.size;
		
		self.sign = [[PPSSignatureView alloc]
																initWithFrame: CGRectMake(0, 0, screen.width, screen.height)
																context: _context];
		
		[self addSubview:sign];
		titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, sign.bounds.size.height - 80, 24)];
		[titleLabel setCenter:CGPointMake(40, sign.bounds.size.height/2)];
		[titleLabel setTransform:CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(90))];
		[titleLabel setText:@"x_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _"];
		[titleLabel setLineBreakMode:NSLineBreakByClipping];
		[titleLabel setTextAlignment: NSTextAlignmentLeft];
		[titleLabel setTextColor:[UIColor colorWithRed:200/255.f green:200/255.f blue:200/255.f alpha:1.f]];
		//[titleLabel setBackgroundColor:[UIColor greenColor]];
		[sign addSubview:titleLabel];

		
		//Save button
		UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[saveButton setTransform:CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(90))];
		[saveButton setLineBreakMode:NSLineBreakByClipping];
		[saveButton addTarget:self action:@selector(onSaveButtonPressed)
		 forControlEvents:UIControlEventTouchUpInside];
		[saveButton setTitle:@"Save" forState:UIControlStateNormal];
		
		CGSize buttonSize = CGSizeMake(55, 80.0); //Width/Height is swapped
		
		saveButton.frame = CGRectMake(sign.bounds.size.width - buttonSize.width, sign.bounds.size.height - buttonSize.height, buttonSize.width, buttonSize.height);
		[saveButton setBackgroundColor:[UIColor colorWithRed:250/255.f green:250/255.f blue:250/255.f alpha:1.f]];
		[sign addSubview:saveButton];

		//Clear button
		UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[clearButton setTransform:CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(90))];
		[clearButton setLineBreakMode:NSLineBreakByClipping];
		[clearButton addTarget:self action:@selector(onClearButtonPressed)
				 forControlEvents:UIControlEventTouchUpInside];
		[clearButton setTitle:@"Reset" forState:UIControlStateNormal];
		
		clearButton.frame = CGRectMake(sign.bounds.size.width - buttonSize.width, 0, buttonSize.width, buttonSize.height);
		[clearButton setBackgroundColor:[UIColor colorWithRed:250/255.f green:250/255.f blue:250/255.f alpha:1.f]];
		[sign addSubview:clearButton];
		
	}
	_loaded = true;
	_border.path = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
	_border.frame = self.bounds;
}

-(void) onSaveButtonPressed {
	UIImage *signImage = [self.sign signatureImage];
  NSError *error;
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths firstObject];
	NSString *tempPath = [documentsDirectory stringByAppendingFormat:@"/signature.png"];
	
	//remove if file already exists
	if ([[NSFileManager defaultManager] fileExistsAtPath:tempPath]) {
		[[NSFileManager defaultManager] removeItemAtPath:tempPath error:&error];
		if (error) {
			NSLog(@"Error: %@", error.debugDescription);
		}
	}
	
	// Convert UIImage object into NSData (a wrapper for a stream of bytes) formatted according to PNG spec
	NSData *imageData = UIImagePNGRepresentation(signImage);
	BOOL isSuccess = [imageData writeToFile:tempPath atomically:YES];
	if (isSuccess) {
		NSFileManager *man = [NSFileManager defaultManager];
		NSDictionary *attrs = [man attributesOfItemAtPath:tempPath error: NULL];
		//UInt32 result = [attrs fileSize];
		
		NSString *base64Encoded = [imageData base64EncodedStringWithOptions:0];
		[self.manager saveImage: tempPath withEncoded:base64Encoded];
	}
}

-(void) onClearButtonPressed {
	[self.sign erase];
}

@end
