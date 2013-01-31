//
//  PinCodeViewController.h
//  DrinkMagnet
//
//  Created by Puneet Sharma on 30/09/12.
//  Copyright (c) 2012 WinkApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PinCodeDelegate <NSObject>

-(void)pincodeEntered:(NSString*)pin;

@end

@interface PinCodeViewController : UIViewController<UITextFieldDelegate>
{
    id<PinCodeDelegate> delegate;
}

@property (assign, nonatomic) id<PinCodeDelegate> delegate;
@property (retain, nonatomic) IBOutlet UITextField *pincodeField;
@property (retain, nonatomic) IBOutlet UILabel *code1;
@property (retain, nonatomic) IBOutlet UILabel *code2;
@property (retain, nonatomic) IBOutlet UILabel *code3;
@property (retain, nonatomic) IBOutlet UILabel *code4;
@property (retain, nonatomic) IBOutlet UILabel *code5;
@end
