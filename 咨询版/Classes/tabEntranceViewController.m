//
//  tabEntranceViewController.m
//  AppStrom
//
//  Created by 掌商 on 11-8-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "tabEntranceViewController.h"
#import "showRotationPicViewController.h"
#import "ShowSolidBrowserViewController.h"
#import "hotspotViewController.h"
#import "moreViewController.h"
#import "beautyPicViewController.h"
#import "wallPaperViewController.h"
#import "videoViewController.h"
#import "promotionsViewController.h"
#import "companyNewsViewController.h"
#import "addServiceViewController.h"
#import "addCommunityViewController.h"
#import "DBOperate.h"
#import "Common.h"
#import "browserViewController.h"
#import "alertView.h"
#import "ModuleObject.h"
#import "HotspotMainViewController.h"

@implementation tabEntranceViewController
@synthesize contactSegment;
@synthesize serviceBto1;
@synthesize serviceBto2;
@synthesize communityBto1;
@synthesize communityBto2;
@synthesize hotspotSegment;
@synthesize moreBto;
@synthesize chooseVC;
@synthesize productSegment;
@synthesize service;
@synthesize community;
@synthesize ButtonItem;
@synthesize beautyPic;
@synthesize backview;
@synthesize hotspotView;
@synthesize moreView;
@synthesize promotionViewController;
@synthesize companyNewsView;
@synthesize hotspotMain;
@synthesize logoView;

- (id)init
{
	self = [super init];//调用父类初始化函数
	if (self != nil) 
	{	
		//self.title = zeroTitle;
		UIImageView *bv = [[UIImageView alloc]initWithFrame:CGRectZero];
		self.backview = bv;
		[bv release];
		NSLog(@"backview %d",[backview retainCount]);
		UIBarButtonItem * tempButtonItem = [[ UIBarButtonItem alloc] init]; 
		self.ButtonItem = tempButtonItem;
		ModuleObject *mo = [tabArray objectAtIndex:0];
//		tempButtonItem .title = mo.name;
		self.navigationItem.backBarButtonItem = tempButtonItem ; 
		[tempButtonItem release];
		NSMutableArray *controllers = [NSMutableArray array];
		for(int i = 0; i < [tabArray count]; i++){
			ModuleObject *mo = [tabArray objectAtIndex:i];
			NSString *keyName = mo.key;
			NSString *titleName = mo.name;
			if ([keyName isEqualToString : @"hotspot"] && [mo.status isEqualToString:@"1"]) {
				//				hotspotViewController *hotspot = [[hotspotViewController alloc]init];
				//				UIImage *img4 = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:titleName ofType:@"png"]];
				//				self.hotspotView = hotspot;
				//				[hotspot.tabBarItem initWithTitle:titleName image:img4 tag:0];
				//				[img4 release];
				//				[hotspot release];
				//				[controllers addObject:self.hotspotView];
				HotspotMainViewController *hotMain = [[HotspotMainViewController alloc] init];
				UIImage *img4 = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:titleName ofType:@"png"]];
				hotMain.navigationController = self.navigationController;
				self.hotspotMain = hotMain;
				[hotMain.tabBarItem initWithTitle:titleName image:img4 tag:0];
				[img4 release];
				[hotMain release];
				[controllers addObject:self.hotspotMain];
			}else if([keyName isEqualToString : @"product"] && [mo.status isEqualToString:@"1"]){
				UIViewController *product1;
				if ([productShowType isEqualToString:@"1"]) {
					product1 = [[ThreeDimensionalPicViewController alloc]init];
				}else {
				    product1 = [[beautyPicViewController alloc]init];	
				}
				
				UIImage *img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:titleName ofType:@"png"]];
				[product1.tabBarItem initWithTitle:titleName image:img tag:0];
				[img release];
				self.beautyPic = product1;
				[controllers addObject:self.beautyPic];
				[product1 release];
			} else if ([keyName isEqualToString : @"service"] && [mo.status isEqualToString:@"1"]) {
				serviceViewController *service1 = [[serviceViewController alloc]initWithStyle:UITableViewStyleGrouped];
				self.service = service1;
				[service1 release];
				UIImage *img1 = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:titleName ofType:@"png"]];
				[service.tabBarItem initWithTitle:titleName image:img1 tag:0];
				[img1 release];
				[controllers addObject:self.service];
			}else if ([keyName isEqualToString : @"community"] && [mo.status isEqualToString:@"1"]) {
				communityViewController *community1 = [[communityViewController alloc]initWithStyle:UITableViewStyleGrouped];
				self.community = community1;
				[community1 release];
				UIImage *img2 = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:titleName ofType:@"png"]];
				[community.tabBarItem initWithTitle:titleName image:img2 tag:0];
				[img2 release];
				[controllers addObject:self.community];
			}else if ([keyName isEqualToString : @"more"] && [mo.status isEqualToString:@"1"]) {
				moreViewController *more = [[moreViewController alloc]initWithStyle:UITableViewStyleGrouped];
				self.moreView = more;
				UIImage *img3 = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:titleName ofType:@"png"]];
				[more.tabBarItem initWithTitle:titleName image:img3 tag:0];
				[img3 release];
				[more release];
				[controllers addObject:self.moreView];
			}
		}
		self.viewControllers = controllers;
		self.customizableViewControllers = controllers;		
		//[self hideRealTabBar];
		NSMutableArray *productSegMenuArray = [NSMutableArray array];
		//int psbitmap = product_seg_bitmap;
		for (int i = 0; i < [produceModuleArray count]; i++) {
			ModuleObject *mo = [produceModuleArray objectAtIndex:i];
			NSString *segTitle = mo.name;
			if([mo.status isEqualToString:@"1"]){
				[productSegMenuArray addObject:segTitle];
			}
		}
		
		UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(0,0 ,0 ,0)];
		UIImage *logoImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"logo" ofType:@"png"]];
		int imgWidth = logoImage.size.width;
		int imgHeight = logoImage.size.height;
		int x = (self.view.frame.size.width - imgWidth) / 2;
		int y = (44 - logoImage.size.height)/2;
		[logo setFrame:CGRectMake(x,y ,imgWidth ,imgHeight)];
		logo.image = logoImage;
		self.logoView = logo;
		self.navigationItem.titleView = logoView;
		[logoImage release];	
		[logoView release];
		
		UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:productSegMenuArray];
		segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
		CGRect rect=CGRectMake(0.0f, 0.0f, 150.0f, 30.0f);
		segmentedControl.frame=rect;
		segmentedControl.momentary = NO; 
			
		[segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
		self.productSegment = segmentedControl;
		segmentedControl.selectedSegmentIndex = 0;
		self.contactSegment = [[[UIBarButtonItem alloc]initWithCustomView:segmentedControl]autorelease];		
//		self.navigationItem.rightBarButtonItem = contactSegment;
		[segmentedControl release];
		

		UIBarButtonItem * serviceBto1Tmp= [[UIBarButtonItem alloc]
									initWithTitle:@"编辑"
									style:UIBarButtonItemStyleBordered
									target:self
									action:@selector(handleFunction:)];
		serviceBto1Tmp.tag = 1;
		//serviceBto1Tmp =[UIColor colorWithRed:BTO_COLOR_RED green:BTO_COLOR_GREEN blue:BTO_COLOR_BLUE alpha:1];//[UIColor brownColor];

		self.serviceBto1 = serviceBto1Tmp;
		[serviceBto1Tmp release];
		UIBarButtonItem * serviceBto2Tmp= [[UIBarButtonItem alloc]
										   initWithTitle:@"增加"
										   style:UIBarButtonItemStyleBordered
										   target:self
										   action:@selector(handleFunction:)];
		serviceBto2Tmp.tag = 2;
		//serviceBto2Tmp.tintColor=[UIColor colorWithRed:BTO_COLOR_RED green:BTO_COLOR_GREEN blue:BTO_COLOR_BLUE alpha:1];//[UIColor brownColor];

		self.serviceBto2 = serviceBto2Tmp;
		[serviceBto2Tmp release];
		
		UIBarButtonItem * communityBto1Tmp= [[UIBarButtonItem alloc]
										   initWithTitle:@"编辑"
										   style:UIBarButtonItemStyleBordered
										   target:self
										   action:@selector(handleFunction:)];
		communityBto1Tmp.tag = 3;
		self.communityBto1 = communityBto1Tmp;
		[communityBto1Tmp release];
		
		UIBarButtonItem * communityBto2Tmp= [[UIBarButtonItem alloc]
											 initWithTitle:@"增加"
											 style:UIBarButtonItemStyleBordered
											 target:self
											 action:@selector(handleFunction:)];
		communityBto2Tmp.tag = 4;
		self.communityBto2 = communityBto2Tmp;
		[communityBto2Tmp release];
		
		NSMutableArray *hotspotSegMenuArray = [NSMutableArray array];
		for (int i = 0; i < [hotTabArrar count]; i++) {
			ModuleObject *mo = [hotTabArrar objectAtIndex:i];
			if([mo.status isEqualToString:@"1"]){
				[hotspotSegMenuArray addObject:mo.name];
			}
		}
		
		UIBarButtonItem * moreBtoTmp= [[UIBarButtonItem alloc]
											 initWithTitle:@"商店"
											 style:UIBarButtonItemStyleBordered
											 target:self
											 action:@selector(handleFunction:)];
		moreBtoTmp.tag = 5;
		//self.moreBto = moreBtoTmp;
		[moreBtoTmp release];
		self.delegate = self;
		self.backview = nil;	
	}
	//CGRect frame = CGRectMake(0, 0, 320, 49);

//	
#ifdef SHOW_NAV_TAB_BG	
	UIView *v = [[UIView alloc] initWithFrame:self.view.frame];
	UIImage *img = [UIImage imageNamed:TAB_BG_PIC];
	UIColor *bcolor = [[UIColor alloc] initWithPatternImage:img];
	v.backgroundColor = bcolor;
	[self.tabBar insertSubview:v atIndex:0];
	self.tabBar.opaque = YES;
	[bcolor release];
	[v release];
#else
	CGRect frame = CGRectMake(0, 0, self.view.bounds.size.width, 49);
	UIView *view = [[UIView alloc] initWithFrame:frame];
	UIColor *color = [UIColor colorWithRed:BTO_COLOR_RED green:BTO_COLOR_GREEN blue:BTO_COLOR_BLUE alpha:1];
	[view setBackgroundColor:color];
	[[self tabBar] insertSubview:view atIndex:0];
	[[self tabBar] setAlpha:1];
	[view release];
#endif
	
	return self;
}

- (void) viewDidLoad{
	[super viewDidLoad];
	 self.navigationController.navigationBarHidden = YES;
}

- (void) viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	
	hotspotMain.navigationController = self.navigationController;
	
	int selectedIndextmp  = [self selectedIndex];
	NSLog(@"productSegment index:%d",selectedIndextmp);
	if (selectedIndextmp == 0) {
		if(hotspotMain != nil){
			[hotspotMain viewWillAppear:animated];
		}
	}
}

- (void)hideRealTabBar{
	for(UIView *view in self.view.subviews){
		if([view isKindOfClass:[UITabBar class]]){
			view.hidden = YES;
			break;
		}
	}
}

-(int)getRealMenuNum:(int)menuNum withBipmap:(int)menuBitMap{
	
	short bitTest = menuBitMap;
	short bitNum = -1;
	int menuNumTest = -1;
	while (menuNumTest < menuNum) {
		if ((bitTest & 0x0001)==0x001) {
			menuNumTest++;
		}
		bitTest >>= 0x01;
		bitNum++;
	}
	return bitNum;
}
/*-(void)pushViewInMainThread:(UIViewController*)vc{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	[self.navigationController pushViewController:vc animated:YES];
	[pool release];
}
-(void)pushView:(UIViewController*)vc{
	[self performSelectorOnMainThread:@selector(pushViewInMainThread:) withObject:vc waitUntilDone:NO];
	
}*/
- (void)handleFunction:(id)sender{

	UIBarButtonItem *bto = (UIBarButtonItem*)sender;
	switch (bto.tag) {
		case 1:{
			
			[service.tableView setEditing:!service.tableView.editing animated:YES];
			if ([service.myServiceList count]==0||service.myServiceList == nil) {
				[alertView showAlert:@"只能编辑自己增加的联系人，点击右上角的增加按钮进行操作，赶快体验一下吧"];
			}
			
			break;
		}
		case 2:{ 
			addServiceViewController *addContact = [[addServiceViewController alloc]initWithNibName:@"addServiceViewController" bundle:nil];
			addContact.adddelegate = service;
			[self.navigationController pushViewController:addContact animated:YES];
			[addContact release];
			break;
		}
		case 3:{

			[community.tableView setEditing:!community.tableView.editing animated:YES];
			if ([community.myCommunityList count]==0||community.myCommunityList == nil) {
				[alertView showAlert:@"只能编辑自己增加的社区，点击右上角的增加按钮进行操作，赶快体验一下吧"];
			}
			break;
			
		}
		case 4:{
			addCommunityViewController *addCommunity = [[addCommunityViewController alloc]initWithNibName:@"addCommunityViewController" bundle:nil];
			addCommunity.myDelegate = community;
			[self.navigationController pushViewController:addCommunity animated:YES];
			[addCommunity release];
			break;
		}
		case 5:{
			browserViewController *browser = [[browserViewController alloc]init];
			browser.isHideToolbar = YES;
            NSString *link = shop_link;
			browser.linkurl = link;
			[self.navigationController pushViewController:browser animated:YES];
			
			[browser release];
			
			break;
		}

		default:
			break;
	}
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
	NSLog(@"tabbar");
	@try {
		[backview removeFromSuperview];
		//int selectedIndextmp =[self getRealMenuNum:[self selectedIndex] withBipmap:tab_bitmap];
		int selectedIndextmp = [self selectedIndex];
		ModuleObject *mo = [tabArray objectAtIndex:selectedIndextmp];
		NSString *name = mo.key;
		if([name isEqualToString:@"hotspot"]){
			
            ModuleObject *mo = [tabArray objectAtIndex:0];
			self.title = mo.name;
			ButtonItem.title = nil;
			//			self.navigationItem.leftBarButtonItem = nil;
			//			self.navigationItem.rightBarButtonItem = nil;
			//			self.navigationItem.titleView = hotspotSegment;
			[hotspotSegment setFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 30.0f)];
			[chooseVC.view removeFromSuperview];
			productSegment.selectedSegmentIndex = 0;
			hotspotSegment.selectedSegmentIndex = 0;
			self.navigationItem.leftBarButtonItem = nil;
			self.navigationItem.rightBarButtonItem = nil;
			
			UIImage *logoImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"logo" ofType:@"png"]];
			int imgWidth = logoImage.size.width;
			int imgHeight = logoImage.size.height;
			[logoView setFrame:CGRectMake(logoView.frame.origin.x,logoView.frame.origin.y ,imgWidth , imgHeight)];
			
			self.navigationItem.titleView = logoView;
            
		}else if([name isEqualToString:@"product"]){
			self.title = nil;
			ModuleObject *mo = [tabArray objectAtIndex:1];
			ButtonItem.title = mo.name;
			self.navigationItem.leftBarButtonItem = nil;
			self.navigationItem.rightBarButtonItem = contactSegment;
			self.navigationItem.titleView = nil;
			[chooseVC.view removeFromSuperview];
			productSegment.selectedSegmentIndex = 0;
            
            if ([[[UIDevice currentDevice] systemVersion] intValue] >= 5)
            {
                [self segmentAction:productSegment];
            }
            
		}else if([name isEqualToString:@"service"]){
			ModuleObject *mo = [tabArray objectAtIndex:2];
			self.title = @"服务";
			ButtonItem.title = mo.name;
			self.navigationItem.leftBarButtonItem = serviceBto1;
			self.navigationItem.rightBarButtonItem = serviceBto2;
			self.navigationItem.titleView = nil;
			[chooseVC.view removeFromSuperview];
			productSegment.selectedSegmentIndex = 0;
		}else if([name isEqualToString:@"community"]){
			ModuleObject *mo = [tabArray objectAtIndex:3];
			self.title = @"社区";
			ButtonItem.title = mo.name;
			self.navigationItem.leftBarButtonItem = communityBto1;
			self.navigationItem.rightBarButtonItem = communityBto2;
			self.navigationItem.titleView = nil;
			[chooseVC.view removeFromSuperview];
			productSegment.selectedSegmentIndex = 0;
		}else if([name isEqualToString:@"more"]){
			ModuleObject *mo = [tabArray objectAtIndex:4];
			self.title = @"更多";
			ButtonItem.title = mo.name;
			self.navigationItem.leftBarButtonItem = nil;
			self.navigationItem.rightBarButtonItem = moreBto;
			self.navigationItem.titleView = nil;	
			[chooseVC.view removeFromSuperview];
			productSegment.selectedSegmentIndex = 0;
		}
		
	}
	@catch (NSException *exception) {
		NSLog(@"tabchoose: Caught %@: %@", [exception name], [exception reason]);
		return;
	}
	
}
- (IBAction)hotspotsegmentAction:(id)sender{
	
	int selectedIndextmp  = [hotspotSegment selectedSegmentIndex];
	ModuleObject *mo = [hotTabArrar objectAtIndex:selectedIndextmp];
	NSString *segName = mo.key;
	if([segName isEqualToString:@"recommend"] && [mo.status isEqualToString:@"1"]){
		[chooseVC.view removeFromSuperview];
		self.hotspotView.view.hidden = NO;
		[self.selectedViewController viewWillAppear:YES];
	}else if ([segName isEqualToString:@"discount"] && [mo.status isEqualToString:@"1"]) {
		[chooseVC.view removeFromSuperview];
		self.hotspotView.view.hidden = YES;
		promotionsViewController *promotion = [[promotionsViewController alloc]init];
		promotionViewController = promotion;
		promotion.myNavigationController = self.navigationController;
		self.chooseVC = promotion;
		[promotion release];
		for(UIView *one in [self.view subviews])
		{
			if([one isKindOfClass:[UITabBar class]])
			{
				chooseVC.view.frame = CGRectMake(0, 0, one.frame.size.width,one.frame.origin.y);
				break;
			}
		}
		[self.view addSubview:chooseVC.view];
	}else if ([segName isEqualToString:@"trends"] && [mo.status isEqualToString:@"1"]) {
		[chooseVC.view removeFromSuperview];
		self.hotspotView.view.hidden = YES;
		companyNewsViewController *companyNews = [[companyNewsViewController alloc]init];
		companyNewsView = companyNews;
		companyNews.myNavigationController = self.navigationController;
		self.chooseVC = companyNews;
		[companyNews release];
		for(UIView *one in [self.view subviews])
		{
			if([one isKindOfClass:[UITabBar class]])
			{
				chooseVC.view.frame = CGRectMake(0, 0, one.frame.size.width,one.frame.origin.y);
				break;
			}
		}
		[self.view addSubview:chooseVC.view];
	}
//	switch (selectedIndextmp) 
//	{	
//		case 0:{
//			[chooseVC.view removeFromSuperview];
//			[self.selectedViewController viewWillAppear:YES];
//			break;
//		}
//		case 1:{
//			[chooseVC.view removeFromSuperview];
//			promotionsViewController *promotion = [[promotionsViewController alloc]init];
//			promotion.myNavigationController = self.navigationController;
//			self.chooseVC = promotion;
//			[promotion release];
//			for(UIView *one in [self.view subviews])
//			{
//				if([one isKindOfClass:[UITabBar class]])
//				{
//					chooseVC.view.frame = CGRectMake(0, 0, one.frame.size.width,one.frame.origin.y);
//					break;
//				}
//			}
//			[self.view addSubview:backview];
//			[self.view addSubview:chooseVC.view];
//			break;
//			
//		}
//		case 2:{
//			[chooseVC.view removeFromSuperview];
//			companyNewsViewController *companyNews = [[companyNewsViewController alloc]init];
//			companyNews.myNavigationController = self.navigationController;
//			self.chooseVC = companyNews;
//			[companyNews release];
//			for(UIView *one in [self.view subviews])
//			{
//				if([one isKindOfClass:[UITabBar class]])
//				{
//					chooseVC.view.frame = CGRectMake(0, 0, one.frame.size.width,one.frame.origin.y);
//					break;
//				}
//			}
//			[self.view addSubview:backview];
//			[self.view addSubview:chooseVC.view];
//			break;
//			
//		}
//	}
}

- (IBAction)segmentAction:(id)sender{
	
	//if (self.backview == nil) {
//	for(UIView *one in [self.view subviews])
//	{
//		if([one isKindOfClass:[UITabBar class]])
//		{
//			
//			//UIImageView *backiv
//			self.backview.frame = CGRectMake(0, 0, one.frame.size.width,one.frame.origin.y);
//			NSLog(@"fghjkhgfjklkjhgjfhfjjhklkjkhgfdfhgjkjlkhlgfjdjfhgjkhljlk； %f",one.frame.origin.y);
//			UIImage *img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"背景" ofType:@"png"]];
//			self.backview.image = img;
//			[img release];
//			break;
//		}
//	}
//		
//	//}
//	//else {
//		[backview removeFromSuperview];
//	//}

//	int selectedIndextmp =[self getRealMenuNum:[productSegment selectedSegmentIndex] withBipmap:product_seg_bitmap];
//	NSLog(@"selected indextmp %d",selectedIndextmp);
	int selectedIndextmp = [productSegment selectedSegmentIndex];
	ModuleObject *mo = [produceModuleArray objectAtIndex:selectedIndextmp];
	NSString *segName = mo.key;
	NSLog(segName);
	
	if([segName isEqualToString:@"beauty"]){
		[chooseVC.view removeFromSuperview];
		self.beautyPic.view.hidden = NO;
	}else if ([segName isEqualToString:@"video"]) {
		[chooseVC.view removeFromSuperview];
		self.beautyPic.view.hidden = YES;
		videoViewController *video = [[videoViewController alloc]init];
		video.myNavigationController = self.navigationController;
		self.chooseVC = video;
		[video release];
		for(UIView *one in [self.view subviews])
		{
			if([one isKindOfClass:[UITabBar class]])
			{
				chooseVC.view.frame = CGRectMake(0, 0, one.frame.size.width,one.frame.origin.y);
				break;
			}
		}
		[self.view addSubview:chooseVC.view];
	}else if ([segName isEqualToString:@"wallpaper"]) {
		[chooseVC.view removeFromSuperview];
		self.beautyPic.view.hidden = YES;
		wallPaperViewController *wallPaper = [[wallPaperViewController alloc]init];
		wallPaper.myNavigationController = self.navigationController;
		self.chooseVC = wallPaper;
		[wallPaper release];
		for(UIView *one in [self.view subviews])
		{
			if([one isKindOfClass:[UITabBar class]])
			{
				chooseVC.view.frame = CGRectMake(0, 0, one.frame.size.width,one.frame.origin.y);
				break;
			}
		}
		[self.view addSubview:chooseVC.view];
	}else if ([segName isEqualToString:@"solid"]) {
		[chooseVC.view removeFromSuperview];
		self.beautyPic.view.hidden = YES;
		if([soildListArray count] > 1){
			ShowSolidBrowserViewController *solidBrowser = [[ShowSolidBrowserViewController alloc]init];
			solidBrowser.myNavigationController = self.navigationController;
			self.chooseVC = solidBrowser;
			[solidBrowser release];
		}else{
			showRotationPicViewController *rotationPic = [[showRotationPicViewController alloc] initWithNibName:@"showRotationPicViewController" bundle:nil];
			self.chooseVC = rotationPic;
			[rotationPic release];
		}

		for(UIView *one in [self.view subviews])
		{
			if([one isKindOfClass:[UITabBar class]])
			{
				chooseVC.view.frame = CGRectMake(0, 0, one.frame.size.width,one.frame.origin.y);
				break;
			}
		}
		//[self.beautyPic.view addSubview:chooseVC.view];
		[self.view addSubview:chooseVC.view];
	}
//	switch (selectedIndextmp) 
//	{
//			
//		case 0:{
//			[chooseVC.view removeFromSuperview];
//			break;
//		}
//		case 1:{
//			[chooseVC.view removeFromSuperview];
//			videoViewController *video = [[videoViewController alloc]init];
//			video.myNavigationController = self.navigationController;
//			self.chooseVC = video;
//			[video release];
//			for(UIView *one in [self.view subviews])
//			{
//				if([one isKindOfClass:[UITabBar class]])
//				{
//					chooseVC.view.frame = CGRectMake(0, 0, one.frame.size.width,one.frame.origin.y);
//					break;
//				}
//			}
//			[self.view addSubview:backview];
//			[self.view addSubview:chooseVC.view];
//			break;
//		}
//		case 2:{
//			[chooseVC.view removeFromSuperview];
//			wallPaperViewController *wallPaper = [[wallPaperViewController alloc]init];
//			wallPaper.myNavigationController = self.navigationController;
//			self.chooseVC = wallPaper;
//			[wallPaper release];
//			for(UIView *one in [self.view subviews])
//			{
//				if([one isKindOfClass:[UITabBar class]])
//				{
//					chooseVC.view.frame = CGRectMake(0, 0, one.frame.size.width,one.frame.origin.y);
//					break;
//				}
//			}
//			[self.view addSubview:chooseVC.view];
//			break;
//		}
//		case 3:{
//			[chooseVC.view removeFromSuperview];
//			showRotationPicViewController *rotationPic = [[showRotationPicViewController alloc]init];
//			self.chooseVC = rotationPic;
//			[rotationPic release];
//			for(UIView *one in [self.view subviews])
//			{
//				if([one isKindOfClass:[UITabBar class]])
//				{
//					chooseVC.view.frame = CGRectMake(0, 0, one.frame.size.width,one.frame.origin.y);
//					break;
//				}
//			}
//			[self.beautyPic.view addSubview:chooseVC.view];
//			break;
//		}
//	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return NO;
}

-(void)dealloc{
	self.hotspotView = nil;
	self.moreView = nil;
	self.serviceBto1 = nil;
	self.serviceBto2 = nil;
	self.communityBto1 = nil;
	self.communityBto2 = nil;
	self.hotspotSegment = nil;
	self.moreBto = nil;
	self.contactSegment = nil;
	self.chooseVC = nil;
	self.productSegment = nil;
	self.service = nil;
	self.community = nil;
	self.ButtonItem = nil;
	self.beautyPic = nil;
	[self.backview removeFromSuperview];
	self.backview = nil;
	promotionViewController = nil;
	companyNewsView = nil;
	self.hotspotMain = nil;
	self.logoView = nil;
	[super dealloc];
}
@end
