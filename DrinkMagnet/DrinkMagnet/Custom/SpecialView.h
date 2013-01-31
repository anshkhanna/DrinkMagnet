#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "AsyncImageView.h"
#import "Special.h"
#import "BarDetails.h"

@protocol SpecialsViewDelegate <NSObject>

@optional
-(void)specialTappedAtIndex:(NSUInteger)index;
-(void)specialDismissedAtIndex:(NSUInteger)index;
-(void)pushMapWithLocaiton:(CLLocationCoordinate2D)aLocation;

@end

@interface SpecialView : UIView<UIAlertViewDelegate, AsyncImageDelegate>
{
    AsyncImageView *barImageView;
    
    UIView *barNameView;
    UILabel *nameLabel;
    
    UIView *callView;
    UILabel *callLabel;
    
    UIView *addressView;
    UILabel *addressLabel;
    
    UIView *compassView;
    UIImageView *compassBodyImage;
    UIImageView *compassNeedleImage;
    UILabel *distanceLabel;
    
    UIView *offerView;
    UILabel *offerLabel;
    
    UIView *timeRemainingView;
    UILabel *timeRemainingLabel;
    
    UIView *specialNameView;
    UILabel *specialName;
    
    UIView *photosView;
    UIView *checkinView;
    
    UITapGestureRecognizer *tap;

    id<SpecialsViewDelegate>delegate;
    
    NSTimer *countDownTimer;
    NSDate *endDate;
    NSDate *currentDate;
    UILabel *lblPhotos;
    
    BOOL isOptionsOpen;
    
    UITapGestureRecognizer *callTapGesture;
    UITapGestureRecognizer *mapViewTapped;
}

@property (nonatomic,assign)id<SpecialsViewDelegate>delegate;

@property (nonatomic,assign) NSUInteger specialIndex;

-(void)setImageUrl:(NSString*)imageUrl;
-(void)setSpecialwithBarDetails:(BarDetails*)barDetails;
-(void)setSpecial:(Special*)aSpecial;

-(void)showOptions:(BOOL)animated;
-(void)hideOptions:(BOOL)animated;

@end
