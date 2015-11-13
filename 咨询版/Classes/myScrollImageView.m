//
//  myScrollImageView.m
//  imageDemo
//
//  Created by 掌商 on 11-8-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "myScrollImageView.h"
//#define PIC_NAME @"%d.jpg"

@implementation myScrollImageView
- (id)initWithFrame:(CGRect)frame imageName:(NSString*)name totalPic:(int)total{
	pic_name = name;
	pic_total = total;
    if ((self = [super initWithFrame:frame])) {
		self.userInteractionEnabled = YES;
		xPerPic = self.frame.size.width/total;
		my_x = 0;
		picNum = 0;
		turnLeft = YES;
		NSString *picNameTmp = [NSString stringWithFormat:name,picNum+1];
		UIImage *img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:picNameTmp ofType:nil]];
		self.image = img;
		[img release];
    }
    return self;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	CGPoint ptCurr=[[touches anyObject] locationInView:self];
	tmp_x = ptCurr.x;
}

/*- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	CGPoint ptCurr=[[touches anyObject] locationInView:self];
	my_x = ptCurr.x;
}*/

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	CGPoint ptCurr=[[touches anyObject] locationInView:self];
	CGPoint ptpre=[[touches anyObject] previousLocationInView:self];
	if((ptCurr.x - ptpre.x)>0.0f && turnLeft)
	{
		tmp_x = ptpre.x;
		turnLeft = NO;
	}
	if ((ptCurr.x - ptpre.x)<0.0f && !turnLeft) {
		tmp_x = ptpre.x;
		turnLeft = YES;
	}
	float myx = ptCurr.x-tmp_x;	
	int picNumTmp = myx/xPerPic;
	if (picNumTmp != 0) {
		tmp_x = ptpre.x;
	}
	picNum +=picNumTmp;
	picNum = picNum % pic_total;
	if (picNum<0) {
		picNum = pic_total + picNum;
	}
	NSString *picNameTmp = [NSString stringWithFormat:pic_name,picNum+1];
	UIImage *img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:picNameTmp ofType:nil]];
	self.image = img;
	[img release];
}
@end
