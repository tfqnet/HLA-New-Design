//
//  eAppMenu.m
//  iMobile Planner
//
//  Created by shawal sapuan on 7/12/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import "eAppMenu.h"
#import "ColorHexCode.h"
#import "MaineApp.h"
#import "SubDetails.h"
#import "MasterMenuEApp.h"

@interface eAppMenu ()

@end

@implementation eAppMenu
@synthesize eAppsVC,getSI,items,getEAPP;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    items = [[NSMutableArray alloc] initWithObjects:@"Select SI", @"Select Policy Owner", @"Select eCFF",@"e-Application",@"e-Signature",nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    cell.textLabel.text = [items objectAtIndex:indexPath.row];
    
    if (getSI && indexPath.row == 0) {
        
        cell.detailTextLabel.text = [self.getSI description];
        UIImageView *imgIcon2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconComplete.png"]];
        imgIcon2.frame = CGRectMake(885, 8, 30, 30);
        [cell.contentView addSubview:imgIcon2];
        
    }
    else {
        cell.detailTextLabel.text = @"";
        UIImageView *imgIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconNotComplete.png"]];
        imgIcon.frame = CGRectMake(885, 8, 30, 30);
        [cell.contentView addSubview:imgIcon];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        UIStoryboard *nextStoryboard = [UIStoryboard storyboardWithName:@"NewStoryboard" bundle:Nil];
        
        self.eAppsVC = [nextStoryboard instantiateViewControllerWithIdentifier:@"eAppList"];
        self.eAppsVC.modalPresentationStyle = UIModalPresentationFullScreen;
        self.eAppsVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentModalViewController:self.eAppsVC animated:NO];
//        self.eAppsVC.view.superview.frame = CGRectMake(0, 50, 748, 974);
    }
    
    else if (indexPath.row == 1) {
        
        UIStoryboard *secondStoryboard = [UIStoryboard storyboardWithName:@"LynnStoryboard" bundle:Nil];
        SubDetails *zzz = [secondStoryboard instantiateViewControllerWithIdentifier:@"subDataScreen"];
        zzz.modalPresentationStyle = UIModalPresentationPageSheet;
        zzz.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentModalViewController:zzz animated:NO];
        
        secondStoryboard = nil, zzz = nil;
    }
    
    else if (indexPath.row == 3) {
        
        /*
        UIStoryboard *secondStoryboard = [UIStoryboard storyboardWithName:@"NewStoryboard" bundle:Nil];
        MaineApp *zzz= [secondStoryboard instantiateViewControllerWithIdentifier:@"maineApp"];
        zzz.modalPresentationStyle = UIModalPresentationFullScreen;
        zzz.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        zzz.IndexTab = 1;
        zzz.getMenu = @"eAPP";
        [self presentViewController:zzz animated:NO completion:Nil];
        zzz = Nil, secondStoryboard = nil; */
        
        UIStoryboard *Storyboard = [UIStoryboard storyboardWithName:@"NewStoryboard" bundle:Nil];
        MasterMenuEApp *main = [Storyboard instantiateViewControllerWithIdentifier:@"eAppMaster"];
        main.modalPresentationStyle = UIModalPresentationFullScreen;
        main.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentViewController:main animated:NO completion:nil];
        
        Storyboard = nil, main = nil;
    }
}

- (void)viewDidUnload {
    [self setMyTableView:nil];
    [super viewDidUnload];
}
- (IBAction)ActionClose:(id)sender
{
    UIStoryboard *secondStoryboard = [UIStoryboard storyboardWithName:@"NewStoryboard" bundle:Nil];
    MaineApp *zzz= [secondStoryboard instantiateViewControllerWithIdentifier:@"maineApp"];
    zzz.modalPresentationStyle = UIModalPresentationFullScreen;
    self.eAppsVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    zzz.IndexTab = 1;
    [self presentViewController:zzz animated:NO completion:Nil];
    zzz = Nil, secondStoryboard = nil;
}
@end
