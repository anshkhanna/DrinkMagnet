//
//  AddSpecialView.m
//  DrinkMagnet
//
//  Created by Puneet Sharma on 20/09/12.
//  Copyright (c) 2012 WinkApps. All rights reserved.
//

#import "AddSpecialView.h"

@implementation AddSpecialView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // Add Special View 
        
        self.backgroundColor = [UIColor whiteColor];
        
        UIImageView *topBar = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"BarDetails.png"]];
        topBar.frame = CGRectMake(0, 0, 310, 60);
        [self addSubview:topBar];
        [topBar release];
        
        UIButton *btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnClose setImage:[UIImage imageNamed:@"cross.png"] forState:UIControlStateNormal];
        [btnClose addTarget:self action:@selector(closeView:) forControlEvents:UIControlEventTouchUpInside];
        btnClose.frame = CGRectMake(292, 0, 16, 16);
        [self addSubview:btnClose];
        
        UIButton *btnSelectBarType = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnSelectBarType setImage:[UIImage imageNamed:@"select.png"] forState:UIControlStateNormal];
        btnSelectBarType.contentMode = UIViewContentModeScaleAspectFit;
        btnSelectBarType.frame = CGRectMake(20, 40, 300, 30);
        [self addSubview:btnSelectBarType];
        
        UITextField *txtNameOfSpecial = [[UITextField alloc]initWithFrame:CGRectMake(20, 80, 280, 30)];
        txtNameOfSpecial.borderStyle = UITextBorderStyleRoundedRect;
        txtNameOfSpecial.placeholder = @"Name..";
        txtNameOfSpecial.delegate = self;
        [self addSubview:txtNameOfSpecial];
        [txtNameOfSpecial release];
        
        UITextField *txtPhoneSpecial = [[UITextField alloc]initWithFrame:CGRectMake(20, 120, 280, 30)];
        txtPhoneSpecial.borderStyle = UITextBorderStyleRoundedRect;
        txtPhoneSpecial.placeholder = @"Phone..";
        txtPhoneSpecial.delegate = self;
        [self addSubview:txtPhoneSpecial];
        [txtPhoneSpecial release];
        
        UIButton *btnuseGps = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btnuseGps.frame = CGRectMake(20, 160, 80, 70);
        [btnuseGps addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
        [btnuseGps setTitle:@"Use GPS" forState:UIControlStateNormal];
        [btnuseGps setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addSubview:btnuseGps];
        
        UITextField *txtSpreetAddress = [[UITextField alloc]initWithFrame:CGRectMake(110, 160, 190, 30)];
        txtSpreetAddress.borderStyle = UITextBorderStyleRoundedRect;
        txtSpreetAddress.placeholder = @"Address..";
        txtSpreetAddress.delegate = self;
        [self addSubview:txtSpreetAddress];
        [txtSpreetAddress release];
        
        UITextField *txtZipCode = [[UITextField alloc]initWithFrame:CGRectMake(110, 200, 190, 30)];
        txtZipCode.borderStyle = UITextBorderStyleRoundedRect;
        txtZipCode.placeholder = @"ZipCode..";
        txtZipCode.delegate = self;
        [self addSubview:txtZipCode];
        [txtZipCode release];
        
        UIImageView *midBar = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"BarDetails.png"]];
        midBar.frame = CGRectMake(0, 240, 310, 60);
        [self addSubview:midBar];
        [midBar release];
        
        UITextField *txtSpecial = [[UITextField alloc]initWithFrame:CGRectMake(20, 280, 280, 30)];
        txtSpecial.borderStyle = UITextBorderStyleRoundedRect;
        txtSpecial.placeholder = @"Special..";
        txtSpecial.delegate = self;
        [self addSubview:txtSpecial];
        [txtSpecial release];
        
        UILabel *startTime = [[UILabel alloc]initWithFrame:CGRectMake(20, 322, 40, 30)];
        startTime.text = @"Start Time";
        [startTime setFont:[UIFont fontWithName:@"Helvetica" size:12]];
        startTime.numberOfLines = 2;
        [self addSubview:startTime];
        [startTime release];
        
        UIButton *btnStartTime = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnStartTime setTitle:@"7:00 PM" forState:UIControlStateNormal];
        btnStartTime.frame = CGRectMake(60, 320, 70, 40);
        [btnStartTime addTarget:self action:@selector(showTimeSlectionView:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnStartTime];
        
        UILabel *endTime = [[UILabel alloc]initWithFrame:CGRectMake(160, 322, 40, 30)];
        endTime.text = @"End Time";
        [endTime setFont:[UIFont fontWithName:@"Helvetica" size:12]];
        endTime.numberOfLines = 2;
        [self addSubview:endTime];
        [endTime release];
        
        UIButton *btnEndTime = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnEndTime setTitle:@"7:00 PM" forState:UIControlStateNormal];
        btnEndTime.frame = CGRectMake(200, 320, 70, 40);
        [btnEndTime addTarget:self action:@selector(showTimeSlectionView:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnEndTime];
        
        UISegmentedControl *daysSegment = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"Mon",@"Tue",@"Wed",@"Thu",@"Fri",@"Sat",@"Sun", nil]];
        daysSegment.frame = CGRectMake(5, 370, 300, 50);
        [self addSubview:daysSegment];
        [daysSegment release];
        
        UIButton *btnSubmit = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnSubmit setTitle:@"Submit" forState:UIControlStateNormal];
        btnSubmit.frame = CGRectMake(115, 430, 70, 40);
        btnSubmit.backgroundColor = [UIColor colorWithRed:216/255.0f green:216/255.0f blue:216/255.0f alpha:1];
        [self addSubview:btnSubmit];
        
    }
    return self;
}

-(void)closeView:(id)sender
{
    if (delegate && [delegate respondsToSelector:@selector(dismissAddView:)]) {
        [delegate dismissAddView:self];
    }
}

-(void)showTimeSlectionView:(id)sender
{
    UIView *timeSelectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 420)];
    timeSelectionView.backgroundColor = [UIColor colorWithRed:216/255.0f green:216/255.0f blue:216/255.0f alpha:.8];
    self.scrollEnabled =NO;
    timeSelectionView.tag = 102;
    [self addSubview:timeSelectionView];
    [timeSelectionView release];
    
    UILabel *lblstartTime = [[UILabel alloc]initWithFrame:CGRectMake(20, 80, 120, 40)];
    lblstartTime.text = @" HAPPY HOUR  START TIME";
    lblstartTime.textAlignment = UITextAlignmentCenter;
    lblstartTime.numberOfLines = 2;
    lblstartTime.textColor =[UIColor lightGrayColor];
    [timeSelectionView addSubview:lblstartTime];
    [lblstartTime release];
    
    PSPicker *startTimePicker = [[PSPicker alloc]initWithFrame:CGRectMake(-80, 100, 200, 200)];
    startTimePicker.delegate = self;
    startTimePicker.userInteractionEnabled = YES;
    [startTimePicker setPickerMode:UIDatePickerModeTime];
    [timeSelectionView addSubview:startTimePicker];
    [startTimePicker release];
    
    UILabel *lblEndTime = [[UILabel alloc]initWithFrame:CGRectMake(180, 80, 120, 40)];
    lblEndTime.text = @" HAPPY HOUR  END TIME";
    lblEndTime.textAlignment = UITextAlignmentCenter;
    lblEndTime.numberOfLines = 2;
    lblEndTime.textColor =[UIColor lightGrayColor];
    [timeSelectionView addSubview:lblEndTime];
    [lblEndTime release];
    
    PSPicker *endTimePicker = [[PSPicker alloc]initWithFrame:CGRectMake(80, 100, 200, 200)];
    endTimePicker.delegate = self;
    [endTimePicker setPickerMode:UIDatePickerModeTime];
    [timeSelectionView addSubview:endTimePicker];
    [endTimePicker release];
    
    UIButton *btnSubmit = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnSubmit setTitle:@"SUBMIT" forState:UIControlStateNormal];
    btnSubmit.frame = CGRectMake(100, 330, 100, 50);
    btnSubmit.backgroundColor = [UIColor whiteColor];
    [btnSubmit setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [btnSubmit addTarget:self action:@selector(closeTimeSelectionView:) forControlEvents:UIControlEventTouchUpInside];
    [timeSelectionView addSubview:btnSubmit];
}

-(void)getPickerValue:(PSPicker *)picker
{
    NSLog(@"Get Picker Value");
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)closeTimeSelectionView:(id)sender
{
    UIView *view = [self viewWithTag:102];
    [UIView animateWithDuration:.25 animations:^{
        view.alpha = 0;
        self.scrollEnabled = YES;
    }];
    [view removeFromSuperview];
}



@end
