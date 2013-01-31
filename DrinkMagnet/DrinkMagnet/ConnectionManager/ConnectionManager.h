#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreData/CoreData.h>
#import "AFNetworking.h"


@protocol ConnectionManagerDelegate;

@interface ConnectionManager : NSObject
<NSURLConnectionDelegate, NSURLConnectionDataDelegate,NSXMLParserDelegate>
{	
	id<ConnectionManagerDelegate> delegate;
}

@property (nonatomic, assign) id<ConnectionManagerDelegate> delegate;


-(void)getBarsNearCoordinate:(CLLocationCoordinate2D)locaionCoordinate;
-(void)getBarsNearZipcode:(NSString*)zipCode;

@end

@protocol ConnectionManagerDelegate<NSObject>

- (void)httpRequestFinished:(AFXMLRequestOperation *)request;
- (void)httpRequestFailed:(AFXMLRequestOperation *)request;

@end
