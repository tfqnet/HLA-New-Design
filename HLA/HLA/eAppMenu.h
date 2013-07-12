//
//  eAppMenu.h
//  iMobile Planner
//
//  Created by shawal sapuan on 7/12/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "eAppsListing.h"

@interface eAppMenu : UITableViewController {
    eAppsListing *_eAppsVC;
}

@property (nonatomic, retain) eAppsListing *eAppsVC;

@end
