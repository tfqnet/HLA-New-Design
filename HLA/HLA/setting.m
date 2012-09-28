//
//  setting.m
//  HLA Ipad
//
//  Created by Md. Nazmus Saadat on 9/28/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import "setting.h"
#import "ChangePassword.h"

@interface setting ()

@end

@implementation setting
@synthesize myTableView;
@synthesize RightView;
@synthesize ListOfSubMenu;
@synthesize indexNo;

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
    ListOfSubMenu = [[NSMutableArray alloc] initWithObjects:@"User Profile", @"Security Question", @"Account Setting", @"Change Password", nil ];
    [self.view addSubview:myTableView];
}

- (void)viewDidUnload
{
    [self setMyTableView:nil];
    [self setRightView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;   
}

- (NSInteger)tableView:(UITableView *)myTableView numberOfRowsInSection:(NSInteger)section {
    
    return ListOfSubMenu.count;
}

- (UITableViewCell *)tableView:(UITableView *)myTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [self.myTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    cell.textLabel.text = [ListOfSubMenu objectAtIndex:indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{   /*
    ChangePassword* zzz = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangePwd"];
    zzz.userID = self.indexNo;
    
    [self.RightView addSubview:zzz.view];
    */
    ChangePassword *changePwdView = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangePwd"];
    changePwdView.modalPresentationStyle = UIModalPresentationFormSheet;
    changePwdView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    changePwdView.userID = self.indexNo;
    [self presentModalViewController:changePwdView animated:YES];
    changePwdView.view.superview.bounds = CGRectMake(-50, 0, 550, 600);
}

@end
