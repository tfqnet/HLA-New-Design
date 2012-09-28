//
//  UserProfile.m
//  HLA Ipad
//
//  Created by Md. Nazmus Saadat on 9/28/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import "UserProfile.h"
#import "ChangePassword.h"

@interface UserProfile ()

@end

@implementation UserProfile

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
	// Do any additional setup after loading the view.
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

- (IBAction)btnAction:(id)sender {
    ChangePassword *changePwdView = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangePwd"];
    changePwdView.modalPresentationStyle = UIModalPresentationFormSheet;
    changePwdView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    //changePwdView.userID = self.indexNo;
    changePwdView.userID = 1;
    [self presentModalViewController:changePwdView animated:YES];
    changePwdView.view.superview.bounds = CGRectMake(0, 0, 550, 600);
}
@end
