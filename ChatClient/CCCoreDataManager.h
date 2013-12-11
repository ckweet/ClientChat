//
//  CCCoreDataManager.h
//  ChatClient
//
//  Created by Victor on 09.12.13.
//  Copyright (c) 2013 Victor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCAppDelegate.h"
@class Message;

@interface CCCoreDataManager : NSObject

@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContex;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

-(void)saveMessageToDB:(Message*)message;
-(NSArray*)allMassegesFromDB;
-(void)deleteAllMessages;

+ (CCCoreDataManager*)sharedInstance;

+(instancetype) alloc __attribute__((unavailable("alloc not available, call sharedInstance instead")));
-(instancetype) init __attribute__((unavailable("init not available, call sharedInstance instead")));
+(instancetype) new __attribute__((unavailable("new not available, call sharedInstance instead")));



@end
