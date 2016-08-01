//
//  CEChatClient.m
//  ChatExample
//
//  Created by Jay on 7/31/16.
//  Copyright © 2016 Jay. All rights reserved.
//

#import "CEChatClient.h"

@interface CEChatClient () <NSStreamDelegate>

@property (strong, nonatomic) NSInputStream *inputStream;
@property (strong, nonatomic) NSOutputStream *outputStream;

@end

@implementation CEChatClient

- (void)initWithHost:(NSString *)host port:(int)port {
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)host, port, &readStream, &writeStream);
    _inputStream = (__bridge NSInputStream *)readStream;
    [_inputStream setDelegate:self];
    _outputStream = (__bridge NSOutputStream *)writeStream;
    [_outputStream setDelegate:self];
    [_inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [_outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [_inputStream open];
    [_outputStream open];
}

- (void)send:(NSString *)msg withNickname:(NSString *)nickname {
    if (nickname == nil || msg == nil) {
        return;
    }
    NSDictionary *dict = @{
                           @"nickname": nickname,
                           @"msg": msg
                           };
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    [_outputStream write:data.bytes maxLength:data.length];
}

- (NSString *)readInput {
    uint8_t buffer[1024];
    long len;
    NSString *output;
    
    while ([_inputStream hasBytesAvailable]) {
        len = [_inputStream read:buffer maxLength:sizeof(buffer)];
        if (len > 0) {
            
            output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
        }
    }
    return output;
}

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode {
    switch (eventCode) {
        case NSStreamEventOpenCompleted:
            NSLog(@"Stream opened");
            break;
        case NSStreamEventHasBytesAvailable:
            if (aStream == _inputStream) {
                NSString *msg = [self readInput];
                NSLog(@"%@", msg);
                if (self.delegate) {
                    [self.delegate onReceivedMessage:msg];
                }
            }
            break;
        case NSStreamEventErrorOccurred:
            NSLog(@"Can not connect to the host!");
            break;
        case NSStreamEventEndEncountered:
            break;
        default:
            NSLog(@"Unknown event %ld", eventCode);
    }
}

@end

