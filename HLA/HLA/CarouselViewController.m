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
	if (interfaceOrientation==UIInterfaceOrientationLandscapeRight)
    {
        return YES;
    }
    else {
        return NO;
    }

}

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return 4;
}


- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(0, 0, 400.0f, 400.0f);
    //[button setTitle:[NSString stringWithFormat:@"%i", index] forState:UIControlStateNormal];
    if (index % 4 == 0) {
        //[button setTitle:[NSString stringWithFormat:@"Setting", index] forState:UIControlStateNormal];    
        //NSString *filename = [NSString stringWithFormat:@"btn_setting_home"];
        //UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:filename ofType:@"PNG"]];
        [button setBackgroundImage:[UIImage imageNamed:@"btn_setting_home"] forState:UIControlStateNormal];  
    }
    else if (index % 4 == 1) {
        //[button setTitle:[NSString stringWithFormat:@"Prospect Listing", index] forState:UIControlStateNormal];
        //NSString *filename = [NSString stringWithFormat:@"btn_prospect_home"];
        //UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:filename ofType:@"PNG"]];
        [button setBackgroundImage:[UIImage imageNamed:@"btn_prospect_home"] forState:UIControlStateNormal];  
    }
    else if (index % 4 == 2) {
        //[button setTitle:[NSString stringWithFormat:@"SI Listing", index] forState:UIControlStateNormal];
        //NSString *filename = [NSString stringWithFormat:@"btn_brochure_home"];
        //UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:filename ofType:@"PNG"]];
        [button setBackgroundImage:[UIImage imageNamed:@"btn_brochure_home" ] forState:UIControlStateNormal];  
    }
    else if (index % 4 == 3) {
        //[button setTitle:[NSString stringWithFormat:@"New SI", index] forState:UIControlStateNormal];
        //NSString *filename = [NSString stringWithFormat:@"btn_SI_home"];
        //UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:filename ofType:@"PNG"]];
        [button setBackgroundImage:[UIImage imageNamed:@"btn_SI_home" ] forState:UIControlStateNormal];  
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
    if ([outletCarousel indexOfItemView:sender] % 4 == 0) { //setting
        setting *zzz= [self.storyboard instantiateViewControllerWithIdentifier:@"Setting"];
        zzz.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:zzz animated:YES completion:Nil];
        //[self.navigationController pushViewController:zzz animated:YES];
    }
    
    else if ([outletCarousel indexOfItemView:sender] % 4 == 1) { //prospect
        MainScreen *zzz= [self.storyboard instantiateViewControllerWithIdentifier:@"Main"];
        zzz.modalPresentationStyle = UIModalPresentationFullScreen;
        zzz.IndexTab = 1;
        [self presentViewController:zzz animated:YES completion:Nil];
        
    }
    
    else if ([outletCarousel indexOfItemView:sender] % 4 == 2) {
        /*
        MainScreen *zzz= [self.storyboard instantiateViewControllerWithIdentifier:@"Main"];
        zzz.modalPresentationStyle = UIModalPresentationFullScreen;
        zzz.IndexTab = 3;
        [self presentViewController:zzz animated:YES completion:Nil];
        */
    }
    
    else if ([outletCarousel indexOfItemView:sender] % 4 == 3) {
        MainScreen *zzz= [self.storyboard instantiateViewControllerWithIdentifier:@"Main"];
        zzz.modalPresentationStyle = UIModalPresentationFullScreen;
        zzz.IndexTab = 3;
        [self presentViewController:zzz animated:YES completion:Nil];
        
    }
}

@end
