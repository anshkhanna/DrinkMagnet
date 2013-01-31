#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import "ImageCacher.h"

@protocol ImageDownloaderDelegate;
@interface ImageDownloader : NSObject
{
    id<ImageDownloaderDelegate> delegate;
    
@private
    NSString *imageUrl;
    NSString *cacheKey; // key for image cache dictionary
    UIImage *image;
    int currentTag;
}

@property(nonatomic,assign)id<ImageDownloaderDelegate> delegate;
@property(nonatomic,retain)NSString *imageUrl;
@property(nonatomic,copy) NSString *cacheKey;
@property(nonatomic,retain)UIImage *image;

-(id)initWithImageUrl:(NSString*)imageUrl delegate:(id)delegate;
-(void)startLoadingImageFromUrl:(NSString*)url;
-(void)startLoadingImageFromUrl:(NSString*)url useCache:(BOOL)useCache;
-(void)startLoadingImageUsingCache:(BOOL)useCache;
@end


@protocol ImageDownloaderDelegate <NSObject>

-(void)imageDownloader:(ImageDownloader*)downloader retrievedImage:(UIImage*)image fromCache:(BOOL)cache;

@optional
-(void)imageDownloaderFailed:(ImageDownloader *)downloader;
@end