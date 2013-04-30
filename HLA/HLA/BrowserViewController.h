//
//  BrowserViewController.h
//  iMobile Planner
//
//  Created by infoconnect on 4/9/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface BrowserViewController : UIViewController<MFMailComposeViewControllerDelegate>
{
	UIBarButtonItem *email;
	UIBarButtonItem *print;
@private // Instance variables
	UIPrintInteractionController *printInteraction;
}
@property (nonatomic,strong) NSString *SIFilePath;
- (id)initWithFilePath:(NSString *)fullFilePath;
@end
