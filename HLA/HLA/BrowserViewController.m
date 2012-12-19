//
//  ViewController.m
//  JTRevealSidebarDemo
//
//  Created by James Apple Tang on 7/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "BrowserViewController.h"
#import "UIViewController+JTRevealSidebarV2.h"
#import "UINavigationItem+JTRevealSidebarV2.h"
#import "SidebarViewController.h"
#import "JTRevealSidebarV2Delegate.h"
#import "MainScreen.h"
#import "PremiumViewController.h"


#if EXPERIEMENTAL_ORIENTATION_SUPPORT
#import <QuartzCore/QuartzCore.h>
#endif

@interface BrowserViewController (Private) <UITableViewDataSource, UITableViewDelegate, SidebarViewControllerDelegate>
@end

@implementation BrowserViewController
@synthesize leftSelectedIndexPath, leftSidebarViewController;
@synthesize delegate = _delegate;
@synthesize premH, premBH;
//@synthesize leftSidebarViewController;
//@synthesize leftSelectedIndexPath;

- (id)init {
    self = [super init];
    return self;
    
    
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    
    
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(revealLeftSidebar:)];
    
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(revealRightSidebar:)];
    /*
    UIBarButtonItem *zzz = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(testing) ];
    
    UIBarButtonItem *www = [[UIBarButtonItem alloc] init ];
    www.title = @"Previous";
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:zzz, www, Nil];
    */

    
    
    CDVViewController* browserController_page = [CDVViewController new];
    browserController_page.wwwFolderName = @"www";
    browserController_page.startPage = @"Page1.html";//(NSString *)objectHTML;
    browserController_page.view.frame = CGRectMake(0, 0, 758, 1000);
    [self.view addSubview:browserController_page.view];
    browserController_page = nil;
    
    
    
    
    self.navigationItem.revealSidebarDelegate = self;
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"Close" 
                                                                  style:UIBarButtonItemStyleBordered target:self action:@selector(CloseButtonAction)];
    self.navigationItem.rightBarButtonItem = barButton;
    
    //NSLog(@"before");
    //[self performSelector:@selector(presentModal) withObject:Nil afterDelay:3.0];
    
    
}



-(void)presentModal{
    //NSLog(@"sssss");
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.leftSidebarViewController = nil;
}
/*
-(void)viewWillAppear:(BOOL)animated{
    CDVViewController* browserController_page = [CDVViewController new];
    browserController_page.wwwFolderName = @"www";
    browserController_page.startPage = @"Page1.html";//(NSString *)objectHTML;
    browserController_page.view.frame = CGRectMake(0, 0, 768, 1000);
    [self.view addSubview:browserController_page.view];
    browserController_page = nil;
    
}
*/
#if EXPERIEMENTAL_ORIENTATION_SUPPORT
// Doesn't support rotating to other orientation at this moment
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    _containerOrigin = self.navigationController.view.frame.origin;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    self.navigationController.view.layer.bounds       = (CGRect){-_containerOrigin.x, _containerOrigin.y, self.navigationController.view.frame.size};
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    self.navigationController.view.layer.bounds       = (CGRect){CGPointZero, self.navigationController.view.frame.size};
    self.navigationController.view.frame              = (CGRect){_containerOrigin, self.navigationController.view.frame.size};
}
#endif

#pragma mark Action

- (void)revealLeftSidebar:(id)sender {
    [self.navigationController toggleRevealState:JTRevealedStateLeft];
}


#pragma mark JTRevealSidebarDelegate

- (UIView *)viewForLeftSidebar {
    CGRect viewFrame = self.navigationController.applicationViewFrame;
    UITableViewController *controller = self.leftSidebarViewController;
    if ( ! controller) {
        self.leftSidebarViewController = [[SidebarViewController alloc] init];
        self.leftSidebarViewController.sidebarDelegate = self;
        controller = self.leftSidebarViewController;
        //controller.title = @"LeftSidebarViewController";
    }
    controller.view.frame = CGRectMake(0, viewFrame.origin.y, 270, viewFrame.size.height);
    controller.view.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
    
    
    return controller.view;
}


- (void)didChangeRevealedStateForViewController:(UIViewController *)viewController {
    
    
    if (viewController.revealedState == JTRevealedStateNo) {
        self.view.userInteractionEnabled = YES;
    } else {
        self.view.userInteractionEnabled = NO;
    }
}

@end


@implementation BrowserViewController (Private)

#pragma mark UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark SidebarViewControllerDelegate

- (void)sidebarViewController:(SidebarViewController *)sidebarViewController didSelectObject:(NSObject *)object objectHTML:(NSObject *)objectHTML atIndexPath:(NSIndexPath *)indexPath {
    
    //UIView *v =  [[self.view subviews] objectAtIndex:[self.view subviews].count - 1 ];
    //[v removeFromSuperview];
    
    [self.navigationController setRevealedState:JTRevealedStateNo];
    
    BrowserViewController *controller = [[BrowserViewController alloc] init];
    controller.title = (NSString *)object;
    controller.leftSidebarViewController = sidebarViewController;
    controller.leftSelectedIndexPath = indexPath;
    sidebarViewController.sidebarDelegate = controller;
    [self.navigationController setViewControllers:[NSArray arrayWithObject:controller] animated:NO];
    controller.delegate = _delegate;
    
    /*
    [self.navigationController setRevealedState:JTRevealedStateNo];
    self.title = (NSString *)object;
    self.leftSidebarViewController = sidebarViewController;
    self.leftSelectedIndexPath = indexPath;
    sidebarViewController.sidebarDelegate = self;
    */
    
    browserController = [CDVViewController new];
    browserController.wwwFolderName = @"www";
    browserController.startPage = (NSString *)objectHTML;
    browserController.view.frame = CGRectMake(0, 0, 758, 1000);
    [controller.view addSubview:browserController.view];
    //[self.view addSubview:browserController.view];
    browserController = nil;
    
}

-(void)testing{
    
    BrowserViewController *controller = [[BrowserViewController alloc] init];
    
    [self.navigationController setViewControllers:[NSArray arrayWithObject:controller] animated:NO];
    controller.delegate = _delegate;
    
    
    browserController = [CDVViewController new];
    browserController.wwwFolderName = @"www";
    browserController.startPage = @"Page2.html";
    browserController.view.frame = CGRectMake(0, 0, 758, 1000);
    [controller.view addSubview:browserController.view];
    
    browserController = nil;
    
}

- (NSIndexPath *)lastSelectedIndexPathForSidebarViewController:(SidebarViewController *)sidebarViewController {
    return self.leftSelectedIndexPath;
}

-(void)CloseButtonAction{
    //NSLog(@"%d", [self.view subviews].count);
    
    if ([self.view subviews].count > 1) {
        
        [_delegate CloseWindow];
        [self dismissModalViewControllerAnimated:YES];
        
    }
    else {
        [_delegate CloseWindow];
        [self dismissModalViewControllerAnimated:YES];
    }
    
    /*
    if (_delegate != Nil) {
        NSLog(@"close");
        [_delegate CloseWindow];
        [self dismissViewControllerAnimated:YES completion:Nil];
    }
    */
    /*
    MainScreen *main = [self.storyboard instantiateViewControllerWithIdentifier:@"Main"];
        main.modalPresentationStyle = UIModalPresentationFullScreen;
        main.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        main.mainH = premH;
        main.mainBH = premBH;
        main.IndexTab = 3;
        main.showQuotation = @"YES";
        //[self presentModalViewController:main animated:YES];
        [self presentViewController:main animated:YES completion:Nil]; 
      */ 
    
    
}

@end