#import "Special.h"

@implementation Special

@synthesize specialid;
@synthesize description;
@synthesize startTime;
@synthesize endTime;

-(void)dealloc
{
    [specialid release];
    [description release];
    [startTime release];
    [endTime release];
    
    [super dealloc];
}

@end
