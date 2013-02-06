#import "SpecialView.h"
#import "DrinkMagnetConstants.h"
#import "DrinkMagnetUtils.h"
#import "UIImage+DSP.h"
#import <QuartzCore/QuartzCore.h>
#import "BarDetails.h"
#import "FontLabel.h"
#import "FontLabelStringDrawing.h"
#import "FontManager.h"

#define VIEW_BG_COLOR [UIColor colorWithWhite:0.1 alpha:.95]

@interface SpecialView()
{
    UITapGestureRecognizer *tapGesture;
}

-(void)initialize;

@end

@implementation SpecialView

@synthesize delegate, specialIndex;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.layer.masksToBounds = YES;
        [self initialize];
        self.autoresizesSubviews = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        // Get date in String Format
        NSDateComponents *comps = [[[NSDateComponents alloc] init] autorelease];
        [comps setDay:21];
        [comps setHour:2];
        [comps setMonth:12];
        [comps setYear:2015];
        endDate = [[NSCalendar currentCalendar] dateFromComponents:comps];
        [endDate retain];
        
        countDownTimer = [NSTimer scheduledTimerWithTimeInterval:.1
                                                          target:self
                                                        selector:@selector(decrementingTimer:)
                                                        userInfo:nil
                                                         repeats:YES];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(changeInDirection:)
                                                     name:DirectinUpdateNotification
                                                   object:nil];
        
        compassBodyImage.transform = CGAffineTransformMakeRotation(arc4random()*360);
        
        tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

-(void)initialize
{
    // bar image view
    barImageView = [[AsyncImageView alloc] initWithFrame:self.bounds];
    [self addSubview:barImageView];
    [barImageView release];
    
    // Special Name view
    
    specialNameView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 230, 95)];
    specialNameView.backgroundColor = VIEW_BG_COLOR;
    [self addSubview:specialNameView];
    [specialNameView release];
    
    specialName = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 150, 80)];
    specialName.backgroundColor = [UIColor clearColor];
    specialName.text = @"Domestic Pitchers";
    specialName.textColor = [UIColor whiteColor];
    specialName.font = [UIFont boldSystemFontOfSize:26.0f];
    specialName.numberOfLines = 2;
    specialName.shadowColor = [UIColor blackColor];
    specialName.shadowOffset = CGSizeMake(0, 1);
    [specialNameView addSubview:specialName];
    [specialName release];
    
    UIImageView *circleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1new_circle.png"]];
    circleView.frame = CGRectMake(145, 8, 80, 80);
    [specialNameView addSubview:circleView];
    [circleView release];
    
    UILabel *domesticPrice = [[UILabel alloc]initWithFrame:CGRectMake(0, 15,80, 50)];
    domesticPrice.backgroundColor = [UIColor clearColor];
    domesticPrice.textColor = [UIColor whiteColor];
    domesticPrice.textAlignment = UITextAlignmentCenter;
    domesticPrice.font = [UIFont boldSystemFontOfSize:24.0f];
    domesticPrice.text = @"$50.5";
    //[circleView addSubview:domesticPrice];
    //[domesticPrice release];
    
    FontLabel *labelDomesticPrice = [[FontLabel alloc] initWithFrame:CGRectMake(0, 15,80, 50)];
	ZMutableAttributedString *str = [[ZMutableAttributedString alloc] initWithString:@"$50.5"
																		  attributes:[NSDictionary dictionaryWithObjectsAndKeys:
																					  [[FontManager sharedManager] zFontWithName:@"luxisb" pointSize:28],
																					  ZFontAttributeName,
																					  nil]];

    [str addAttribute:ZFontAttributeName value:[[FontManager sharedManager] zFontWithName:@"luxisb" pointSize:20] range:NSMakeRange(4, 1)];
	[str addAttribute:ZUnderlineStyleAttributeName value:[NSNumber numberWithInt:ZUnderlineStyleSingle] range:NSMakeRange(4, 1)];
    
	[str addAttribute:ZForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, 5)];
	[str addAttribute:ZBackgroundColorAttributeName value:[UIColor clearColor] range:NSMakeRange(0, 5)];
	labelDomesticPrice.zAttributedText = str;
	[str release];
	labelDomesticPrice.textAlignment = UITextAlignmentCenter;
	labelDomesticPrice.backgroundColor = [UIColor clearColor];
	labelDomesticPrice.numberOfLines = 0;
	[circleView addSubview:labelDomesticPrice];
	[labelDomesticPrice release];

    // Offer view
    offerView = [[UIView alloc] initWithFrame:CGRectMake(245, 50, 45, 45)];
    offerView.backgroundColor = VIEW_BG_COLOR;
    [self addSubview:offerView];
    [offerView release];
    
    UIImageView *offerImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1new_deal.png"]];
    offerImage.frame = CGRectMake(10, 10, 25, 25);
    [offerView addSubview:offerImage];
    [offerImage release];
    
    offerLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 250, 40)];
    offerLabel.backgroundColor = [UIColor clearColor];
    offerLabel.text = @"Domestic Pitchers";
    offerLabel.alpha =0;
    offerLabel.textColor = [UIColor whiteColor];
    offerLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    offerLabel.numberOfLines = 2;
    offerLabel.shadowColor = [UIColor blackColor];
    offerLabel.shadowOffset = CGSizeMake(0, 1);
    [offerView addSubview:offerLabel];
    [offerLabel release];
    
    // Bar name view
    barNameView = [[UIView alloc] initWithFrame:CGRectMake(245, 0, 45, 45)];
    barNameView.backgroundColor = VIEW_BG_COLOR;
    [self addSubview:barNameView];
    [barNameView release];
    
    UIImageView *homeImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1new_house.png"]];
    homeImage.frame = CGRectMake(10, 10, 25, 25);
    [barNameView addSubview:homeImage];
    [homeImage release];
    
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 5, 290, 40)];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.text = @"Bobs Dive Car";
    nameLabel.alpha = 0;
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    nameLabel.numberOfLines = 2;
    nameLabel.shadowColor = [UIColor blackColor];
    nameLabel.shadowOffset = CGSizeMake(0, 1);
    [barNameView addSubview:nameLabel];
    [nameLabel release];
    
    // Phone number view
    callView = [[UIView alloc] initWithFrame:CGRectMake(245, 100, 45, 42)];
    callView.backgroundColor = VIEW_BG_COLOR;
    [self addSubview:callView];
    [callView release];
    
    callTapGesture = [[UITapGestureRecognizer alloc]init];
    [callView addGestureRecognizer:callTapGesture];
    [callTapGesture release]; 
    
    UIButton *btnCall = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCall.frame = CGRectMake(10, 10, 25, 25);
    [btnCall setImage:[UIImage imageNamed:@"1new_phone.png"] forState:UIControlStateNormal];
    [callView addSubview:btnCall];
    
    callLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 150, 40)];
    callLabel.backgroundColor = [UIColor clearColor];
    callLabel.text = @"(713) 521-2002";
    callLabel.alpha = 0;
    callLabel.textColor = [UIColor whiteColor];
    callLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    callLabel.numberOfLines = 2;
    callLabel.shadowColor = [UIColor blackColor];
    callLabel.shadowOffset = CGSizeMake(0, 1);
    [callView addSubview:callLabel];
    [callLabel release];
    
    // Address view
    addressView = [[UIView alloc] initWithFrame:CGRectMake(245, 148, 45, 42)];
    addressView.backgroundColor = VIEW_BG_COLOR;
    [self addSubview:addressView];
    [addressView release];
    
    mapViewTapped = [[UITapGestureRecognizer alloc]init];
    [addressView addGestureRecognizer:mapViewTapped];
    [mapViewTapped release];
    
    UIButton *btnMap = [UIButton buttonWithType:UIButtonTypeCustom];
    btnMap.frame = CGRectMake(15, 10, 16,26);
    [btnMap setImage:[UIImage imageNamed:@"1new_map_pin.png"] forState:UIControlStateNormal];
    [addressView addSubview:btnMap];
    
    addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 150, 40)];
    addressLabel.backgroundColor = [UIColor clearColor];
    addressLabel.text = @"123 Montrose Ave";
    addressLabel.alpha = 0;
    addressLabel.textColor = [UIColor whiteColor];
    addressLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    addressLabel.numberOfLines = 2;
    addressLabel.shadowColor = [UIColor blackColor];
    addressLabel.shadowOffset = CGSizeMake(0, 1);
    [addressView addSubview:addressLabel];
    [addressLabel release];
    
    // Rotating compass view
    compassView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, 230, 90)];
    compassView.backgroundColor = VIEW_BG_COLOR;
    [self addSubview:compassView];
    [compassView release];
    
    compassBodyImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Compass.png"]];
    compassBodyImage.frame = CGRectMake(145, 5, 80, 80);
    [compassView addSubview:compassBodyImage];
    [compassBodyImage release];
    
    distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 110, 85)];
    distanceLabel.backgroundColor = [UIColor clearColor];
    distanceLabel.text = @"2.13 mi";
    distanceLabel.textColor = [UIColor whiteColor];
    distanceLabel.font = [UIFont boldSystemFontOfSize:32.0f];
    distanceLabel.textAlignment = UITextAlignmentCenter;
    distanceLabel.shadowColor = [UIColor blackColor];
    distanceLabel.shadowOffset = CGSizeMake(0, 1);
    [compassView addSubview:distanceLabel];
    [distanceLabel release];
    
    
    // Time remaining view
    timeRemainingView = [[UIView alloc] initWithFrame:CGRectMake(0, 195, 230, 90)];
    timeRemainingView.backgroundColor = VIEW_BG_COLOR;
    [self addSubview:timeRemainingView];
    [timeRemainingView release];
    
    timeRemainingLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 250, 80)];
    timeRemainingLabel.backgroundColor = [UIColor clearColor];
    timeRemainingLabel.text = @"88:88:88";
    timeRemainingLabel.textColor = [UIColor whiteColor];
    timeRemainingLabel.font = [UIFont boldSystemFontOfSize:32.0f];
    timeRemainingLabel.shadowColor = [UIColor blackColor];
    timeRemainingLabel.shadowOffset = CGSizeMake(0, 1);
    [timeRemainingView addSubview:timeRemainingLabel];
    
    UIImageView *imageViewHourGlass = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"1new_hour_glass.png"]];
    imageViewHourGlass.frame = CGRectMake(145, 5, 80, 80);
    [timeRemainingView addSubview:imageViewHourGlass];
    [imageViewHourGlass release];
    [timeRemainingLabel release];
    
    photosView = [[UIView alloc] initWithFrame:CGRectMake(245, 195, 45, 43)];
    photosView.backgroundColor = VIEW_BG_COLOR;
    [self addSubview:photosView];
    [photosView release];
    
    UIImageView *photosImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1new_photos.png"]];
    photosImageView.frame = CGRectMake(10, 10, 29, 25);
    [photosView addSubview:photosImageView];
    [photosImageView release];
    
    lblPhotos = [[UILabel alloc]initWithFrame:CGRectMake(45, 0, 150, 40)];
    lblPhotos.backgroundColor = [UIColor clearColor];
    lblPhotos.text = @"Photos";
    lblPhotos.textColor = [UIColor whiteColor];
    lblPhotos.alpha = 0;
    lblPhotos.font = [UIFont boldSystemFontOfSize:15.0f];
    [photosView addSubview:lblPhotos];
    [lblPhotos release];
    
    checkinView = [[UIView alloc] initWithFrame:CGRectMake(245, 242, 45, 42)];
    checkinView.backgroundColor = VIEW_BG_COLOR;
    [self addSubview:checkinView];
    [checkinView release];
    
    UIImageView *checkInImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1new_checkin.png"]];
    checkInImageView.frame = CGRectMake(10, 6, 30, 25);
    [checkinView addSubview:checkInImageView];
    [checkInImageView release];
}

-(void)viewTapped:(UITapGestureRecognizer*)gesture
{
    id viewTapped = gesture.view;
    
    if ([viewTapped isKindOfClass:[UIControl class]]) 
        return;
    [self showOptions:YES];
    
    if (delegate && [delegate respondsToSelector:@selector(specialTappedAtIndex:)]) {
        [delegate specialTappedAtIndex:specialIndex];
    }
}

-(void)showOptions:(BOOL)animated
{
    if (isOptionsOpen) {
        [callTapGesture removeTarget:self action:@selector(callTapped:)];
        [mapViewTapped removeTarget:self action:@selector(openMapViewController:)];
        
        [UIView animateWithDuration:0.25 animations:^{
            specialNameView.frame = CGRectMake(0, 0, 230, 95);  
            compassView.frame = CGRectMake(0, 100, 230, 90);
            timeRemainingView.frame = CGRectMake(0, 195, 230, 90);
            
            offerView.frame=CGRectMake(245, 50, 45, 45);
            barNameView.frame=CGRectMake(245, 0, 45, 45);
            callView.frame=CGRectMake(245, 100, 45, 42);
            checkinView.frame=CGRectMake(245, 242, 45, 42);
            photosView.frame=CGRectMake(245, 195, 45, 43);
            addressView.frame =CGRectMake(245, 148, 45, 42);
            offerLabel.alpha =0;
            callLabel.alpha = 0;
            nameLabel.alpha = 0;
            addressLabel.alpha = 0;
            lblPhotos.alpha = 0;
            timeRemainingLabel.alpha = 1;
        }];
        isOptionsOpen = NO;
    }
    else {
        [callTapGesture addTarget:self action:@selector(callTapped:)];
        [mapViewTapped addTarget:self action:@selector(openMapViewController:)];
        
        
        [UIView animateWithDuration:0.25 animations:^{
            specialNameView.frame = CGRectMake(-130, 00, 230, 95);
            compassView.frame = CGRectMake(-130, 100, 230, 90);
            timeRemainingView.frame = CGRectMake(-130, 195, 230, 90);
            
            offerView.frame=CGRectMake(110, 50, 180, 45);
            barNameView.frame=CGRectMake(110, 0, 180, 45);
            callView.frame=CGRectMake(110, 100, 180, 42);
            checkinView.frame=CGRectMake(110, 242, 180, 42);
            photosView.frame=CGRectMake(110, 195, 180, 43);
            addressView.frame =CGRectMake(110, 148, 180, 42);
            offerLabel.alpha =1;
            callLabel.alpha = 1;
            nameLabel.alpha = 1;
            addressLabel.alpha = 1;
            lblPhotos.alpha = 1;
            timeRemainingLabel.alpha = 0;
        }];
        isOptionsOpen = YES;
    }
}

-(void)callTapped:(UITapGestureRecognizer*)gesture
{
    UIAlertView *callAlert = [[UIAlertView alloc]initWithTitle:@"Call To Special" message:@"Joe's BAr And Grill +(712)5678" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Call", nil];
    [callAlert show];
    [callAlert release];
}


-(void)photoButtonPressed
{
    /*UIPageControl *specialPhotos = [[UIPageControl alloc]initWithFrame:self.bounds]; 
    [self addSubview:specialNameView];
    [specialNameView release];*/
}

-(void)callButtonPressed
{
    
    UIAlertView *callAlert = [[UIAlertView alloc]initWithTitle:@"Call To Special" message:@"Joe's BAr And Grill +(712)5678" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Call", nil];
    [callAlert show];
    [callAlert release];
    
}

- (void)changeInDirection:(NSNotification *)notification
{
    NSString *angleString = (NSString*)[notification object];
    double angle = [angleString doubleValue];
    [UIView animateWithDuration:0.25
                     animations:^{
                         compassBodyImage.transform = CGAffineTransformMakeRotation(angle);
                     }];
}

#pragma mark- UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://100000000"]];
    }
}

-(void)decrementingTimer:(NSTimer*)timer
{
    currentDate = [NSDate date];
    
    NSTimeInterval interval = [endDate timeIntervalSinceNow];
    double seconds = (double)interval;
    NSInteger hours = (int)seconds % 86400;
    double minutes = hours % 3600;
    double seconds1 = fmod(minutes, 60);
    hours	= hours / 3600;
	minutes	= minutes / 60;
    
    seconds = (int)((seconds - floor(seconds))*100);
    
    NSString *hourTotal = (hours<10)?[NSString stringWithFormat:@"0%d",(int)hours]:[NSString stringWithFormat:@"%d",(int)hours];
    NSString *minutesTotal = (minutes<10)?[NSString stringWithFormat:@"0%d",(int)minutes]:[NSString stringWithFormat:@"%d",(int)minutes];
    
    NSString *secondsTotal = (seconds1<10)?[NSString stringWithFormat:@"0%d",(int)seconds1]:[NSString stringWithFormat:@"%d",(int)seconds1];
    
    timeRemainingLabel.text = [NSString stringWithFormat:@"%@:%@:%@",hourTotal, minutesTotal,secondsTotal];
}

-(void)openMapViewController:(id)sender
{
    if (delegate && [delegate respondsToSelector:@selector(pushMapWithLocaiton:)]) {
        [delegate pushMapWithLocaiton:CLLocationCoordinate2DMake(0, 0)];
        [self showOptions:YES];
    }
}

-(void)setImageUrl:(NSString*)imageUrl
{
    [barImageView setImageURL:[NSURL URLWithString:imageUrl]];
}

-(void)setSpecialwithBarDetails:(BarDetails*)barDetails
{
    [self setImageUrl:barDetails.imageUrl];
    
    CLLocation *source = [[CLLocation alloc] initWithLatitude:0 longitude:0];
    //CLLocation *destination = aSpecial.location;
    
    //NSString *distance = [DrinkMagnetUtils distanceToDestination:destination fromOrigin:source];
    //distanceLabel.text = [distance stringByAppendingString:@" mi"];
    NSUInteger miles = arc4random()%40;
    float pscale = ((float)miles) / 100.0f;
    distanceLabel.text = [NSString stringWithFormat:@"%.2f mi", pscale];
    [source release];
    //[destination release];
    
        
    [nameLabel setText:barDetails.name];
    
    [callLabel setText:barDetails.phone];
    
    [addressLabel setText:barDetails.address];
    
//    UILabel *distanceLabel;
    
  
    [offerLabel setText:barDetails.special.description];
    
//    UILabel *timeRemainingLabel;
    
    [specialName setText:barDetails.special.description];

}

-(void)setSpecial:(Special*)aSpecial
{
    //[self setImageUrl:aSpecial.imageUrl];
    
    CLLocation *source = [[CLLocation alloc] initWithLatitude:0 longitude:0];
    //CLLocation *destination = aSpecial.location;
    
    //NSString *distance = [DrinkMagnetUtils distanceToDestination:destination fromOrigin:source];
    //distanceLabel.text = [distance stringByAppendingString:@" mi"];
    NSUInteger miles = arc4random()%40;
    float pscale = ((float)miles) / 100.0f;
    distanceLabel.text = [NSString stringWithFormat:@"%.2f mi", pscale];
    [source release];
    //[destination release];
}

#pragma mark - AsynImage delegate
-(void) didFinishLoadingImage:(UIImage *)image fromCache:(BOOL)cache
{
    barImageView.image = [image imageByApplyingDiagonalMotionBlur5x5];
}

-(void)dealloc
{
    [countDownTimer invalidate];
    self.delegate = nil;
    [endDate release];
    [tapGesture release];
    [super dealloc];
}

@end