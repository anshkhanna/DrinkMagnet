//
//  DrinkMagnetUtils.m
//  DrinkMagnet
//


#import "DrinkMagnetUtils.h"
#import "DrinkMagnetConstants.h"
#include <netinet/in.h>
#import <SystemConfiguration/SCNetworkReachability.h>

@implementation DrinkMagnetUtils

+(BOOL)isConnectedToInternet
{
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr*)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    if (!didRetrieveFlags)
    {
        NSLog(@"Error. Could not recover network reachability flags");
        return 0;
    }
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    
    BOOL nonWiFi = flags & kSCNetworkReachabilityFlagsTransientConnection;
    NSURL *testURL = [NSURL URLWithString:@"http://www.apple.com/"];
    NSURLRequest *testRequest = [NSURLRequest requestWithURL:testURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20.0];
    NSURLConnection *testConnection = [[[NSURLConnection alloc] initWithRequest:testRequest delegate:nil] autorelease];
    
    return ((isReachable && !needsConnection) || nonWiFi) ? (testConnection ? YES : NO) : NO;
}

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
