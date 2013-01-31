//
//  SpecialsMapViewController.m
//  DrinkMagnet
//
//  Created by Puneet Sharma on 24/09/12.
//  Copyright (c) 2012 WinkApps. All rights reserved.
//

#import "SpecialsMapViewController.h"
#import "MyLocation.h"

@interface SpecialsMapViewController ()

@end

@implementation SpecialsMapViewController

@synthesize specialsMapView;

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
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissModalViewControllerAnimated:)] autorelease];
    
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 13.0810;
    zoomLocation.longitude= 80.2740;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*1689.344, 0.5*16899.344);
    MKCoordinateRegion adjustedRegion = [specialsMapView regionThatFits:viewRegion];                
    [specialsMapView setRegion:adjustedRegion animated:YES];
    
    annotationMy = [[MyLocation alloc] initWithName:@"Current Location" address:@"Chennai,Tamil Nadu,India" coordinate:zoomLocation] ;
    [specialsMapView addAnnotation:annotationMy];
    specialsMapView.zoomEnabled = FALSE;
    [self performSelector:@selector(highlightResult:) withObject:nil afterDelay:0];    
}

- (void)highlightResult:(BOOL)animated
{
    
    const double MapViewAperture = 0.05;
    [specialsMapView setRegion:
     MKCoordinateRegionMake(CLLocationCoordinate2DMake(13.0810, 80.2740),
                            MKCoordinateSpanMake(MapViewAperture, MapViewAperture))];
    
    [specialsMapView selectAnnotation:(id<MKAnnotation>)annotationMy animated:animated];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id  <MKAnnotation>)annotation
{
    static NSString *identifier = @"MyLocation";   
    if ([annotation isKindOfClass:[MyLocation class]]) {
        
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [specialsMapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier] autorelease];
        } else {
            annotationView.annotation = annotation;
        }
        
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
		rightButton.frame = CGRectMake(0, 0, 30, 32);
		rightButton.tag =110;
		rightButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
		[rightButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
		annotationView.rightCalloutAccessoryView = rightButton;

		
		annotationView.animatesDrop=TRUE;
		annotationView.canShowCallout = YES;
		annotationView.calloutOffset = CGPointMake(0, 0);
        annotationView.enabled = YES;
        annotationView.image=[UIImage imageNamed:@"arrest.png"];//here we use a nice image instead of the default pins        
        return annotationView;
    }
    return nil;
}

-(IBAction)getDirectionsFromHere:(id)sender
{
    NSString *address = @"Bangalore";
    NSString *routeString = [NSString stringWithFormat:@"http://maps.google.com/maps?saddr=%f,%f&daddr=%@",12.9833f,77.5833f,address];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:routeString]];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    specialsMapView = nil;
    [annotationMy release];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)dealloc
{
    [annotationMy release];
    [specialsMapView release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
