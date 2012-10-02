//
//  DateViewController.m
//  HLA
//
//  Created by shawal sapuan on 9/25/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import "DateViewController.h"

@interface DateViewController ()

@end

@implementation DateViewController
@synthesize datePickerView;
@synthesize msgDate,msgAge,selectedStrDate,selectedStrAge,Age,ANB;
@synthesize delegate = _delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark - action
- (IBAction)dateChange:(id)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSString *pickerDate = [dateFormatter stringFromDate:[datePickerView date]];
    
    msgDate = [[NSString alloc] initWithFormat:@"%@",pickerDate];
}

- (IBAction)donePressed:(id)sender
{
    [self calculateAge];
}

-(void)calculateAge
{
    //format in year
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy"];
    NSString *currentYear = [dateFormatter stringFromDate:[NSDate date]];
    NSString *birthYear = [dateFormatter stringFromDate:[datePickerView date]];
    
    [dateFormatter setDateFormat:@"MM"];
    NSString *currentMonth = [dateFormatter stringFromDate:[NSDate date]];
    NSString *birthMonth = [dateFormatter stringFromDate:[datePickerView date]];
    
    [dateFormatter setDateFormat:@"dd"];
    NSString *currentDay = [dateFormatter stringFromDate:[NSDate date]];
    NSString *birthDay = [dateFormatter stringFromDate:[datePickerView date]];
    
    int yearN = [currentYear intValue];
    int yearB = [birthYear intValue];
    int monthN = [currentMonth intValue];
    int monthB = [birthMonth intValue];
    int dayN = [currentDay intValue];
    int dayB = [birthDay intValue];
    
    int ALB = yearN - yearB;
    int newALB;
    int newANB;
    
    if (yearN > yearB)
    {
        if (monthN < monthB) {
            newALB = ALB - 1;
        } else if (monthN == monthB && dayN < dayB) {
            newALB = ALB - 1;
        } else {
            newALB = ALB;
        }
        
        if (monthN > monthB) {
            newANB = ALB + 1;
        } else if (monthN == monthB && dayN >= dayB) {
            newANB = ALB + 1;
        } else {
            newANB = ALB;
        }
        msgAge = [[NSString alloc] initWithFormat:@"%d",newALB];
        Age = newALB;
        ANB = newANB;
    }
    else if (yearN == yearB)
    {
        if (monthN > monthB) {
            newALB = monthN - monthB;
            msgAge = [[NSString alloc] initWithFormat:@"%d months",newALB];
            
        } else if (monthN == monthB && dayB<dayN) {
            newALB = dayN - dayB;
            msgAge = [[NSString alloc] initWithFormat:@"%d days",newALB];
            if (newALB < 30) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Age must be at least 30 days." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
        Age = 0;
        ANB = 1;
    }
    
    if ((yearN<yearB)||(yearN==yearB && monthN<monthB)||(yearN==yearB && monthN==monthB && dayN<dayB)) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Entered date cannot be greater than today." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    } else {
        [_delegate datePick:self strDate:self.selectedStrDate strAge:self.selectedStrAge intAge:self.selectedIntAge intANB:self.selectedIntANB];
    }
}

-(NSString *)selectedStrDate
{
    return msgDate;
}

-(NSString *)selectedStrAge
{
    return msgAge;
}

-(int)selectedIntAge
{
    return Age;
}

-(int)selectedIntANB
{
    return ANB;
}

#pragma mark - memory
- (void)viewDidUnload
{
    [self setDelegate:nil];
    [self setDatePickerView:nil];
    [self setMsgDate:nil];
    [self setMsgAge:nil];
    [super viewDidUnload];
}

@end
