//
//  BarDetails.m
//  DrinkMagnet
//
//  Created by Manigandan Parthasarathi on 12/01/13.
//  Copyright (c) 2013 WinkApps. All rights reserved.
//

#import "BarDetails.h"

@implementation BarDetails

@synthesize name;
@synthesize barid;
@synthesize address;
@synthesize phone;
@synthesize zipcode;
@synthesize imageUrl;
@synthesize special;

-(id)init
{
    self = [super init];
    
    if(self)
    {
        special = [[Special alloc] init];
    }
    
    return self;
}

-(void)dealloc
{
    [name release];
    [barid release];
    [address release];
    [phone release];
    [zipcode release];
    [imageUrl release];
    [special release];
    
    [super dealloc];
}

@end