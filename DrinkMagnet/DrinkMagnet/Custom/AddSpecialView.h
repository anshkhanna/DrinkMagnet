//
//  AddSpecialView.h
//  DrinkMagnet
//
//  Created by Puneet Sharma on 20/09/12.
//  Copyright (c) 2012 WinkApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSPicker.h"

@protocol AddSpecialsDelegate;

@interface AddSpecialView : UIScrollView<UITextFieldDelegate,PSPickerDelegate>{
    id <AddSpecialsDelegate>delegate;
}

@property (nonatomic,assign) id <AddSpecialsDelegate> delegate;

@end

@protocol AddSpecialsDelegate <NSObject>

-(void)dismissAddView:(AddSpecialView*)view;

@end
