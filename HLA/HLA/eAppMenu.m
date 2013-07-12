//
//  eAppMenu.m
//  iMobile Planner
//
//  Created by shawal sapuan on 7/12/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import "eAppMenu.h"


@interface eAppMenu ()

@end

@implementation eAppMenu
@synthesize eAppsVC;


- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"index:%d, section:%d",indexPath.row,indexPath.section);
    if (indexPath.row == 0) {
        
        UIStoryboard *nextStoryboard = [UIStoryboard storyboardWithName:@"NewStoryboard" bundle:Nil];
        /*
        if (_eAppsVC == Nil) {
            self.eAppsVC = [nextStoryboard instantiateViewControllerWithIdentifier:@"eAppList"];
        }
        [self.navigationController pushViewController:_eAppsVC animated:YES];
        _eAppsVC.navigationItem.title = @"Sales Illustration Listing"; */
        
        self.eAppsVC = [nextStoryboard instantiateViewControllerWithIdentifier:@"eAppList2"];
        self.eAppsVC.modalPresentationStyle = UIModalPresentationPageSheet;
        self.eAppsVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentModalViewController:self.eAppsVC animated:NO];
        self.eAppsVC.view.superview.frame = CGRectMake(0, 50, 748, 974);
    }
}

@end
