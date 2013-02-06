#import "Special.h"

@implementation Special

@synthesize specialid;
@synthesize description;
@synthesize startTime;
@synthesize endTime;
@synthesize price;

-(void)dealloc
{
    [specialid release];
    [description release];
    [startTime release];
    [endTime release];
    [price release];
    [super dealloc];
}

@end
