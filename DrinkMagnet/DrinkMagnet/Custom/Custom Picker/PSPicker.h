//
//  PSPicker.h
//  CustomPicker
//
//  Created by Puneet Sharma on 17/09/12.
//  Copyright (c) 2012 puneet94174@yahoo.co.in. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PSPickerDelegate ;

@interface PSPicker : UIView{
    
    UIDatePicker *customPicker;
    id <PSPickerDelegate>delegate;
}

-(void)setPickerMode:(UIDatePickerMode)pickerType;

@property (nonatomic, retain) UIDatePicker *customPicker;
@property (nonatomic, assign) id <PSPickerDelegate>delegate;

@end

@protocol PSPickerDelegate <NSObject>

-(void)getPickerValue : (PSPicker*)picker;

@end
