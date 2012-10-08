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

@interface MainScreen (){
     NSArray* viewControllers;
}
@end

@implementation MainScreen
@synthesize indexNo;
@synthesize userRequest;
@synthesize IndexTab,mainH,mainBH;

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
    NSLog(@"MAINLA-SINo:%@, age:%d, job:%@",mainH.storedSINo,mainH.storedAge,mainH.storedOccpCode);
    NSLog(@"MAINBasic-SINo:%@, age:%d, job:%@",mainBH.storedSINo,mainBH.storedAge,mainBH.storedOccpCode);
    
    //Create view controllers
    NSMutableArray* controllersToAdd = [[NSMutableArray alloc] init];
    
    setting* settingPage = [self.storyboard instantiateViewControllerWithIdentifier:@"Setting"];
    settingPage.indexNo = self.indexNo;
    settingPage.userRequest = self.userRequest;
    settingPage.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Setting" image:[UIImage imageNamed:@"magnifying-glass.png"] tag: 0];
    [controllersToAdd addObject:settingPage];    
    
    ProspectListing* ProspectListingPage = [self.storyboard instantiateViewControllerWithIdentifier:@"ProspectListing"];
    ProspectListingPage.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Prospect\nListing" image:[UIImage imageNamed:@"magnifying-glass.png"] tag: 0];
    [controllersToAdd addObject:ProspectListingPage];    
    
    SIListing* SIListingPage = [self.storyboard instantiateViewControllerWithIdentifier:@"SIListing"];
    SIListingPage.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Listing" image:[UIImage imageNamed:@"magnifying-glass.png"] tag: 0];
    [controllersToAdd addObject:SIListingPage];
    viewControllers = [NSArray arrayWithArray:controllersToAdd];
    
    SIMenuViewController *menuSIPage = [self.storyboard instantiateViewControllerWithIdentifier:@"SIPageView"];
    menuSIPage.menuH = mainH;
    menuSIPage.menuBH = mainBH;
    menuSIPage.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"SI" image:[UIImage imageNamed:@"magnifying-glass.png"] tag: 0];
    [controllersToAdd addObject:menuSIPage];
    viewControllers = [NSArray arrayWithArray:controllersToAdd];

    
    Logout* LogoutPage = [self.storyboard instantiateViewControllerWithIdentifier:@"Logout"];
    LogoutPage.indexNo = self.indexNo;
    LogoutPage.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Logout" image:[UIImage imageNamed:@"magnifying-glass.png"] tag: 0];
    [controllersToAdd addObject:LogoutPage];
    viewControllers = [NSArray arrayWithArray:controllersToAdd];
    
    
    
    //set the view controllers of the the tab bar controller
    [self setViewControllers:viewControllers];
    
    //set the background color to a texture
    //[[self tabBar] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"ios-linen.png"]]];
    NSArray *colors = [NSArray arrayWithObjects:(id)[UIColor whiteColor].CGColor,(id)[UIColor lightGrayColor].CGColor, nil];
    self.tabBar.backgroundGradientColors = colors;
    
    if (self.IndexTab) {
        self.selectedViewController = ((UIViewController*)[viewControllers objectAtIndex:IndexTab]);
    }
    else {
        self.selectedViewController = ((UIViewController*)[viewControllers objectAtIndex:0]);
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

-(BOOL)tabBarController:(FSVerticalTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if ([viewControllers indexOfObject:viewController] == 5) {
        return NO;
    }
    return YES;
}

@end
