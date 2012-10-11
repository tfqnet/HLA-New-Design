//
//  CarouselViewController.h
//  HLA Ipad
//
//  Created by Md. Nazmus Saadat on 10/10/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"

@interface CarouselViewController : UIViewController<iCarouselDataSource, iCarouselDelegate>

@property (weak, nonatomic) IBOutlet iCarousel *outletCarousel;


@end
