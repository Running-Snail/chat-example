//
//  CESigninViewController.h
//  ChatExample
//
//  Created by Jay on 7/31/16.
//  Copyright © 2016 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CEBaseViewController.h"

@protocol CESigninDelegate <NSObject>

- (void)onNicknameEntered:(NSString *)nickname;

@end

@interface CESigninViewController : CEBaseViewController

@property (nonatomic, weak) id<CESigninDelegate> signinDelegate;

@end
