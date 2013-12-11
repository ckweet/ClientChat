//
//  CDMessage.h
//  ChatClient
//
//  Created by Victor on 09.12.13.
//  Copyright (c) 2013 Victor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@class Message;


@interface CDMessage : NSManagedObject

@property (nonatomic, retain) NSNumber * messageId;
@property (nonatomic, retain) NSString * messageText;
@property (nonatomic, retain) NSDate * sendDate;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSNumber * isMine;

+(id)createWithMessage:(Message*)message andContext:managedObjectContext;

@end
