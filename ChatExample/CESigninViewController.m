//
//  CESigninViewController.m
//  ChatExample
//
//  Created by Jay on 7/31/16.
//  Copyright © 2016 Jay. All rights reserved.
//

#import "CESigninViewController.h"
#import "Masonry.h"

@interface CESigninViewController () <UITextFieldDelegate>

@property (strong, nonatomic) UITextField *nicknameTextField;

@end

@implementation CESigninViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.nicknameTextField];
    
    [self.nicknameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(20.0f);
        make.right.equalTo(self.view.mas_right).with.offset(-20.0f);
        make.top.equalTo(self.view.mas_top).with.offset(20.0f);
        make.height.equalTo(@30.0f);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.signinDelegate) {
        [self.signinDelegate onNicknameEntered:textField.text];
    }
    [self.view endEditing:YES];
    return YES;
}

- (UITextField *)nicknameTextField {
    if (_nicknameTextField == nil) {
        _nicknameTextField = [[UITextField alloc] init];
        [_nicknameTextField setPlaceholder:@"Enter nickname here"];
        [_nicknameTextField setDelegate:self];
        [_nicknameTextField setReturnKeyType:UIReturnKeyDone];
    }
    return _nicknameTextField;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
