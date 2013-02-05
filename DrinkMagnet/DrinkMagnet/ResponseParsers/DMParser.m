#import "DMParser.h"
#import "SBJSON.h"
#import "DrinkMagnetConstants.h"
#import "BarDetails.h"

@implementation DMParser

+ (NSArray*)parseBarDetailsResponseForArray:(NSArray*)response
{
    SBJSON *sbJSON= [SBJSON new];


	NSArray *resultsArray= response;
    [sbJSON release];
    
    NSMutableArray *dataArray = [[[NSMutableArray alloc]init] autorelease];
    
    if([resultsArray count] > 0)
    {
        for(int i = 0; i < [resultsArray count]; i++)
        {
            BarDetails *barDetails = [[BarDetails alloc]init];
            
            NSDictionary *dict = [resultsArray objectAtIndex:i];
            
            NSDictionary *barDict = [dict objectForKey:@"bar"];
            barDetails.name = [barDict objectForKey:@"barname"];
            barDetails.barid = [barDict objectForKey:@"barid"];
            barDetails.address = [barDict objectForKey:@"address"];
            barDetails.phone = [barDict objectForKey:@"phone"];
            barDetails.zipcode = [barDict objectForKey:@"zipcode"];
            //barDetails.imageUrl = [barDict objectForKey:@"photoloc"];
            barDetails.imageUrl = @"http://www.thursdayclub.com/Pictures/no5.jpg";
            
            NSArray *specialsArray = [dict objectForKey:@"special"];
            NSDictionary *sepcialDict = [specialsArray objectAtIndex:0];
            barDetails.special.specialid = [sepcialDict objectForKey:@"specialid"];
            barDetails.special.description = [sepcialDict objectForKey:@"description"];
            barDetails.special.startTime = [sepcialDict objectForKey:@"starts"];
            barDetails.special.endTime = [sepcialDict objectForKey:@"ends"];
            
            [dataArray addObject:barDetails];
            [barDetails release];
        }
        return (NSArray *)dataArray;
    }
    
    else
        return nil;
}

@end