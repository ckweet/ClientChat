//
//  CCCoreDataManager.m
//  ChatClient
//
//  Created by Victor on 09.12.13.
//  Copyright (c) 2013 Victor. All rights reserved.
//

#import "CCCoreDataManager.h"
#import "CDMessage.h"

@implementation CCCoreDataManager

@synthesize managedObjectContex = _managedObjectContex;

-(NSManagedObjectContext *)managedObjectContex
{
    return [(CCAppDelegate*) [[UIApplication sharedApplication] delegate] managedObjectContext];
}

+ (CCCoreDataManager *)sharedInstance
{
    static CCCoreDataManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[super alloc] initUniqueInstance];
    });
    return sharedInstance;
}

-(instancetype) initUniqueInstance {
    return [super init];
}

-(void)saveMessageToDB:(Message *)message
{
    CDMessage *newMessage = [CDMessage createWithMessage:message andContext:self.managedObjectContex];
    
    if (newMessage) {
        [self.managedObjectContex save:nil];
        NSLog(@"created and saved");
    }
    else
        NSLog(@"not created");
}

-(NSArray *)allMassegesFromDB
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"CDMessage"];
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"sendDate" ascending:NO]];
//    [fetchRequest setFetchLimit:1];
    NSArray *resultMessages = [self.managedObjectContex executeFetchRequest:fetchRequest error:nil];
    if (!resultMessages) {
        return nil;
    }
    NSLog(@"all messages");
    return resultMessages;
}

-(void)deleteAllMessages
{
    for (CDMessage *obj in [self allMassegesFromDB]) {
        [self.managedObjectContex deleteObject:(NSManagedObject*)obj];
    }
    [self.managedObjectContex save:nil];
}



@end
