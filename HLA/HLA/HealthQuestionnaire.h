//
//  HealthQuestionnaire.h
//  iMobile Planner
//
//  Created by Erza on 6/18/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HealthQuestionnaireDelegate
-(void)swipeToHQ2;
@end

@interface HealthQuestionnaire : UIViewController{
    id <HealthQuestionnaireDelegate> _delegate;
}
- (IBAction)swipeNext:(id)sender;

@property (nonatomic,strong) id <HealthQuestionnaireDelegate> delegate;

@end
