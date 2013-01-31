//
//  DrinkMagnetUtils.h
//  DrinkMagnet

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface DrinkMagnetUtils : NSObject
{
}

+(BOOL)isConnectedToInternet;
+(double)bearingToDestination:(CLLocation *)destination fromOrigin:(CLLocation *)origin;
+(NSString*)distanceToDestination:(CLLocation*)dest fromOrigin:(CLLocation*)origin;

@end
