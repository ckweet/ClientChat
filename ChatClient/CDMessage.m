//
//  CDMessage.m
//  ChatClient
//
//  Created by Victor on 09.12.13.
//  Copyright (c) 2013 Victor. All rights reserved.
//

#import "CDMessage.h"
#import "Message.h"

@implementation CDMessage

@dynamic messageId;
@dynamic messageText;
@dynamic sendDate;
@dynamic userId;
@dynamic isMine;

+(id)createWithMessage:(Message*)message andContext:(id)managedObjectContext
{
    CDMessage *newMassege = [NSEntityDescription insertNewObjectForEntityForName:@"CDMessage" inManagedObjectContext:managedObjectContext];
    
    if (newMassege) {
        newMassege.userId = [NSNumber numberWithInteger:message.userId];
        newMassege.messageId = [NSNumber numberWithInteger:message.messageId];
        newMassege.messageText = message.messageText;
        newMassege.sendDate = message.sendDate;
        newMassege.isMine = [NSNumber numberWithBool:message.isMine];
        return newMassege;
    }    
    return nil;
}

@end
