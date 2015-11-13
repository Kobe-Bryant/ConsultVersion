//
//  MyViewBarcode.m
//  OnBarcodeIPhoneClient
//
//  Created by Wang Qi on 12/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MyViewBarcode.h"
//#import "OBGlobal.h"
//#import "OBQRCode.h"

#import "QRCodeGenerator.h"

@implementation MyViewBarcode
@synthesize titleString;
@synthesize url;

#define USER_DEF_LEFT_MARGIN	0.0f
#define USER_DEF_RIGHT_MARGIN	0.0f
#define USER_DEF_TOP_MARGIN		0.0f
#define USER_DEF_BOTTOM_MARGIN	0.0f

#define USER_DEF_BAR_WIDTH			2.0f
#define USER_DEF_BAR_HEIGHT			90.0f
#define USER_DEF_BARCODE_WIDTH		0.0f
#define USER_DEF_BARCODE_HEIGHT		0.0f

#define USER_DEF_ROTATION		(0)

- (id)initWithFrame:(CGRect)frame title:(NSString*)title url:(NSString*)urlString{
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		self.backgroundColor = [UIColor whiteColor];
		self.titleString = title;
		self.url = urlString;
    }
    return self;
}

- (void)drawRect: (CGRect)rect {
    // Drawing code
	[self generateQRCodeWithView:self];
}

- (void) generateQRCodeWithView: (UIView *) view 
{
    
    UIImageView *codeImage = [[UIImageView alloc]initWithFrame:CGRectMake(40, 0, 320 - 40*2, 320 - 40*2)];
    codeImage.image = [QRCodeGenerator qrImageForString:self.url imageSize:codeImage.bounds.size.width];
    
    [self addSubview:codeImage];
    [codeImage release];
    
//	NSAutoreleasePool *pPool = [[NSAutoreleasePool alloc] init];
//	
//	OBQRCode *pQRCode = [OBQRCode new];
//	[pQRCode setNDataMode: OB_QRCODE_Auto];
//	[pQRCode setBProcessTilde: (FALSE)];
//	
//	NSLog(titleString);
//	[pQRCode setPData: url];
//	//[pQRCode setPData: [[NSString alloc] initWithString: (@"1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!@#$%^&*()_+-={}[]<>?,./")]];
//	[pQRCode setFX: USER_DEF_BAR_WIDTH];
//	
//	[pQRCode setNVersion: (OB_QRCODE_V1)];
//	[pQRCode setNECL: (OB_QRCODE_L)];
//	
//	[pQRCode setBStructuredAppend: (FALSE)];
//	[pQRCode setNSymbolCount: (10)];
//	[pQRCode setNSymbolIndex: (0)];
//	[pQRCode setFX:6.0f];
//	
//	[pQRCode setFLeftMargin: USER_DEF_LEFT_MARGIN];
//	[pQRCode setFRightMargin: USER_DEF_RIGHT_MARGIN];
//	[pQRCode setFTopMargin: USER_DEF_TOP_MARGIN];
//	[pQRCode setFBottomMargin: USER_DEF_BOTTOM_MARGIN];
//	[pQRCode setNRotate: (USER_DEF_ROTATION)];
//	CGRect printArea = CGRectMake(0,0, 320, 260);
//	[pQRCode drawWithView: (view) rect: &printArea alignHCenter:YES];
	
	UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
	UIImage *img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"二维码背景" ofType:@"png"]];
	int width = img.size.width;
	int height = img.size.height;
	[backImageView setFrame:CGRectMake(0, 250, width, height)];
	backImageView.image = img;
	[self addSubview:backImageView];
	[img release];
	[backImageView release];
	
		
	CGSize labelSize = [titleString sizeWithFont:[UIFont systemFontOfSize:18]							
								 constrainedToSize:CGSizeMake(245, 34) 							
									 lineBreakMode:UILineBreakModeCharacterWrap];
	UILabel *title = [[UILabel alloc] initWithFrame:
					  CGRectMake((self.frame.size.width-labelSize.width)/2,270, labelSize.width, labelSize.height)];
	title.text = titleString;
	title.backgroundColor = [UIColor clearColor];
	title.font = [UIFont systemFontOfSize:18];
	title.numberOfLines = 0;     // 不可少Label属性之一
	title.lineBreakMode = UILineBreakModeCharacterWrap;    // 不可少Label属性之二
	title.textColor = [UIColor blackColor];			
	[self addSubview:title];
	[title release];
	
	CGSize urlLabelSize = [url sizeWithFont:[UIFont systemFontOfSize:14]							
							   constrainedToSize:CGSizeMake(220, 68)
								   lineBreakMode:UILineBreakModeCharacterWrap];
	UILabel *urlLable = [[UILabel alloc] initWithFrame:CGRectMake(50,305, urlLabelSize.width, urlLabelSize.height)];
	urlLable.text = url;
	urlLable.backgroundColor = [UIColor clearColor];
	urlLable.font = [UIFont systemFontOfSize:14];
	urlLable.numberOfLines = 0;     // 不可少Label属性之一
	urlLable.lineBreakMode = UILineBreakModeCharacterWrap;    // 不可少Label属性之二
	urlLable.textColor = [UIColor blackColor];			
	[self addSubview:urlLable];
	[urlLable release];
//	
//	[pQRCode release];
//	
//	[pPool release];
}

-(void) dealloc{
	[super dealloc];
	[titleString release];
	[url release];
}

@end