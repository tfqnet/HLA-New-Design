//
//  Summary.h
//  iMobile Planner
//
//  Created by Erza on 6/18/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SummaryDelegate
-(void)selectedMenu:(NSString*)menu;
@end

@interface Summary : UITableViewController {
    id <SummaryDelegate> _delegate;
}

@property (nonatomic,strong) id <SummaryDelegate> delegate;

@end
