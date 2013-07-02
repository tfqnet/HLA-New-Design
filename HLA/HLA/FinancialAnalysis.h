//
//  FinancialAnalysis.h
//  iMobile Planner
//
//  Created by Erza on 6/18/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FinancialAnalysis;
@protocol FinancialAnalysisDelegate
-(void)swipeToRetirement;
@end

@interface FinancialAnalysis : UIViewController {
    id <FinancialAnalysisDelegate> _delegate;
}

- (IBAction)swipeNext:(id)sender;

@property (nonatomic,strong) id <FinancialAnalysisDelegate> delegate;

@end
