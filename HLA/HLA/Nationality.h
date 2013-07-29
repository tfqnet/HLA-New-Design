//
//  Nationality.h
//  iMobile Planner
//
//  Created by shawal sapuan on 7/29/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NatinalityDelegate
-(void)selectedCountry:(NSString *)theCountry;
@end

@interface Nationality : UITableViewController {
    id <NatinalityDelegate> _delegate;
}

@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) id <NatinalityDelegate> delegate;

@end
