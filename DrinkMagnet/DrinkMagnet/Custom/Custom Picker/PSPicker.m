//
//  PSPicker.m
//  CustomPicker
//
//  Created by Puneet Sharma on 17/09/12.
//  Copyright (c) 2012 puneet94174@yahoo.co.in. All rights reserved.
//

#import "PSPicker.h"

@implementation PSPicker

@synthesize delegate,customPicker;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        customPicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
        customPicker.date = [NSDate date];
        customPicker.datePickerMode = UIDatePickerModeTime;
        [customPicker addTarget:self action:@selector(pickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        
        CGSize pickerSize = [customPicker sizeThatFits:CGSizeZero];
        
        UIView *pickerTransformView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, pickerSize.width, pickerSize.height)];
        pickerTransformView.transform = CGAffineTransformMakeScale(0.5f, 0.5f);
        [pickerTransformView addSubview:customPicker];
        [self addSubview:pickerTransformView];
        [pickerTransformView release];
        
        
        //[self addSubview:customPicker];
        //[customPicker release];
        
    }
    return self;
}


-(void)pickerValueChanged:(id)sender
{
    /*UIDatePicker *picker = (UIDatePicker*)sender;    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"h:mm a"];
    
    NSString *currentDateNTime = [NSString stringWithString:[df stringFromDate:picker.date]];
    [df release];*/
    
    if (self.delegate && [self.delegate performSelector:@selector(getPickerValue:)]) {
        [self.delegate getPickerValue:self];
    }
}

-(void)setPickerMode:(UIDatePickerMode)pickerType
{
    customPicker.datePickerMode = pickerType;
}

-(void)dealloc
{
    [super dealloc];
}
@end
