//
//  eAppMenu.h
//  iMobile Planner
//
//  Created by shawal sapuan on 7/12/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "eAppsListing.h"

@interface eAppMenu : UIViewController {
    eAppsListing *_eAppsVC;
}


@property (strong, nonatomic) IBOutlet UITableView *myTableView;

@property (nonatomic, retain) eAppsListing *eAppsVC;
@property (nonatomic,strong) id getSI;
@property (nonatomic,strong) id getEAPP;

@property (strong, nonatomic) NSMutableArray *items;

- (IBAction)ActionClose:(id)sender;



@end
