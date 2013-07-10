//
//  Summary.m
//  iMobile Planner
//
//  Created by Erza on 6/18/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import "Summary.h"
#import "ColorHexCode.h"

@interface Summary ()

@end

@implementation Summary
@synthesize delegate = _delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ColorHexCode *CustomColor = [[ColorHexCode alloc]init ];
    self.navigationController.navigationBar.tintColor = [CustomColor colorWithHexString:@"A9BCF5"];
    
    CGRect frame = CGRectMake(0, 0, 400, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"TreBuchet MS" size:20];
    label.font = [UIFont boldSystemFontOfSize:20];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [CustomColor colorWithHexString:@"234A7D"];
    label.text = @"Summary";
    self.navigationItem.titleView = label;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"click sec:%d path:%d",indexPath.section, indexPath.row);
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            NSString *aa = @"1";
            [_delegate selectedMenu:aa];
            NSLog(@"go sub1");
        }
        if (indexPath.row == 1) {
            [_delegate selectedMenu:@"2"];
        }
        if (indexPath.row == 2) {
            [_delegate selectedMenu:@"3"];
        }
        if (indexPath.row == 4) {
            [_delegate selectedMenu:@"4"];
        }
        if (indexPath.row == 5) {
            [_delegate selectedMenu:@"5"];
        }
        if (indexPath.row == 6) {
            [_delegate selectedMenu:@"6"];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
  
    [super viewDidUnload];
}

@end
