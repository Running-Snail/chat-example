//
//  CEChatClient.h
//  ChatExample
//
//  Created by Jay on 7/31/16.
//  Copyright © 2016 Jay. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CEChatClientDelegate <NSObject>

- (void)onReceivedMessage:(NSString *)msg;

@end

@interface CEChatClient : NSObject

@property (nonatomic, weak) id<CEChatClientDelegate> delegate;

- (void)initWithHost:(NSString *)host port:(int)port;
- (void)send:(NSString *)msg withNickname:(NSString *)nickname;

@end
