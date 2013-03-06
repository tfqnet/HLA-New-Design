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
#import <sqlite3.h>

#if EXPERIEMENTAL_ORIENTATION_SUPPORT
#import <QuartzCore/QuartzCore.h>
#endif

@interface BrowserViewController (Private) <UITableViewDataSource, UITableViewDelegate, SidebarViewControllerDelegate>
@end

@implementation BrowserViewController
@synthesize leftSelectedIndexPath, leftSidebarViewController;
@synthesize delegate = _delegate;
@synthesize gPages,Module;
//@synthesize leftSidebarViewController;
//@synthesize leftSelectedIndexPath;

id databasePath;
NSMutableArray *ItemPages;

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
	if (Module == 0) {
			browserController_page.startPage = @"Page1.html";//(NSString *)objectHTML;
	}
	else{
		browserController_page.startPage = @"HLACP_Page1.html";//(NSString *)objectHTML;
	}
    
    browserController_page.view.frame = CGRectMake(0, 0, 758, 1000);
    [self.view addSubview:browserController_page.view];
    
	[browserController_page.webView loadHTMLString:@"" baseURL:nil];
    [browserController_page.webView stopLoading];
    [browserController_page.webView removeFromSuperview];
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
        
                QuerySQL = [NSString stringWithFormat: @"Select htmlName from SI_Temp_Pages"];
        
        
        if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
         
            while(sqlite3_step(statement) == SQLITE_ROW) {
                [ItemPages addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)]];
            }
            sqlite3_finalize(statement);
        
        }
        sqlite3_close(contactDB);
        
        QuerySQL = Nil;
    }
    
	
	
    statement = Nil;
    dirPaths = Nil;
    docsDir = Nil;
    barButton = Nil;
    contactDB = Nil;
    left = Nil;
    barButton = Nil;
    
    browserController = Nil;
    databasePath = Nil;
    browserController_page.webView = Nil;
    browserController_page.webView.delegate = Nil;

}

-(void)Testing{
	int imageName = 0;
	double webViewHeight = 1024.00;
	CGRect screenRect = self.view.frame;
	
	double currentWebViewHeight = webViewHeight;

	while (currentWebViewHeight > 0)
	{
		imageName ++;
		
		UIGraphicsBeginImageContext(screenRect.size);
		
		CGContextRef ctx = UIGraphicsGetCurrentContext();
		[[UIColor blackColor] set];
		CGContextFillRect(ctx, screenRect);
		
		[self.view.layer renderInContext:ctx];
		
		UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
		
		UIGraphicsEndImageContext();
		
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		NSString *pngPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.png",imageName]];
		
		//NSLog(@"%@", documentsDirectory);
		
		if(currentWebViewHeight < 960)
		{
			CGRect lastImageRect = CGRectMake(0, 960 - currentWebViewHeight, self.view.frame.size.width, currentWebViewHeight);
			CGImageRef lastImageRef = CGImageCreateWithImageInRect([newImage CGImage], lastImageRect);
			newImage = [UIImage imageWithCGImage:lastImageRef];
			CGImageRelease(lastImageRef);
		}
		
		[UIImagePNGRepresentation(newImage) writeToFile:pngPath atomically:YES];
		
		//[self.webView stringByEvaluatingJavaScriptFromString:@"window.scrollBy(0,960);"];
		currentWebViewHeight -= 960;
	}
	
	
}

-(void)presentModal{
    //NSLog(@"sssss");
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.leftSidebarViewController = nil;
    leftSelectedIndexPath = Nil;
    browserController = Nil;
    databasePath = Nil;
    ItemPages = Nil;
    prev = Nil, next = Nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    UIAlertView *sss = [[UIAlertView alloc] initWithTitle:@"Memory warning"
                                                  message:@"Not enough memory. Please restart the application" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil ];
    [sss show];
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
    controller.gPages = indexPath.row;
    controller.title = [NSString stringWithFormat:@"Page%d / %d", indexPath.row + 1, ItemPages.count];
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
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [[NSURLCache sharedURLCache] setDiskCapacity:0];
    [[NSURLCache sharedURLCache] setMemoryCapacity:0];

    [browserController dispose];
    browserController = nil;
    browserController.webView = Nil;
    browserController.webView.delegate = Nil;
    controller = Nil;
    
    
}

-(void)NextPage{
    
    /*
    BrowserViewController *controller = [[BrowserViewController alloc] init];
    [self.navigationController setViewControllers:[NSArray arrayWithObject:controller] animated:NO];
    controller.delegate = _delegate;
    
    
    browserController = [CDVViewController new];
    browserController.wwwFolderName = @"www";
    browserController.startPage = [NSString stringWithFormat: @"Page%d.html", 2];
    browserController.view.frame = CGRectMake(0, 0, 758, 1000);
    [self.view addSubview:browserController.view];
    
    browserController = nil;
    */
    
    prev.enabled = false;
    next.enabled= false;
    
    [self.navigationController setRevealedState:JTRevealedStateNo];

    UIView *v =  [[self.view subviews] objectAtIndex:[self.view subviews].count - 1 ];
    [v removeFromSuperview];
    v = Nil;
     
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
    
    [browserController.webView loadHTMLString:@"" baseURL:nil];
    [browserController.webView stopLoading];
    [browserController.webView removeFromSuperview];

    [browserController dispose ];
    browserController.webView = Nil;
    browserController.webView.delegate = Nil;
    browserController = Nil;
    
    
    [self performSelector:@selector(enableNext) withObject:Nil afterDelay:1.5];
}



-(void)PrevPage{
    
    prev.enabled = FALSE;
    next.enabled = false;
    
    [self.navigationController setRevealedState:JTRevealedStateNo];
    UIView *v =  [[self.view subviews] objectAtIndex:[self.view subviews].count - 1 ];
    [v removeFromSuperview];
    v = Nil;
    
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
    
    [browserController.webView loadHTMLString:@"" baseURL:nil];
    [browserController.webView stopLoading];
    [browserController.webView removeFromSuperview];
        [browserController dispose ];
    browserController.webView = Nil;
    browserController.webView.delegate = Nil;
    browserController = nil;
    
    
    [self performSelector:@selector(enablePre) withObject:Nil afterDelay:1.5];
}

-(void)enableNext{
    if (gPages + 1 != ItemPages.count) {
        next.enabled = TRUE;
    }
    
	//[self Testing];
    prev.enabled = TRUE;
    
}

-(void)enablePre{
    next.enabled = TRUE;
    
    if (gPages > 0 ){
        prev.enabled = TRUE;
    }
    
}

- (NSIndexPath *)lastSelectedIndexPathForSidebarViewController:(SidebarViewController *)sidebarViewController {
    return self.leftSelectedIndexPath;
}

-(void)CloseButtonAction{

    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [[NSURLCache sharedURLCache] setDiskCapacity:0];
    [[NSURLCache sharedURLCache] setMemoryCapacity:0];
    
    [browserController.webView loadHTMLString:@"" baseURL:nil];
    [browserController.webView stopLoading];
    [browserController.webView removeFromSuperview];
    [browserController dispose ];
    browserController.webView = Nil;
    browserController.webView.delegate = Nil;
    UIView *v =  [[self.view subviews] objectAtIndex:[self.view subviews].count - 1 ];
    [v removeFromSuperview];
    v = Nil;
    
    leftSelectedIndexPath = Nil;
    browserController = Nil;
    databasePath = Nil;
    ItemPages = Nil;
    prev = Nil, next = Nil;
    _delegate = Nil;
    leftSidebarViewController.dataArray = Nil;
    leftSidebarViewController = Nil;
    
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