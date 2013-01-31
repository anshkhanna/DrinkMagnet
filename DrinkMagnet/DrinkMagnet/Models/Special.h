#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Special : NSObject

/*
 "description" : "Cheap beer",
 "eampm" : "PM",
 "ends" : "585",
 "fri" : "0",
 "mon" : "0",
 "price" : "6.25",
 "sampm" : "PM",
 "sat" : "0",
 "specialid" : "10",
 "starts" : "420",
 "sun" : "1",
 "thu" : "1",
 "tue" : "1",
 "wed" : "1"
*/

@property(nonatomic, retain) NSString* specialid;
@property(nonatomic, retain) NSString* description;
@property(nonatomic, retain) NSString* startTime;
@property(nonatomic, retain) NSString* endTime;

@end
