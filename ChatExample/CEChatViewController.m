//
//  CEChatViewController.m
//  ChatExample
//
//  Created by Jay on 7/31/16.
//  Copyright © 2016 Jay. All rights reserved.
//

#import "CEChatViewController.h"
#import "Masonry.h"

#import "CEChatClient.h"
#import "CESigninViewController.h"

@interface CEChatViewController () <UITextFieldDelegate, CEChatClientDelegate, CESigninDelegate>

@property (strong, nonatomic) UILabel *nicknameLabel;
@property (strong, nonatomic) UILabel *messages;
@property (strong, nonatomic) UITextField *messageTextField;
@property (strong, nonatomic) CEChatClient *chatClient;
@property (strong, nonatomic) CESigninViewController *signinVC;

@property (strong, nonatomic) NSString *nickname;

@end

@implementation CEChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.nicknameLabel];
    [self.view addSubview:self.messages];
    [self.view addSubview:self.messageTextField];
    
    [self.messageTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(20.0f);
        make.right.equalTo(self.view.mas_right).with.offset(-20.0f);
        make.height.equalTo(@30.0f);
        make.top.equalTo(self.view.mas_top).with.offset(20.0f);
    }];
    
    [self.nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(20.0f);
        make.right.equalTo(self.view.mas_right).with.offset(-20.0f);
        make.top.equalTo(self.messageTextField.mas_bottom);
        make.height.equalTo(@30.0f);
    }];
    
    [self.messages mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nicknameLabel.mas_bottom);
        make.left.equalTo(self.view.mas_left).with.offset(20.0f);
        make.right.equalTo(self.view.mas_right).with.offset(-20.0f);
    }];
    
    [self.chatClient initWithHost:@"localhost" port:8090];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSString *nickname = self.nickname;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)appendChatLineWithNickname:(NSString *)nickname message:(NSString *)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *line = [NSString stringWithFormat:@"\n%@: %@", nickname, message];
        self.messages.text = [self.messages.text stringByAppendingString:line];
        [self.messages sizeToFit];
    });
}

- (void)sayHi {
    [self.chatClient send:@"I'm here" withNickname:self.nickname];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"returned");
    [self.chatClient send:textField.text withNickname:self.nickname];
    return YES;
}

- (void)onReceivedMessage:(NSString *)msg {
    NSLog(@"onReceivedMessage %@", msg);
    NSData *msgData = [msg dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:msgData options:0 error:&error];
    [self appendChatLineWithNickname:data[@"nickname"] message:data[@"msg"]];
}

- (void)onNicknameEntered:(NSString *)nickname {
    _nickname = nickname;
    self.nicknameLabel.text = nickname;
    [self.signinVC dismissViewControllerAnimated:YES completion:nil];
    [self sayHi];
}

#pragma mark lazy loads
- (UILabel *)nicknameLabel {
    if (_nicknameLabel == nil) {
        _nicknameLabel = [[UILabel alloc] init];
        _nicknameLabel.text = @"";
    }
    return _nicknameLabel;
}

- (UILabel *)messages {
    if (_messages == nil) {
        _messages = [[UILabel alloc] init];
        _messages.numberOfLines = -1;
        
        _messages.text = @"hello!";
        [_messages sizeToFit];
    }
    return _messages;
}

- (UITextField *)messageTextField {
    if (_messageTextField == nil) {
        _messageTextField = [[UITextField alloc] init];
        _messageTextField.returnKeyType = UIReturnKeySend;
        [_messageTextField setPlaceholder:@"Enter message here"];
        [_messageTextField setDelegate:self];
    }
    return _messageTextField;
}

- (CEChatClient *)chatClient {
    if (_chatClient == nil) {
        _chatClient = [CEChatClient alloc];
        [_chatClient setDelegate:self];
    }
    return _chatClient;
}

- (NSString *)nickname {
    if (_nickname == nil) {
        [self presentViewController:self.signinVC animated:YES completion:nil];
        return nil;
    }
    return _nickname;
}

- (CESigninViewController *)signinVC {
    if (_signinVC == nil) {
        _signinVC = [[CESigninViewController alloc] init];
        _signinVC.signinDelegate = self;
    }
    return _signinVC;
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
