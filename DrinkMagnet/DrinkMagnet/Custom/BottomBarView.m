#import "BottomBarView.h"
#import <QuartzCore/QuartzCore.h>
#import "HomeViewController.h"

#define SLIDE_UP_TAG    2012
#define NOW_TAG         2013
#define LATER_TAG       2014
#define ADD_TAG         2015

@interface BottomBarView()

-(void)initialize;

@end

@implementation BottomBarView

@synthesize delegate;

-(void)awakeFromNib
{
    [self initialize];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initialize];
    }
    return self;
}

-(void)initialize
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidChange)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
    
    self.backgroundColor = [UIColor blackColor];
    
    btnSlideUp = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSlideUp.frame = CGRectMake(0, 0, 80, 44);
    [btnSlideUp addTarget:self action:@selector(btnSlideUpPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btnSlideUp setImage:[UIImage imageNamed:@"Settings_Light.png"] forState:UIControlStateSelected];
    [btnSlideUp setImage:[UIImage imageNamed:@"Settings_Dark.png"] forState:UIControlStateNormal];
    [btnSlideUp setTag:SLIDE_UP_TAG];
    [self addSubview:btnSlideUp];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(setingsButtonPanned:)];
    //[btnSlideUp addGestureRecognizer:pan];
    [pan release];
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(setingsButtonSwiped:)];
    swipe.direction = UISwipeGestureRecognizerDirectionUp | UISwipeGestureRecognizerDirectionDown;
    [btnSlideUp addGestureRecognizer:swipe];
    [swipe release];
    
    btnNow = [UIButton buttonWithType:UIButtonTypeCustom];
    btnNow.frame = CGRectMake(80, 0, 80, 44);
    [btnNow addTarget:self action:@selector(btnNowPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btnNow setImage:[UIImage imageNamed:@"Now_Light.png"] forState:UIControlStateSelected];
    [btnNow setImage:[UIImage imageNamed:@"Now_Dark.png"] forState:UIControlStateNormal];
    [btnNow setTag:NOW_TAG];
    [self addSubview:btnNow];
    
    btnLater = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLater.frame = CGRectMake(160, 0, 80, 44);
    [btnLater addTarget:self action:@selector(btnLaterPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btnLater setImage:[UIImage imageNamed:@"Later_Light.png"] forState:UIControlStateSelected];
    [btnLater setImage:[UIImage imageNamed:@"Later_Dark.png"] forState:UIControlStateNormal];
    [btnLater setTag:LATER_TAG];
    [self addSubview:btnLater];
    
    btnAddSpecial = [UIButton buttonWithType:UIButtonTypeCustom];
    btnAddSpecial.frame = CGRectMake(240, 0, 80, 44);
    [btnAddSpecial addTarget:self action:@selector(btnAddSpecialPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btnAddSpecial setImage:[UIImage imageNamed:@"Add_Light.png"] forState:UIControlStateSelected];
    [btnAddSpecial setImage:[UIImage imageNamed:@"Add_Dark.png"] forState:UIControlStateNormal];
    [btnAddSpecial setTag:ADD_TAG];
    [self addSubview:btnAddSpecial];
    
    locationView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, 320, 40)];
    locationView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:locationView];
    [locationView release];
    
    locationField = [[UITextField alloc] initWithFrame:CGRectMake(40, 4.5, 200, 31)];
    locationField.backgroundColor = [UIColor whiteColor];
    locationField.placeholder = @"Locating...";
    locationField.delegate = self;
    locationField.borderStyle = UITextBorderStyleRoundedRect;
    [locationView addSubview:locationField];
    [locationField release];
    
    // initial selection
    previousSelectedIndex = SLIDE_UP_TAG;
    [btnSlideUp setSelected:YES];
    
    UIView *pinCodeHolder = [[UIView alloc] initWithFrame:CGRectMake(0, 84, 320, 460)];
    pinCodeHolder.backgroundColor = [UIColor blackColor];
    [self addSubview:pinCodeHolder];
    [pinCodeHolder release];
    
    UILabel *searchByLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 280, 31)];
    searchByLabel.backgroundColor = [UIColor clearColor];
    searchByLabel.text = @"Search By Zip Code";
    searchByLabel.textColor = [UIColor whiteColor];
    searchByLabel.font = [UIFont boldSystemFontOfSize:24.0f];
    searchByLabel.textAlignment = UITextAlignmentCenter;
    [pinCodeHolder addSubview:searchByLabel];
    [searchByLabel release];
    
    code1 = [[UILabel alloc] initWithFrame:CGRectMake(18, 90, 45, 45)];
    code1.font = [UIFont boldSystemFontOfSize:30.0f];
    code1.textAlignment = UITextAlignmentCenter;
    code1.tag = 2000;
    [pinCodeHolder addSubview:code1];
    [code1 release];
    
    code2 = [[UILabel alloc] initWithFrame:CGRectMake(78, 90, 45, 45)];
    code2.font = [UIFont boldSystemFontOfSize:30.0f];
    code2.textAlignment = UITextAlignmentCenter;
    code2.tag = 2001;
    [pinCodeHolder addSubview:code2];
    [code2 release];
    
    code3 = [[UILabel alloc] initWithFrame:CGRectMake(138, 90, 45, 45)];
    code3.font = [UIFont boldSystemFontOfSize:30.0f];
    code3.textAlignment = UITextAlignmentCenter;
    code3.tag = 2002;
    [pinCodeHolder addSubview:code3];
    [code3 release];
    
    code4 = [[UILabel alloc] initWithFrame:CGRectMake(198, 90, 45, 45)];
    code4.font = [UIFont boldSystemFontOfSize:30.0f];
    code4.textAlignment = UITextAlignmentCenter;
    code4.tag = 2003;
    [pinCodeHolder addSubview:code4];
    [code4 release];
    
    code5 = [[UILabel alloc] initWithFrame:CGRectMake(258, 90, 45, 45)];
    code5.font = [UIFont boldSystemFontOfSize:30.0f];
    code5.textAlignment = UITextAlignmentCenter;
    code5.tag = 2004;
    [pinCodeHolder addSubview:code5];
    [code5 release];
    
    zipField = [[UITextField alloc] initWithFrame:CGRectMake(5, 150, 50, 31)];
    zipField.alpha = 0;
    zipField.keyboardType = UIKeyboardTypeNumberPad;
    zipField.keyboardAppearance = UIKeyboardAppearanceAlert;
    [pinCodeHolder addSubview:zipField];
    [zipField release];
}

-(void)setingsButtonSwiped:(UISwipeGestureRecognizer*)gestureRecognizer
{
    [UIView animateWithDuration:0.25
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.frame = CGRectMake(0, gestureRecognizer.direction==UISwipeGestureRecognizerDirectionUp?0:416, 320, self.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         [zipField becomeFirstResponder];
                     }];
}

-(void)setingsButtonPanned:(UIPanGestureRecognizer*)gestureRecognizer
{
    code1.text = @"";
    code2.text = @"";
    code3.text = @"";
    code4.text = @"";
    code5.text = @"";
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan ||
        [gestureRecognizer state] == UIGestureRecognizerStateChanged)
    {
        [zipField resignFirstResponder];
        CGPoint translation = [gestureRecognizer translationInView:[self superview]];
        NSLog(@"Y = %f", translation.y);
        [self setCenter:CGPointMake([self center].x, [self center].y + translation.y)];
        [gestureRecognizer setTranslation:CGPointZero inView:[self superview]];
    }
    
    if([gestureRecognizer state] == UIGestureRecognizerStateEnded)
    {
        [UIView animateWithDuration:0.25
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             self.frame = CGRectMake(0, 0, 320, self.frame.size.height);
                         }
                         completion:^(BOOL finished) {
                             [zipField becomeFirstResponder];
                         }];
    }
}

-(void)makeZipFieldAsFirstResponder:(BOOL)status
{
    if (status) {
        [zipField becomeFirstResponder];
    }
    else {
        [zipField resignFirstResponder];
    }
}

-(void)btnSlideUpPressed:(id)sender
{
    [btnSlideUp setSelected:YES];
    
    if(previousSelectedIndex != SLIDE_UP_TAG)
    {
        UIButton *button = (UIButton*)[self viewWithTag:previousSelectedIndex];
        [button setSelected:NO];
    }
    
    if (previousSelectedIndex == ADD_TAG) {
        [delegate addPressed:self];
    }
    
    if (delegate && [delegate performSelector:@selector(slideUpPressed:)]) {
        [delegate slideUpPressed:self];
    }
    
    previousSelectedIndex = SLIDE_UP_TAG;
}

-(void)btnNowPressed:(id)sender
{
    [btnNow setSelected:YES];
    
    if(previousSelectedIndex != NOW_TAG)
    {
        UIButton *button = (UIButton*)[self viewWithTag:previousSelectedIndex];
        [button setSelected:NO];
        [button setBackgroundColor:[UIColor blackColor]];
    }
    
    if (previousSelectedIndex == ADD_TAG) {
        [delegate addPressed:self];
    }
    
    if (delegate && [delegate performSelector:@selector(nowPressed:)]) {
        [delegate nowPressed:self];
    }
    
    previousSelectedIndex = NOW_TAG;
}

-(void)btnLaterPressed:(id)sender
{
    [btnLater setSelected:YES];
    
    if(previousSelectedIndex != LATER_TAG)
    {
        UIButton *button = (UIButton*)[self viewWithTag:previousSelectedIndex];
        [button setSelected:NO];
    }
    
    if (previousSelectedIndex == ADD_TAG) {
        [delegate addPressed:self];
    }
    
    if (delegate && [delegate performSelector:@selector(laterPressed:)]) {
        [delegate laterPressed:self];
    }
    
    previousSelectedIndex = LATER_TAG;
}

-(void)btnAddSpecialPressed:(id)sender
{
    [btnAddSpecial setSelected:YES];
    
    if(previousSelectedIndex != ADD_TAG)
    {
        UIButton *button = (UIButton*)[self viewWithTag:previousSelectedIndex];
        [button setSelected:NO];
    }
    
    if (delegate) {
        [delegate addPressed:self];
    }
    
    previousSelectedIndex = ADD_TAG;
}

-(void)slideLocationViewUp
{
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectOffset(self.frame, 0, -locationView.frame.size.height);
    }];
}

-(void)slideLocationViewDown
{
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectOffset(self.frame, 0, locationView.frame.size.height);
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (delegate && [delegate respondsToSelector:@selector(locatingPressed:)]) {
        [delegate locatingPressed:self];
    }
    return NO;
}

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

-(void)textFieldDidChange
{
    NSString *text = zipField.text;
    NSUInteger count = text.length;
    
    int index;
    for(index=0; index<count; index++)
    {
        UILabel *label = (UILabel*)[self viewWithTag:index+2000];
        label.text = [NSString stringWithFormat:@"%c",[zipField.text characterAtIndex:index]];
    }
    
    for(int counter=index; counter<5; counter++)
    {
        UILabel *label = (UILabel*)[self viewWithTag:counter+2000];
        label.text = @"";
    }
    
    if(text.length == 5)
    {
        [zipField resignFirstResponder];
        [UIView animateWithDuration:0.25
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             self.frame = CGRectMake(0, 416, 320, self.frame.size.height);
                         }
                         completion:^(BOOL finished) {
                         }];
    }
}

-(void)dealloc
{
    [super dealloc];
}

@end