//
//  MainScreen.m
//  HLA
//
//  Created by Md. Nazmus Saadat on 9/26/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import "MainScreen.h"
#import "FSVerticalTabBarController.h"
#import "setting.h"
#import "ProspectViewController.h"
#import "ProspectListing.h"
#import "Logout.h"
#import "SIListing.h"
#import "SIMenuViewController.h"
#import "CarouselViewController.h"
#import "DemoHtml.h"
#import "ReportViewController.h"
#import "NewLAViewController.h"


@interface MainScreen (){
     NSArray* viewControllers;
}
@end

@implementation MainScreen
@synthesize indexNo, showQuotation;
@synthesize userRequest;
@synthesize IndexTab,mainLaH,mainBH,mainPH,mainLa2ndH;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
    
    //passing value
    NSLog(@"MAINLA-age:%d, job:%@",mainLaH.storedAge,mainLaH.storedOccpCode);
    NSLog(@"MAINBasic-SINo:%@, age:%d, job:%@",mainBH.storedSINo,mainBH.storedAge,mainBH.storedOccpCode);
    
    //Create view controllers
    NSMutableArray* controllersToAdd = [[NSMutableArray alloc] init];
    
    CarouselViewController* carouselPage = [self.storyboard instantiateViewControllerWithIdentifier:@"carouselView"];
    carouselPage.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Home" image:[UIImage imageNamed:@"btn_home.png"] tag: 0];
    [controllersToAdd addObject:carouselPage];
    viewControllers = [NSArray arrayWithArray:controllersToAdd];
    
    /*
    setting* settingPage = [self.storyboard instantiateViewControllerWithIdentifier:@"Setting"];
    settingPage.indexNo = self.indexNo;
    settingPage.userRequest = self.userRequest;
    settingPage.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Setting" image:[UIImage imageNamed:@"setting_btnB2.png"] tag: 0];
    [controllersToAdd addObject:settingPage];    
    */
    
    ProspectListing* ProspectListingPage = [self.storyboard instantiateViewControllerWithIdentifier:@"ProspectListing"];
    ProspectListingPage.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Prospect Listing" image:[UIImage imageNamed:@"btn_prospect_off.png"] tag: 0];

    [controllersToAdd addObject:ProspectListingPage];
    
    /*
    ProspectViewController* NewProspectPage = [self.storyboard instantiateViewControllerWithIdentifier:@"Prospect"];
    NewProspectPage.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"New Prospect" image:[UIImage imageNamed:@"btn_prospect_off.png"] tag: 0];
    [controllersToAdd addObject:NewProspectPage];
    */
     
    SIListing* SIListingPage = [self.storyboard instantiateViewControllerWithIdentifier:@"SIListing"];
    SIListingPage.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"SI Listing" image:[UIImage imageNamed:@"btn_SIlisting_off.png"] tag: 0];
    [controllersToAdd addObject:SIListingPage];
    viewControllers = [NSArray arrayWithArray:controllersToAdd];
    
    SIMenuViewController *menuSIPage = [self.storyboard instantiateViewControllerWithIdentifier:@"SIPageView"];
    /*
    menuSIPage.menulaH = mainLaH;
    menuSIPage.menuBH = mainBH;
    menuSIPage.menuPH = mainPH;
    menuSIPage.menuLa2ndH = mainLa2ndH; */
    menuSIPage.requestSINo = [self.requestSINo description];
    menuSIPage.SIshowQuotation = showQuotation;
    menuSIPage.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"SI" image:[UIImage imageNamed:@"btn_newSI_off.png"] tag: 0];
    [controllersToAdd addObject:menuSIPage];
    viewControllers = [NSArray arrayWithArray:controllersToAdd];

    Logout* LogoutPage = [self.storyboard instantiateViewControllerWithIdentifier:@"Logout"];
    LogoutPage.indexNo = self.indexNo;
    LogoutPage.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Exit" image:[UIImage imageNamed:@"btn_exit.png"] tag: 0];
    [controllersToAdd addObject:LogoutPage];
    viewControllers = [NSArray arrayWithArray:controllersToAdd];
    
    /*
    ReportViewController *reportPage = [self.storyboard instantiateViewControllerWithIdentifier:@"Report"];
    reportPage.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Report" image:[UIImage imageNamed:@"magnifying-glass.png"] tag: 0];
    //reportPage.SINo = @"SI20121030-00022";
    [controllersToAdd addObject:reportPage];
    viewControllers = [NSArray arrayWithArray:controllersToAdd];
    */
    
    
    /*
    DemoHtml *demoPage = [self.storyboard instantiateViewControllerWithIdentifier:@"DemoHtml"];
    demoPage.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Report" image:[UIImage imageNamed:@"magnifying-glass"] tag: 0];
    [controllersToAdd addObject:demoPage];
    viewControllers = [NSArray arrayWithArray:controllersToAdd];
    */
    
    
    //set the view controllers of the the tab bar controller
    [self setViewControllers:viewControllers];
    
    //set the background color to a texture
    //[[self tabBar] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"ios-linen.png"]]];
    NSArray *colors = [NSArray arrayWithObjects:(id)[UIColor whiteColor].CGColor,(id)[UIColor lightGrayColor].CGColor, nil];
    self.tabBar.backgroundGradientColors = colors;
    
    if (self.IndexTab) {
        clickIndex = IndexTab;
        self.selectedViewController = ((UIViewController*)[viewControllers objectAtIndex:IndexTab]);
    
    }
    else {
        self.selectedViewController = ((UIViewController*)[viewControllers objectAtIndex:1]);
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if (interfaceOrientation==UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationLandscapeLeft)
        return YES;
    
    return NO;
    
}

-(BOOL)tabBarController:(FSVerticalTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    if ([viewControllers indexOfObject:viewController] == 6) {
        return NO;
    }
    else {
        return YES;
    }
}

@end
