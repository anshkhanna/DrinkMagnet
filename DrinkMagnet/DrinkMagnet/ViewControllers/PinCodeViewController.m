//
//  PinCodeViewController.m
//  DrinkMagnet
//
//  Created by Puneet Sharma on 30/09/12.
//  Copyright (c) 2012 WinkApps. All rights reserved.
//

#import "PinCodeViewController.h"

@interface PinCodeViewController ()
-(void)dismissController;
@end

@implementation PinCodeViewController
@synthesize delegate;
@synthesize pincodeField;
@synthesize code1;
@synthesize code2;
@synthesize code3;
@synthesize code4;
@synthesize code5;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    pincodeField.keyboardAppearance = UIKeyboardAppearanceAlert;
    [pincodeField becomeFirstResponder];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidChange)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [pincodeField becomeFirstResponder];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [self setPincodeField:nil];
    [self setCode1:nil];
    [self setCode2:nil];
    [self setCode3:nil];
    [self setCode4:nil];
    [self setCode5:nil];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string 
{
    NSString *pincode = [textField text];
    pincode = [pincode stringByReplacingCharactersInRange:range withString:string];
    if(pincode.length > 5)
    {
        return NO;
    }
    
    return YES;
}

-(void)dismissController
{
    if (delegate && [delegate respondsToSelector:@selector(pincodeEntered:)]) 
    {
        [delegate pincodeEntered:pincodeField.text];
    }
    
    [self dismissModalViewControllerAnimated:YES];
}

-(void)textFieldDidChange
{
    NSString *text = pincodeField.text;
    NSUInteger count = text.length;
    
    int index;
    for(index=0; index<count; index++)
    {
        UILabel *label = (UILabel*)[self.view viewWithTag:index+2000];
        label.text = [NSString stringWithFormat:@"%c",[pincodeField.text characterAtIndex:index]];
    }
    
    for(int counter=index; counter<5; counter++)
    {
        UILabel *label = (UILabel*)[self.view viewWithTag:counter+2000];
        label.text = @"";
    }

    if(text.length == 5)
    [self performSelector:@selector(dismissController) withObject:nil afterDelay:0];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc 
{
    delegate = nil;
    [pincodeField release];
    [code1 release];
    [code2 release];
    [code3 release];
    [code4 release];
    [code5 release];
    [super dealloc];
}
@end
