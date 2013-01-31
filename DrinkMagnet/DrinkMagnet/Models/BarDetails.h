//
//  BarDetails.h
//  DrinkMagnet
//
//  Created by Manigandan Parthasarathi on 12/01/13.
//  Copyright (c) 2013 WinkApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Special.h"

@interface BarDetails : NSObject

/*"address" : "4306 Yoakum Blvd, Houston, TX 77006, USA",
 "barid" : "13",
 "barname" : "Nicks house",
 "distance" : "0",
 "phone" : "425-260-4472",
 "photoloc" : "",
 "zipcode" : "77006"*/

@property(nonatomic, retain) NSString* name;
@property(nonatomic, retain) NSString* barid;
@property(nonatomic, retain) NSString* address;
@property(nonatomic, retain) NSString* phone;
@property(nonatomic, retain) NSString* zipcode;
@property(nonatomic, retain) NSString* imageUrl;
@property(nonatomic, retain) Special* special;

@end
