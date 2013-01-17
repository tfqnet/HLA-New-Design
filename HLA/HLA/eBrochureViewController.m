//
//  eBrochureViewController.m
//  HLA Ipad
//
//  Created by infoconnect on 1/16/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import "eBrochureViewController.h"

@interface eBrochureViewController ()

@end

@implementation eBrochureViewController
@synthesize outletWebview,fileName;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    NSString *pdfFile = [NSString stringWithFormat:@"%@",[self.fileName description]];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:pdfFile ofType:@"pdf"];
    NSURL *targetURL = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    [outletWebview setScalesPageToFit:YES];
    [outletWebview loadRequest:request];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        return YES;
    }
    else{
        return  NO;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    [self setOutletWebview:nil];
    [super viewDidUnload];
}
@end
