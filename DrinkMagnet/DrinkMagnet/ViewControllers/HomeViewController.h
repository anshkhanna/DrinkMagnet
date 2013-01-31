#import <UIKit/UIKit.h>
#import "BottomBarView.h"
#import "AddSpecialView.h"
#import <CoreLocation/CoreLocation.h>
#import "PinCodeViewController.h"
#import "SpecialView.h"
#import "PagedFlowView.h"
#import "ConnectionManager.h"
#import "MBProgressHUD.h"

@interface HomeViewController : UIViewController
<BottomBarDelegate,AddSpecialsDelegate, CLLocationManagerDelegate, PinCodeDelegate, SpecialsViewDelegate, PagedFlowViewDelegate,PagedFlowViewDataSource, UITextFieldDelegate, ConnectionManagerDelegate,MBProgressHUDDelegate>
{
    NSMutableArray *imageUrls;
    BOOL isAddViewOpen;
    BOOL bottombarOnTop;
    ConnectionManager *connectionManager;
    NSMutableArray *barDetailsArray;
    MBProgressHUD *hud;
}

-(IBAction)infoButtonTapped:(id)sender;

@property (retain, nonatomic) IBOutlet PagedFlowView *specialsPageFlowView;
@property (retain, nonatomic) IBOutlet UIView *locationView;
@property (retain, nonatomic) IBOutlet UIView *locationTitleView;
@property (retain, nonatomic) IBOutlet UIView *dragCancelView;

@property (retain, nonatomic) IBOutlet UITextField *pincodeField;
@property (retain, nonatomic) IBOutlet UILabel *code1;
@property (retain, nonatomic) IBOutlet UILabel *code2;
@property (retain, nonatomic) IBOutlet UILabel *code3;
@property (retain, nonatomic) IBOutlet UILabel *code4;
@property (retain, nonatomic) IBOutlet UILabel *code5;
@property (nonatomic, retain) IBOutlet UIButton *btnInfo;
@property (retain)MBProgressHUD *hud;
@end
