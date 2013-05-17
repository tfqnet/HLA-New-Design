//
//  CarouselViewController.h
//  HLA Ipad
//
//  Created by Md. Nazmus Saadat on 10/10/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"

@protocol CarouselDelegate
- (void)PresentMain;
@end


@interface CarouselViewController : UIViewController<iCarouselDataSource, iCarouselDelegate, NSXMLParserDelegate>{
	id<CarouselDelegate> _delegate;
}

@property (nonatomic, strong) id<CarouselDelegate> delegate;
@property (weak, nonatomic) IBOutlet iCarousel *outletCarousel;
@property(strong) NSString *previousElementName;
@property(strong) NSString *elementName;
@property (nonatomic, retain) NSString *getInternet;
@property (nonatomic, retain) NSString *getValid;
@property (nonatomic, retain) NSString *ErrorMsg;
@property (nonatomic, assign) int indexNo;


- (IBAction)btnExit:(id)sender;

@end
