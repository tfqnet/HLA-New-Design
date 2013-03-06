//
//  PDSBrowserViewController.m
//  HLA Ipad
//
//  Created by infoconnect on 1/7/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import "PDSBrowserViewController.h"
#import "UIViewController+JTRevealSidebarV2.h"
#import "UINavigationItem+JTRevealSidebarV2.h"
#import "PDSSidebarViewController.h"
#import "JTRevealSidebarV2Delegate.h"
#import "MainScreen.h"
#import "PremiumViewController.h"
#import <sqlite3.h>

#if EXPERIEMENTAL_ORIENTATION_SUPPORT
#import <QuartzCore/QuartzCore.h>
#endif

@interface PDSBrowserViewController (Private) <UITableViewDataSource, UITableViewDelegate, PDSSidebarViewControllerDelegate>

@end

@implementation PDSBrowserViewController
@synthesize leftSelectedIndexPath, leftSidebarViewController;
@synthesize delegate = _delegate;
@synthesize gPages, PDSLanguage;

id databasePath;
NSMutableArray *ItemPages;

- (id)init {
    self = [super init];
    return self;
    
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{/*
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
  */
    return self;
}

- (void)viewDidLoad
{
    sqlite3 *contactDB;
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(revealLeftSidebar:)];
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(revealRightSidebar:)];
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(revealLeftSidebar:)];
    next = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(NextPage) ];
    prev = [[UIBarButtonItem alloc] initWithTitle:@"Prev" style:UIBarButtonItemStyleBordered target:self action:@selector(PrevPage) ];
    
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:left, prev, next, Nil];
    
    CDVViewController* browserController_page = [CDVViewController new];
    browserController_page.wwwFolderName = @"www";
    if ([PDSLanguage isEqualToString:@"E"]) {
        browserController_page.startPage = @"ENG_PDS1.html";
    }
    else{
        browserController_page.startPage = @"BM_PDS1.html";
    }
    
    browserController_page.view.frame = CGRectMake(0, 0, 758, 1000);
    [self.view addSubview:browserController_page.view];
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [[NSURLCache sharedURLCache] setDiskCapacity:0];
    [[NSURLCache sharedURLCache] setMemoryCapacity:0];
    [browserController_page dispose];
    browserController_page = nil;
    
    self.navigationItem.revealSidebarDelegate = self;
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"Close"
                                                                  style:UIBarButtonItemStyleBordered target:self action:@selector(CloseButtonAction)];
    self.navigationItem.rightBarButtonItem = barButton;
    
    //[self performSelector:@selector(presentModal) withObject:Nil afterDelay:3.0];
    
    ItemPages = [[NSMutableArray alloc] init ];
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
    
    
    
    //gPages = 0;
    
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK){
        
        NSString *QuerySQL = @"";
        
            QuerySQL = [NSString stringWithFormat: @"Select htmlName from SI_Temp_Pages_PDS"];
        
        
        
        if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            
            while(sqlite3_step(statement) == SQLITE_ROW) {
                [ItemPages addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)]];
            }
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(contactDB);
        
        QuerySQL = Nil;
    }
    
    contactDB = Nil;
    dirPaths = Nil;
    docsDir = Nil;
    databasePath = Nil;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.leftSidebarViewController = nil;
    ItemPages = Nil;
    browserController = Nil;
    PDSLanguage = Nil;
    databasePath = Nil;
    
}

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
        self.leftSidebarViewController = [[PDSSidebarViewController alloc] init];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    UIAlertView *sss = [[UIAlertView alloc] initWithTitle:@"Memory warning"
                                                  message:@"Not enough memory. Please restart the application" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil ];
    [sss show];
    sss = Nil;
}

@end

@implementation PDSBrowserViewController (Private)

#pragma mark UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark PDSSidebarViewControllerDelegate

- (void)PDSsidebarViewController:(PDSSidebarViewController *)PDSsidebarViewController didSelectObject:(NSObject *)object objectHTML:(NSObject *)objectHTML atIndexPath:(NSIndexPath *)indexPath {
    
    //UIView *v =  [[self.view subviews] objectAtIndex:[self.view subviews].count - 1 ];
    //[v removeFromSuperview];
    
    [self.navigationController setRevealedState:JTRevealedStateNo];
    
    PDSBrowserViewController *controller = [[PDSBrowserViewController alloc] init];
    controller.title = (NSString *)object;
    controller.leftSidebarViewController = PDSsidebarViewController;
    controller.leftSelectedIndexPath = indexPath;
    PDSsidebarViewController.sidebarDelegate = controller;
    controller.gPages = indexPath.row ;
    controller.title = [NSString stringWithFormat:@"Page%d / %d", indexPath.row + 1, ItemPages.count];
    [self.navigationController setViewControllers:[NSArray arrayWithObject:controller] animated:NO];
    controller.delegate = _delegate;
    
    browserController = [CDVViewController new];
    browserController.wwwFolderName = @"www";
    browserController.startPage = (NSString *)objectHTML;
    browserController.view.frame = CGRectMake(0, 0, 758, 1000);
    [controller.view addSubview:browserController.view];
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [[NSURLCache sharedURLCache] setDiskCapacity:0];
    [[NSURLCache sharedURLCache] setMemoryCapacity:0];
    [browserController dispose];
    
    browserController = nil;
    controller = Nil;
    
}


-(void)NextPage{
    
    [self.navigationController setRevealedState:JTRevealedStateNo];
    UIView *v =  [[self.view subviews] objectAtIndex:[self.view subviews].count - 1 ];
    [v removeFromSuperview];
    v = Nil;
    
    next.enabled = FALSE;
    prev.enabled = FALSE;
    
    if (gPages + 1 < ItemPages.count) {
        gPages = gPages + 1;
        //next.enabled = TRUE;
    }
    else{
        //next.enabled = false;
    }
    
    browserController = [CDVViewController new];
    browserController.wwwFolderName = @"www";
    browserController.startPage = [NSString stringWithFormat: @"%@", [ItemPages objectAtIndex:gPages]];
    browserController.view.frame = CGRectMake(0, 0, 1024, 700);
    self.title = [NSString stringWithFormat:@"Page %d / %d", gPages + 1, ItemPages.count ];
    [self.view addSubview:browserController.view];
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [[NSURLCache sharedURLCache] setDiskCapacity:0];
    [[NSURLCache sharedURLCache] setMemoryCapacity:0];
    [browserController dispose];
    browserController = nil;
    [self performSelector:@selector(enablePDSNext) withObject:Nil afterDelay:1.5];
}

-(void)PrevPage{
    
    [self.navigationController setRevealedState:JTRevealedStateNo];
    UIView *v =  [[self.view subviews] objectAtIndex:[self.view subviews].count - 1 ];
    [v removeFromSuperview];
    v = Nil;
    
    next.enabled = FALSE;
    prev.enabled = FALSE;
    
    if (gPages - 1 >= 0 ) {
        gPages = gPages - 1;
        //prev.enabled = TRUE;
    }else{
        //prev.enabled = FALSE;
        
    }
    
    browserController = [CDVViewController new];
    browserController.wwwFolderName = @"www";
    browserController.startPage = [NSString stringWithFormat: @"%@", [ItemPages objectAtIndex:gPages]];
    browserController.view.frame = CGRectMake(0, 0, 1024, 700);
    self.title = [NSString stringWithFormat:@"Page %d / %d", gPages + 1, ItemPages.count ];
    [self.view addSubview:browserController.view];
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [[NSURLCache sharedURLCache] setDiskCapacity:0];
    [[NSURLCache sharedURLCache] setMemoryCapacity:0];
    [browserController dispose];
    browserController = nil;
    [self performSelector:@selector(enablePDSPre) withObject:Nil afterDelay:1.5];
}

-(void)enablePDSNext{
    if (gPages + 1 != ItemPages.count) {
        next.enabled = TRUE;
    }
    
    prev.enabled = TRUE;
    
}

-(void)enablePDSPre{
    next.enabled = TRUE;
    
    if (gPages > 0 ){
        prev.enabled = TRUE;
    }
    
}

- (NSIndexPath *)PDSlastSelectedIndexPathForSidebarViewController:(PDSSidebarViewController *)PDSsidebarViewController {
    return self.leftSelectedIndexPath;
}

-(void)CloseButtonAction{
    

    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [[NSURLCache sharedURLCache] setDiskCapacity:0];
    [[NSURLCache sharedURLCache] setMemoryCapacity:0];
    [browserController dispose];
    browserController = Nil;
    
    
    UIView *v =  [[self.view subviews] objectAtIndex:[self.view subviews].count - 1 ];
    [v removeFromSuperview];
    v = Nil;
    
    leftSidebarViewController.dataArray = Nil;
    self.leftSidebarViewController = nil;
    ItemPages = Nil;
    browserController = Nil;
    PDSLanguage = Nil;
    databasePath = Nil;
    
    if ([self.view subviews].count > 1) {
        
        //[_delegate CloseWindow];
        [self dismissModalViewControllerAnimated:YES];
        
    }
    else {
        //[_delegate CloseWindow];
        [self dismissModalViewControllerAnimated:YES];
    }
    
    //[self dismissModalViewControllerAnimated:YES];
    
    
}


@end
