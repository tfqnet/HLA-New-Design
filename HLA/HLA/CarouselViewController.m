//
//  CarouselViewController.m
//  HLA Ipad
//
//  Created by Md. Nazmus Saadat on 10/10/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import "CarouselViewController.h"
#import "SIListing.h"
#import "ProspectListing.h"
#import "setting.h"
#import "MainScreen.h"
#import "Login.h"
#import "NewLAViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "eBrochureViewController.h"
#import "eBrochureListingViewController.h"

const int numberOfModule = 4;

@interface CarouselViewController ()<UIActionSheetDelegate>

@end

@implementation CarouselViewController
@synthesize outletCarousel;

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
    outletCarousel.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg11.jpg"]];
    self.view.backgroundColor = [UIColor clearColor];
    outletCarousel.dataSource = self;
    outletCarousel.delegate = self;
    outletCarousel.type = iCarouselTypeRotary;
    // Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setOutletCarousel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if (interfaceOrientation==UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationLandscapeLeft)
        return YES;
    
    return NO;

}

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return numberOfModule;
}


- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    /*
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    [gradientLayer setFrame:button.frame];
    [button.layer addSublayer:gradientLayer];
     */
 
    
    button.frame = CGRectMake(0, 0, 450.0f, 400.0f);
    
    //[button setTitle:[NSString stringWithFormat:@"%i", index] forState:UIControlStateNormal];
    if (index % numberOfModule == 1) {
        //[button setTitle:[NSString stringWithFormat:@"Setting", index] forState:UIControlStateNormal];    
        //NSString *filename = [NSString stringWithFormat:@"btn_setting_home"];
        //UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:filename ofType:@"PNG"]];
        [button setBackgroundImage:[UIImage imageNamed:@"20130108Settings.png"] forState:UIControlStateNormal];  
    }
    else if (index % numberOfModule == 0) {
        //[button setTitle:[NSString stringWithFormat:@"Prospect Listing", index] forState:UIControlStateNormal];
        //NSString *filename = [NSString stringWithFormat:@"btn_prospect_home"];
        //UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:filename ofType:@"PNG"]];
        [button setBackgroundImage:[UIImage imageNamed:@"20130108Prospect.png"] forState:UIControlStateNormal];
    }
    else if (index % numberOfModule == 2) {
        //[button setTitle:[NSString stringWithFormat:@"SI Listing", index] forState:UIControlStateNormal];
        //NSString *filename = [NSString stringWithFormat:@"btn_brochure_home"];
        //UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:filename ofType:@"PNG"]];
        [button setBackgroundImage:[UIImage imageNamed:@"20130108eBrochure.png" ] forState:UIControlStateNormal];
    }
    else if (index % numberOfModule == 3) {
        //[button setTitle:[NSString stringWithFormat:@"New SI", index] forState:UIControlStateNormal];
        //NSString *filename = [NSString stringWithFormat:@"btn_SI_home"];
        //UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:filename ofType:@"PNG"]];
        [button setBackgroundImage:[UIImage imageNamed:@"20130108SalesIllustration.png" ] forState:UIControlStateNormal];  
    }
    /*
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    NSString *filename = [NSString stringWithFormat:@"IMG_00%i", (index+39)];
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:filename ofType:@"PNG"]];
    */
    //[button setBackgroundImage:image forState:UIControlStateNormal];
    
    
    
    button.titleLabel.font = [button.titleLabel.font fontWithSize:50];
    [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    return button;

}

- (void)buttonTapped:(UIButton *)sender
{
    /*
    [[[[UIAlertView alloc] initWithTitle:@"Button Tapped"
                                 message:[NSString stringWithFormat:@"You tapped button number %i", [outletCarousel indexOfItemView:sender]]
                                delegate:nil
                       cancelButtonTitle:@"OK"
                       otherButtonTitles:nil] autorelease] show];
    */
    AppDelegate *MenuOption= (AppDelegate*)[[UIApplication sharedApplication] delegate ];
    
    if ([outletCarousel indexOfItemView:sender] % numberOfModule == 1) { //setting
        setting *zzz= [self.storyboard instantiateViewControllerWithIdentifier:@"Setting"];
        zzz.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:zzz animated:NO completion:Nil];
        //[self.navigationController pushViewController:zzz animated:YES];
    }
    
    else if ([outletCarousel indexOfItemView:sender] % numberOfModule == 0) { //prospect
        MainScreen *zzz= [self.storyboard instantiateViewControllerWithIdentifier:@"Main"];
        zzz.modalPresentationStyle = UIModalPresentationFullScreen;
        zzz.IndexTab = MenuOption.ProspectListingIndex;
        [self presentViewController:zzz animated:NO completion:Nil];
        
    }
    
    else if ([outletCarousel indexOfItemView:sender] % numberOfModule == 2) {
        eBrochureListingViewController *BrochureListing = [self.storyboard instantiateViewControllerWithIdentifier:@"eBrochureListing"];
        BrochureListing.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:BrochureListing animated:NO completion:Nil];
        
    }
    
    else if ([outletCarousel indexOfItemView:sender] % numberOfModule == 3) {
        
        MainScreen *zzz= [self.storyboard instantiateViewControllerWithIdentifier:@"Main"];
        zzz.modalPresentationStyle = UIModalPresentationFullScreen;
        zzz.IndexTab = MenuOption.SIListingIndex;
        [self presentViewController:zzz animated:NO completion:Nil];
        
        /*
        //--edited by bob
        NewLAViewController *NewLAPage  = [self.storyboard instantiateViewControllerWithIdentifier:@"LAView"];
        MainScreen *MainScreenPage = [self.storyboard instantiateViewControllerWithIdentifier:@"Main"];
        MainScreenPage.IndexTab = 3;
        NewLAPage.modalPresentationStyle = UIModalPresentationPageSheet;
        
        [self presentViewController:MainScreenPage animated:YES completion:^(){
            [MainScreenPage presentModalViewController:NewLAPage animated:NO];
            NewLAPage.view.superview.bounds =  CGRectMake(-300, 0, 1024, 748);
        }];
         */
        
    }
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self updateDateLogout];
        
    }
}

-(void)updateDateLogout
{
    NSString *databasePath;
    sqlite3 *contactDB;
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
    
    Login *mainLogin = [self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
    mainLogin.modalPresentationStyle = UIModalPresentationFullScreen;
    mainLogin.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentModalViewController:mainLogin animated:YES];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"UPDATE User_Profile SET LastLogoutDate= \"%@\" WHERE IndexNo=\"%d\"",dateString, 1];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"date update!");
                
            } else {
                NSLog(@"date update Failed!");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
    
    exit(0);
}

- (IBAction)btnExit:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] 
                          initWithTitle: NSLocalizedString(@"Exit",nil)
                          message: NSLocalizedString(@"Are you sure you want to exit?",nil)
                          delegate: self
                          cancelButtonTitle: NSLocalizedString(@"Yes",nil)
                          otherButtonTitles: NSLocalizedString(@"No",nil), nil];
    
    [alert show ];
}
@end
