//
//  DrinkMagnetUtils.m
//  DrinkMagnet
//


#import "DrinkMagnetUtils.h"
#import "DrinkMagnetConstants.h"

@implementation DrinkMagnetUtils

/*+(BOOL)isConnectedToInternet
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    NSLog(@"Utils : Is Connected To Internet : %@", (!(networkStatus == NotReachable)) ? @"YES" : @"NO");
    return !(networkStatus == NotReachable);
}*/

+(double)bearingToDestination:(CLLocation *)destination fromOrigin:(CLLocation *)origin
{
    double bearing = 0;
    double lon1 = origin.coordinate.longitude;
    double lat1 = origin.coordinate.latitude;
    double lon2 = destination.coordinate.longitude;
    double lat2 = destination.coordinate.latitude;
    double y = lon2 - lon1;
    double x = lat2 - lat1;
    bearing = atan2(y, x);
    bearing = bearing * (180 / M_PI);
    bearing = fmod((bearing + 360), 360);
    return bearing;
}

+(NSString *)distanceToDestination:(CLLocation*)dest fromOrigin:(CLLocation*)origin
{
    NSNumber *distance = nil;
    if (origin)
    {
        CLLocationDistance distanceFromHere = [origin distanceFromLocation:dest];
        double milesFromHere = distanceFromHere * MILES_PER_METER;
        distance = [NSNumber numberWithDouble:milesFromHere];
    }
    else
    {
        distance = [NSNumber numberWithDouble:0];
    }
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"0.##"];
    return [numberFormatter stringFromNumber:distance];
}


@end
