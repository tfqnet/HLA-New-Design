//
//  HealthQuestionnaire2.h
//  iMobile Planner
//
//  Created by Erza on 7/4/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HealthQuestionnaire2Delegate
-(void)swipeToHQ3;
@end

@interface HealthQuestionnaire2 : UITableViewController {
     id <HealthQuestionnaire2Delegate> _delegate;
}
- (IBAction)swipeNext2:(id)sender;

@property (nonatomic,strong) id <HealthQuestionnaire2Delegate> delegate;

@end
