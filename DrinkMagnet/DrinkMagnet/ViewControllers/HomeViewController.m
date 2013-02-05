#import "HomeViewController.h"
#import "SpecialView.h"
#import "Special.h"
#import "SpecialsMapViewController.h"
#import "DrinkMagnetConstants.h"
#import "DrinkMagnetUtils.h"
#import "PinCodeViewController.h"
#import "APIConstants.h"
#import "DMParser.h"

@interface HomeViewController ()
{
    NSInteger selectedIndex;
}

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) CLLocation *currentLocation;
@property (nonatomic, retain) CLHeading *currentHeading;

@end

@implementation HomeViewController

@synthesize specialsPageFlowView;
@synthesize locationView, locationTitleView, dragCancelView;
@synthesize locationManager = _locationManager;
@synthesize currentLocation = _currentLocation;
@synthesize currentHeading = _currentHeading;
@synthesize pincodeField, code1, code2, code3, code4, code5;
@synthesize btnInfo,hud;

- (BOOL)shouldAutorotate {
    return NO;
}

/*- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}*/

- (void)viewDidLoad
{
    [super viewDidLoad];
    selectedIndex = -1;
    
    imageUrls = [[NSMutableArray alloc] initWithObjects:
                 @"http://www.thursdayclub.com/Pictures/no5.jpg",
                 @"http://images.askmen.com/fine_living/restaurant/1260991740_the-breslin-bar-and-dining-room-review_1.jpg",
                 @"http://t1.gstatic.com/images?q=tbn:ANd9GcTCYDlcgzwwxqNRNKxJ_sxa-P9ub47UOA67BbyqmdXTlEt9ncyy93E3u3ba",
                 @"http://t0.gstatic.com/images?q=tbn:ANd9GcSHJlUzUMpIzeyyQUJQIun9ZnO6UO75r58BpvpiZHC2icnRKrNdwQ",
                 @"http://t0.gstatic.com/images?q=tbn:ANd9GcR_0Y9mekU_Pd-L9ZehONGH_yau3pRBYyre2DVuDxLaYy2C0Rqj",
                 @"http://t2.gstatic.com/images?q=tbn:ANd9GcSIjUI8qNE_Km8x1z75hyhsksgTqRcevNItNJqSnckCiewsdymhFg",
                 @"http://t2.gstatic.com/images?q=tbn:ANd9GcS0spiYYmek9cPJ0YMeF7K6mrL8lKDcp5xVn-H4jp9UchEJh8oSEw",
                 @"http://t2.gstatic.com/images?q=tbn:ANd9GcSuWlbzrpZhFoiZeMdV274KW-zgxkerGvOBCl71MI_wEZeFz3F7",
                 @"http://t2.gstatic.com/images?q=tbn:ANd9GcTIj56DpI6CYBLNJK9NYCL5VsIMX28W9vhOJ0g6Wy0T_Q9uPkAUgA",
                 @"http://t0.gstatic.com/images?q=tbn:ANd9GcTIZnl1rGmnKo9xUGYeJsXWPYG2834K7Uy4iE0U5OQV9vSUCKhg",
                 nil];
    
    
    specialsPageFlowView.delegate = self;
    specialsPageFlowView.dataSource = self;
    specialsPageFlowView.minimumPageAlpha = 0.2;
    specialsPageFlowView.minimumPageScale = 0.9;
    specialsPageFlowView.orientation = PagedFlowViewOrientationVertical;
    
    //locationTitleView.layer.cornerRadius = 20.0f;
    //dragCancelView.layer.cornerRadius = 20.0f;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(bottomBarPanned:)];
    [locationView addGestureRecognizer:pan];
    [pan release];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidChange)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
    
    NSLog(@"Screen Height %f", [[UIScreen mainScreen ] bounds].size.height);
    if((int)[[UIScreen mainScreen ] bounds].size.height < 568)
    {
        locationView.frame = CGRectMake(0, 428, 320, 492);
    }
    else
    {
        //locationView.frame = CGRectMake(0, 428, 320, 492);
    }
    
    barDetailsArray = [[NSMutableArray alloc] init];
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if (![DrinkMagnetUtils isConnectedToInternet]) {
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"No Internet Connection!";
        [hud hide:YES afterDelay:5];
    }
    else
    {
        connectionManager = [[ConnectionManager alloc] init];
        connectionManager.delegate = self;
        hud.labelText = @"Loading Specials";
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@lat=%f&long=%f",DrinkMagnetBarsAPI, 38.9087587, -90.35322719999999]]];
        NSLog(@"Request string %@",[request description]);
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            NSLog(@"Pass Response = %@", JSON);
            [hud hide:YES afterDelay:3];
            self.hud = nil;
            NSArray *barsArray = [DMParser parseBarDetailsResponseForArray:[JSON valueForKeyPath:@"result"]];
            [barDetailsArray removeAllObjects];
            [barDetailsArray addObjectsFromArray:barsArray];
            [specialsPageFlowView reloadData];
            NSLog(@"Array %@",barDetailsArray);
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            NSLog(@"Failed Response : %@", JSON);
            hud.labelText = @"Some thing went wrong";
            [hud hide:YES afterDelay:3];
        }];
        [operation start];
    }
}


#pragma mark - Info Button Tap Function

-(void)hideAppInfo:(UITapGestureRecognizer*)gesture
{
    UIImageView *imageView = (UIImageView*)[self.view viewWithTag:4444];
    if (imageView) {
        [UIView animateWithDuration:.35 animations:^{
            imageView.alpha = 0;
        } completion:^(BOOL finished) {
            [imageView removeFromSuperview];  
        }]; 
    }
}

-(IBAction)infoButtonTapped:(id)sender
{
    UIImageView *imageView = (UIImageView*)[self.view viewWithTag:4444];
    if(imageView)
        return;
    UIImageView *appInfoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
    appInfoImageView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.6];
    appInfoImageView.tag = 4444;
    appInfoImageView.userInteractionEnabled = YES;
    appInfoImageView.alpha = 0;
    [self.view addSubview:appInfoImageView];
    [appInfoImageView release];
    
    UIImageView *infoText = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Info.png"]];
    infoText.frame = CGRectMake(10, 80, 300, 300);
    [appInfoImageView addSubview:infoText];
    [infoText release];
    
    UITapGestureRecognizer *hideInfoTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideAppInfo:)];
    hideInfoTapGesture.numberOfTapsRequired = 1;
    [appInfoImageView addGestureRecognizer:hideInfoTapGesture];
    [hideInfoTapGesture release];
    
    [UIView animateWithDuration:.35 animations:^{
        appInfoImageView.alpha = 1; 
    }];
    
}

#pragma mark - Bottom bar panning function

-(void)bottomBarPanned:(UIPanGestureRecognizer*)gestureRecognizer
{
    if((int)[[UIScreen mainScreen ] bounds].size.height < 568)
    {
        CGPoint translation = [gestureRecognizer translationInView:self.view];
        if ([gestureRecognizer state] == UIGestureRecognizerStateBegan ||
            [gestureRecognizer state] == UIGestureRecognizerStateChanged)
        {
            if (translation.y > -210)
            {
                pincodeField.text = @"";
                [pincodeField resignFirstResponder];
            }
            
            locationView.frame = CGRectMake(0, ((bottombarOnTop)?0:428)+translation.y, 320, 492);
            NSLog(@"Frame is %@",NSStringFromCGRect(locationView.frame));
            
            [UIView animateWithDuration:0.25 animations:^{
                dragCancelView.alpha = 0;
            }];
        }
        
        if([gestureRecognizer state] == UIGestureRecognizerStateEnded)
        {
            if (translation.y < -210) {
                [UIView animateWithDuration:0.25
                                      delay:0
                                    options:UIViewAnimationOptionBeginFromCurrentState
                                 animations:^{
                                     locationView.frame = CGRectMake(0, -32, 320, 492);
                                     bottombarOnTop = YES;
                                     dragCancelView.alpha = 1.0;
                                 }
                                 completion:^(BOOL finished) {
                                     [pincodeField becomeFirstResponder];
                                 }];
            }
            else {
                [UIView animateWithDuration:0.25
                                      delay:0
                                    options:UIViewAnimationOptionBeginFromCurrentState
                                 animations:^{
                                     locationView.frame = CGRectMake(0, 428, 320, 492);
                                     bottombarOnTop = NO;
                                 }
                                 completion:^(BOOL finished) {
                                     pincodeField.text = @"";
                                     [pincodeField resignFirstResponder];
                                 }];
            }
            
        }
    }
    else
    {
        CGPoint translation = [gestureRecognizer translationInView:self.view];
        if ([gestureRecognizer state] == UIGestureRecognizerStateBegan ||
            [gestureRecognizer state] == UIGestureRecognizerStateChanged)
        {
            if (translation.y > -258)
            {
                pincodeField.text = @"";
                [pincodeField resignFirstResponder];
            }
            
            locationView.frame = CGRectMake(0, ((bottombarOnTop)?0:516)+translation.y, 320, 580);
            NSLog(@"Frame is %@",NSStringFromCGRect(locationView.frame));
            
            [UIView animateWithDuration:0.25 animations:^{
                dragCancelView.alpha = 0;
            }];
        }
        
        if([gestureRecognizer state] == UIGestureRecognizerStateEnded)
        {
            if (translation.y < -258) {
                [UIView animateWithDuration:0.25
                                      delay:0
                                    options:UIViewAnimationOptionBeginFromCurrentState
                                 animations:^{
                                     locationView.frame = CGRectMake(0, -32, 320, 580);
                                     bottombarOnTop = YES;
                                     dragCancelView.alpha = 1.0;
                                 }
                                 completion:^(BOOL finished) {
                                     [pincodeField becomeFirstResponder];
                                 }];
            }
            else {
                [UIView animateWithDuration:0.25
                                      delay:0
                                    options:UIViewAnimationOptionBeginFromCurrentState
                                 animations:^{
                                     locationView.frame = CGRectMake(0, 516, 320, 580);
                                     bottombarOnTop = NO;
                                 }
                                 completion:^(BOOL finished) {
                                     pincodeField.text = @"";
                                     [pincodeField resignFirstResponder];
                                 }];
            }
            
        }
    }
}

- (CLLocationManager *)locationManager
{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    }
    return _locationManager;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ([CLLocationManager locationServicesEnabled])
    {
        //[self.locationManager startUpdatingLocation];
        //[self.locationManager startUpdatingHeading];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    
    [self.locationManager stopUpdatingHeading];
    [self.locationManager stopUpdatingLocation];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -
#pragma mark CLLocationManager Delegate Methods

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    _currentLocation = newLocation;
    
    CGFloat angle = (CGFloat)(arc4random()%360);
    [[NSNotificationCenter defaultCenter] postNotificationName:DirectinUpdateNotification
                                                        object:[NSString stringWithFormat:@"%f", angle]];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    _currentHeading = newHeading;
    [self updateCompassDisplay];
}

- (void)updateCompassDisplay
{
    double bearing = [DrinkMagnetUtils bearingToDestination:self.currentLocation fromOrigin:self.currentLocation];
    double heading = self.currentHeading.magneticHeading;
    double diff = heading - bearing;
    double radDiff = diff * (M_PI / 180) * -1;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:DirectinUpdateNotification
                                                        object:[NSString stringWithFormat:@"%f", radDiff]];
}

#pragma mark - PinCodeDelegate

-(void)pincodeEntered:(NSString *)pin
{
    NSLog(@"Entered Zip - %@", pin);
}

#pragma mark - AddSpecialsDelegate

-(void)dismissAddView:(AddSpecialView *)view
{
    NSLog(@"ENtered");
    
    if (isAddViewOpen) {
        
        [UIView animateWithDuration:0.25 animations:^{
            view.alpha = 0;
        }];
        [view removeFromSuperview];
    }
    
}

-(void)pushMapWithLocaiton:(CLLocationCoordinate2D)aLocation
{
    SpecialsMapViewController *specialsMapViewController = [[SpecialsMapViewController alloc]initWithNibName:@"SpecialsMapViewController" bundle:nil];
    
    UINavigationController *navBar=[[UINavigationController alloc]initWithRootViewController:specialsMapViewController];
    [navBar.navigationBar setTintColor:[UIColor darkGrayColor]];
    [self.navigationController presentModalViewController:navBar animated:YES];
    [navBar release];
    [specialsMapViewController release];
}

#pragma mark -
#pragma mark PagedFlowView Delegate
- (CGSize)sizeForPageInFlowView:(PagedFlowView *)flowView;{
    return CGSizeMake(290, 300);
}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(PagedFlowView *)flowView {
    NSLog(@"Scrolled to page # %d", pageNumber);
    /*if(pageNumber-1>=0)
    {
        SpecialView *specialView = (SpecialView*)[flowView._scrollView viewWithTag:pageNumber-1];
        if(specialView)
            [specialView showOptions:YES];
    }*/
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark PagedFlowView Datasource
- (NSInteger)numberOfPagesInFlowView:(PagedFlowView *)flowView{
    return barDetailsArray.count>0?barDetailsArray.count:1;
}

- (UIView *)flowView:(PagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
    SpecialView *specialView = [[[SpecialView alloc] initWithFrame:CGRectMake(0, 0, 290, 295)] autorelease];
    specialView.delegate = self;
    specialView.tag = index;
    specialView.specialIndex = index;
    //[specialView setSpecial:aSpecial];
    if(barDetailsArray.count >0)
    [specialView setSpecialwithBarDetails:[barDetailsArray objectAtIndex:index]];
    
    return specialView;
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
    pincodeField.text = @"";
    [pincodeField resignFirstResponder];
    [UIView animateWithDuration:0.25
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         locationView.frame = CGRectMake(0, 428, 320, 492);
                         bottombarOnTop = NO;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
    code1.text=@"";code2.text=@"";code3.text=@"";code4.text=@"";code5.text=@"";
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

#pragma mark -
#pragma mark ConnectionManager delegate functions

-(void)httpRequestFailed:(AFXMLRequestOperation *)request
{
	NSLog(@"AccountViewController : httpRequestFailed");
    
	NSError *error= [request error];
	NSLog(@"%@",[error localizedDescription]);
    //[Utils showAlertMessage:[error localizedDescription]];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = [error localizedDescription];
    [hud hide:YES afterDelay:5];
}

-(void)httpRequestFinished:(AFXMLRequestOperation *)request
{
	NSLog(@"AccountViewController : httpRequestFinished");
    
    self.hud = nil;
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
	NSString *responseJSON = [[request responseString] retain];
	
//    if([urlString hasPrefix:DrinkMagnetBarsAPI]) //Profile
  //  {
        NSArray *barsArray = [DMParser parseBarDetailsResponse:responseJSON];
        [barDetailsArray removeAllObjects];
        [barDetailsArray addObjectsFromArray:barsArray];
        [specialsPageFlowView reloadData];
    //}
    
    [responseJSON release];
}


#pragma mark - Other Methods

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidUnload
{
    [self setLocationView:nil];
    [self setLocationTitleView:nil];
    [self setDragCancelView:nil];
    [self setCode1:nil];
    [self setCode2:nil];
    [self setCode3:nil];
    [self setCode4:nil];
    [self setCode5:nil];
    [self setPincodeField:nil];
    [self setBtnInfo:nil];
    [super viewDidUnload];
    
    [self setSpecialsPageFlowView:nil];
    
    if(self.locationManager)
    {
        [self.locationManager stopUpdatingLocation];
        self.locationManager.delegate = nil;
        [self.locationManager release];
        self.locationManager = nil;
    }
    self.hud = nil;
}

-(void)dealloc
{
    if(self.locationManager)
    {
        [self.locationManager stopUpdatingLocation];
        self.locationManager.delegate = nil;
        [self.locationManager release];
        self.locationManager = nil;
    }
    
    [specialsPageFlowView release];
    [locationView release];
    [locationTitleView release];
    [dragCancelView release];
    [code1 release];
    [code2 release];
    [code3 release];
    [code4 release];
    [code5 release];
    [pincodeField release];
    [btnInfo release];
    [super dealloc];
}

@end