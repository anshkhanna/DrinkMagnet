#import <UIKit/UIKit.h>

@protocol BottomBarDelegate;

@interface BottomBarView : UIView<UITextFieldDelegate>
{
    UIButton *btnSlideUp;
    UIButton *btnNow;
    UIButton *btnLater;
    UIButton *btnAddSpecial;
    
    UIView *locationView;
    UITextField *locationField;
    
    UITextField *zipField;
    
    NSUInteger previousSelectedIndex;
    
    id<BottomBarDelegate>delegate;
    
    UILabel *code1;
    UILabel *code2;
    UILabel *code3;
    UILabel *code4;
    UILabel *code5;
}

@property (nonatomic, assign)id<BottomBarDelegate>delegate;

-(void)slideLocationViewUp;
-(void)slideLocationViewDown;
-(void)makeZipFieldAsFirstResponder:(BOOL)status;

@end

@protocol BottomBarDelegate <NSObject>

-(void)slideUpPressed:(BottomBarView*)bottomBarView;
-(void)addPressed:(BottomBarView*)bottomBarView;
-(void)laterPressed:(BottomBarView*)bottomBarView;
-(void)nowPressed:(BottomBarView*)bottomBarView;
-(void)locatingPressed:(BottomBarView*)bottombarView;

@end
