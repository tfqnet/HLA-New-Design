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


@interface CarouselViewController : UIViewController<iCarouselDataSource, iCarouselDelegate>{
	id<CarouselDelegate> _delegate;
}

@property (nonatomic, strong) id<CarouselDelegate> delegate;
@property (weak, nonatomic) IBOutlet iCarousel *outletCarousel;

- (IBAction)btnExit:(id)sender;

@end
