//
//  PopOverFundViewController.h
//  iMobile Planner
//
//  Created by infoconnect on 7/9/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PopOverFundViewController;
@protocol FundListDelegate
-(void)Fundlisting:(PopOverFundViewController *)inController andDesc:(NSString *)aaDesc;
@end

@interface PopOverFundViewController : UITableViewController{
	    id <FundListDelegate> delegate;
}

@property (retain, nonatomic) NSMutableArray *ListOfFund;
@property (nonatomic,strong) id <FundListDelegate> delegate;

@property (readonly) NSString *selectedDesc;

@end
