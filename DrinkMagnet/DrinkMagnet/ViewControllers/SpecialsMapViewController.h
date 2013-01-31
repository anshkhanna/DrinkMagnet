//
//  SpecialsMapViewController.h
//  DrinkMagnet
//
//  Created by Puneet Sharma on 24/09/12.
//  Copyright (c) 2012 WinkApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MyLocation.h"

@interface SpecialsMapViewController : UIViewController<MKMapViewDelegate>{

    IBOutlet MKMapView *specialsMapView;
    MyLocation *annotationMy;
}

@property (nonatomic, retain)IBOutlet MKMapView *specialsMapView;

-(IBAction)getDirectionsFromHere:(id)sender;


@end
