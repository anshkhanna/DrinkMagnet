#import "ConnectionManager.h"
#import "AFXMLRequestOperation.h"
#import "DrinkMagnetUtils.h"
#import "APIConstants.h"
#import "AppDelegate.h"

@interface ConnectionManager()
{
    NSMutableArray *activeRequests;
}
- (void)showHUDwithText:(NSString *)text;
@end

@implementation ConnectionManager

@synthesize delegate;

#pragma mark -
#pragma mark  

- (id)init
{
	NSLog(@"ConnectionManager : init");
	
    self = [super init];
	
    if(!self)
	{
		return nil;
	} 
    
    activeRequests = [[NSMutableArray alloc] init];
	return self;
}

-(void)getBarsNearCoordinate:(CLLocationCoordinate2D)locaionCoordinate
{
    NSLog(@"Connection Manager : getBarsNearCoordinate");

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@lat=%f&long=%f",DrinkMagnetBarsAPI, locaionCoordinate.latitude, locaionCoordinate.longitude]]];
    AFXMLRequestOperation *operation = [AFXMLRequestOperation XMLParserRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSXMLParser *XMLParser) {
        XMLParser.delegate = self;
        [XMLParser parse];
    } failure:nil];
    [operation start];
}

-(void)getBarsNearZipcode:(NSString*)zipCode
{
    NSLog(@"Connection Manager : getBarsNearCoordinate");
    
    /*if (![DrinkMagnetUtils isConnectedToInternet])
     {
     [DrinkMagnetUtils showAlertMessage:@"No Network!"];
     return;
     }*/
    
	[self showHUDwithText:@""];
    
	NSURL *url= [NSURL URLWithString:[NSString stringWithFormat:@"%@zipcode=%@",
                                      DrinkMagnetBarsAPI, zipCode]];
    
}

#pragma mark -
#pragma mark ASIHTTPRequest functions

- (void)requestFinished:(AFXMLRequestOperation *)request
{
	NSLog(@"Connection Manager : requestFinished");       
	if(delegate!=nil && [delegate respondsToSelector:@selector(httpRequestFinished:)])
    [delegate httpRequestFinished:request];
            
    if([activeRequests containsObject:request])
    [activeRequests removeObject:request];

}

- (void)requestFailed:(AFXMLRequestOperation *)request
{
	NSLog(@"Connection Manager : requestFailed");

    if(delegate!=nil && [delegate respondsToSelector:@selector(httpRequestFailed:)])
    [delegate httpRequestFailed:request];
    
    if([activeRequests containsObject:request]) 
    [activeRequests removeObject:request];
}

#pragma mark -
#pragma mark DEALLOC

- (void)dealloc
{
	NSLog(@"Connection Manager : dealloc");
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    for(AFXMLRequestOperation *request in activeRequests)
    {
         NSLog(@"Active Request Cancelling");
        [request cancel];
    }
    
    [activeRequests release];
     activeRequests = nil;
    self.delegate=nil;
        
	[super dealloc];
}

@end