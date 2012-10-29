//
//  DemoHtml.m
//  HLA Ipad
//
//  Created by Md. Nazmus Saadat on 10/18/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import "DemoHtml.h" 
#import "JTRevealSidebarView.h"
#import "JTNavigationView.h"
#import "JTTableViewDatasource.h"
#import "JTTableViewCellModal.h"
#import "JTTableViewCellFactory.h"
#import "ChangePassword.h"
typedef enum {
    JTTableRowTypeBack,
    JTTableRowTypePushContentView,
} JTTableRowTypes;


@interface DemoHtml (UITableView) <JTTableViewDatasourceDelegate>

@end

@implementation DemoHtml

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _datasource = [[JTTableViewDatasource alloc] init];
        _datasource.sourceInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"root", @"url", nil];
        _datasource.delegate   = self;
    }
    return self;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Create a default style RevealSidebarView
    
    _datasource = [[JTTableViewDatasource alloc] init];
    _datasource.sourceInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"root", @"url", nil];
    _datasource.delegate   = self;
    
    _revealView = [JTRevealSidebarView defaultViewWithFrame:self.view.bounds];
    
    // Setup a view to be the rootView of the sidebar
    UITableView *tableView = [[UITableView alloc] initWithFrame:_revealView.sidebarView.bounds];
    tableView.delegate   = _datasource;
    tableView.dataSource = _datasource;
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_revealView.sidebarView pushView:tableView animated:NO];
    _revealView.contentView.navigationItem.title = @"Pages";
    
    // Construct a toggle button for our contentView and add into it
    //    UIButton *toggleButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //    {
    //        [toggleButton setTitle:@"Toggle" forState:UIControlStateNormal];
    //        [toggleButton sizeToFit];
    //        toggleButton.frame = CGRectOffset(toggleButton.frame, 4, 50);
    //        [toggleButton addTarget:self action:@selector(toggleButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    //    }
    //    [_revealView.contentView addSubview:toggleButton];
    
    _revealView.contentView.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(toggleButtonPressed:)];
    
    [self.view addSubview:_revealView];
    
    
    
    
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

- (void)toggleButtonPressed:(id)sender {
    [_revealView revealSidebar: ! [_revealView isSidebarShowing]];
}

- (void)pushContentView:(id)sender {
    UIView *subview = [[UIView alloc] initWithFrame:CGRectZero];
    subview.backgroundColor = [UIColor blueColor];
    subview.title           = @"Pushed Subview";
    [_revealView.contentView pushView:subview animated:YES];
    
}

#pragma mark Helper

- (void)simulateDidSucceedFetchingDatasource:(JTTableViewDatasource *)datasource {
    NSString *url = [datasource.sourceInfo objectForKey:@"url"];
    if ([url isEqualToString:@"root"]) {
        [datasource configureSingleSectionWithArray:
         [NSArray arrayWithObjects:
          
          
          [JTTableViewCellModalSimpleType modalWithTitle:@"Page1" type:JTTableRowTypePushContentView],
          [JTTableViewCellModalSimpleType modalWithTitle:@"Page2" type:JTTableRowTypePushContentView],
          [JTTableViewCellModalSimpleType modalWithTitle:@"Page3" type:JTTableRowTypePushContentView],
          
          nil]
         ];
    } else if ([url isEqualToString:@"push"]) {
        [datasource configureSingleSectionWithArray:
         [NSArray arrayWithObject:
          [JTTableViewCellModalSimpleType modalWithTitle:@"Back" type:JTTableRowTypeBack]
          ]
         ];
    } else {
        NSAssert(NO, @"not handled!", nil);
    }
}

- (void)loadDatasourceSection:(JTTableViewDatasource *)datasource {
    [self performSelector:@selector(simulateDidSucceedFetchingDatasource:)
               withObject:datasource
               afterDelay:1];
}

@end


@implementation DemoHtml (UITableView)

- (BOOL)datasourceShouldLoad:(JTTableViewDatasource *)datasource {
    if ([datasource.sourceInfo objectForKey:@"url"]) {
        [self loadDatasourceSection:datasource];
        return YES;
    } else {
        return NO;
    }
}

- (UITableViewCell *)datasource:(JTTableViewDatasource *)datasource tableView:(UITableView *)tableView cellForObject:(NSObject *)object {
    if ([object conformsToProtocol:@protocol(JTTableViewCellModalLoadingIndicator)]) {
        static NSString *cellIdentifier = @"loadingCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [JTTableViewCellFactory loaderCellWithIdentifier:cellIdentifier];
        }
        return cell;
    } else if ([object conformsToProtocol:@protocol(JTTableViewCellModal)]) {
        static NSString *cellIdentifier = @"titleCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.textLabel.text = [(id <JTTableViewCellModal>)object title];
        return cell;
    } else if ([object conformsToProtocol:@protocol(JTTableViewCellModalCustom)]) {
        id <JTTableViewCellModalCustom> custom = (id)object;
        JTTableViewDatasource *datasource = (JTTableViewDatasource *)[[custom info] objectForKey:@"datasource"];
        if (datasource) {
            static NSString *cellIdentifier = @"datasourceCell";
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = [[custom info] objectForKey:@"title"];
            return cell;
        }
    }
    return nil;
}

- (void)datasource:(JTTableViewDatasource *)datasource tableView:(UITableView *)tableView didSelectObject:(NSObject *)object {
    if ([object conformsToProtocol:@protocol(JTTableViewCellModalCustom)]) {
        id <JTTableViewCellModalCustom> custom = (id)object;
        JTTableViewDatasource *datasource = (JTTableViewDatasource *)[[custom info] objectForKey:@"datasource"];
        if (datasource) {
            UITableView *tableView = [[UITableView alloc] initWithFrame:_revealView.sidebarView.bounds];
            tableView.delegate   = datasource;
            tableView.dataSource = datasource;
            tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            [_revealView.sidebarView pushView:tableView animated:YES];
        }
    } else if ([object conformsToProtocol:@protocol(JTTableViewCellModalSimpleType)]) {        
        switch ([(JTTableViewCellModalSimpleType *)object type]) {
            case JTTableRowTypeBack:{
                [_revealView.sidebarView popViewAnimated:YES];
                UITableView *tableView = (UITableView *)[_revealView.sidebarView topView];
                [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
                break;
            }
            case JTTableRowTypePushContentView:
            {
                UIView *view = [[UIView alloc] init];
                
                //view.backgroundColor = [UIColor redColor];
                
                // Create a push button to demonstrate pushing subviews in the main content view
                UIButton *pushButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                [pushButton setTitle:@"aaaPush" forState:UIControlStateNormal];
                [pushButton addTarget:self action:@selector(pushContentView:) forControlEvents:UIControlEventTouchUpInside];
                [pushButton sizeToFit];
                
                NSString *selectedTitle = [(JTTableViewCellModalSimpleType *)object title];
                
                if (selectedTitle == @"Page1"){
                    
                     viewController = [CDVViewController new];
                    viewController.startPage = @"test.html";
                    viewController.view.frame = CGRectMake(0, 0, 320, 480);
                    [view addSubview:viewController.view];
                    //UIWebView *webView1 = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 1024, 700)];
                    //[view addSubview:webView1];
                    //webView1.alpha = 1.0;
                    //webView1.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
                    //[webView1 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.google.com"]]];                    
                    
                    //[webView1 loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Page1" ofType:@"html"]isDirectory:NO]]];
                    //webView1.scalesPageToFit = YES;
                    
                }
                else if (selectedTitle == @"Page2"){
                    UIWebView *webView1 = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 1024, 700)];
                    [view addSubview:webView1];
                    webView1.alpha = 1.0;
                    webView1.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
                    //[webView1 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.google.com"]]];
                    
                    [webView1 loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Page2" ofType:@"html"]isDirectory:NO]]];
                    webView1.scalesPageToFit = YES;
                
                }
                else if (selectedTitle == @"Page3"){
                    UIWebView *webView1 = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 1024, 700)];
                    [view addSubview:webView1];
                    webView1.alpha = 1.0;
                    webView1.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
                    //[webView1 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.google.com"]]];
                    
                    [webView1 loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Page3" ofType:@"html"]isDirectory:NO]]];
                    webView1.scalesPageToFit = YES;
                    
                }
                
                //NSLog(@"%@",[(JTTableViewCellModalSimpleType *)object title]);
                //[view addSubview:pushButton];
                
                //view.title = [(JTTableViewCellModalSimpleType *)object title];
                //[_revealView.contentView setRootView:view];
                [_revealView.contentView setRootView:view];
                [_revealView revealSidebar:NO];
                
            }
            
            default:
                break;
        }
    }
}

- (void)datasource:(JTTableViewDatasource *)datasource sectionsDidChanged:(NSArray *)oldSections {
    [(UITableView *)[_revealView.sidebarView topView] reloadData];
    
}




@end
