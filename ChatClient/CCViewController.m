//
//  CCViewController.m
//  ChatClient
//
//  Created by Victor on 09.12.13.
//  Copyright (c) 2013 Victor. All rights reserved.
//

#import "CCViewController.h"
#import "CCCoreDataManager.h"
#import "CCAppDelegate.h"
#import "Message.h"
#import "CDMessage.h"
#import "CCMessageCell.h"

@interface CCViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textToSend;

@property (nonatomic, strong) NSMutableArray *messages;
@property (nonatomic, strong) NSMutableArray *uploadingMessages;
@property (nonatomic,strong) CCCoreDataManager *coreDataManager;
@property (nonatomic, strong) Network *network;
@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic,strong) NSBlockOperation *tempBlockOperation;

@end

@implementation CCViewController

@synthesize tableView = _tableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.network = [[Network alloc] init];
    self.network.delegate = self;
    
    self.operationQueue = [[NSOperationQueue alloc] init];

    self.coreDataManager = [CCCoreDataManager sharedInstance];
    
    self.messages = [[NSMutableArray alloc] init];
    self.uploadingMessages = [[NSMutableArray alloc] init];
    [self loadDataFromDB];
    
    NSLog(@"count: %i",[[self.coreDataManager allMassegesFromDB]count]);
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - load data from db

-(void)loadDataFromDB
{
    self.messages = [NSMutableArray arrayWithArray:[self.coreDataManager allMassegesFromDB]];
}

#pragma mark - TableView Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.messages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
   
    NSString *cellStr = [[[self.messages objectAtIndex:indexPath.row] valueForKey:@"isMine"] isEqualToNumber:[NSNumber numberWithBool:YES]]?@"MyCell":@"Cell";
    
    CCMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr forIndexPath:indexPath];
    
    if ([[[self.messages objectAtIndex:indexPath.row] valueForKey:@"isMine"] isEqualToNumber:[NSNumber numberWithBool:YES]]) {
        cell.nameField.text = @"me";
    }
    else
        cell.nameField.text = @"bot";
    
    cell.textField.text = [[self.messages objectAtIndex:indexPath.row] valueForKey:@"messageText"];
    cell.dateField.text = [self dateToString:[[self.messages objectAtIndex:indexPath.row] valueForKey:@"sendDate"]];
    
    if ([self.uploadingMessages containsObject:[self.messages objectAtIndex:indexPath.row]]) {
        cell.activityIndicator.hidden = NO;
        [cell.activityIndicator startAnimating];
    }
    else
    {
        cell.activityIndicator.hidden = YES;
        [cell.activityIndicator stopAnimating];
    }
    
    return cell;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self sendMessage];
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - IBActions

-(IBAction)deleteButton:(id)sender
{
    [self.coreDataManager deleteAllMessages];
    
    [self.messages removeAllObjects];
//    self.messages = nil;
    [self.tableView reloadData];
}

-(IBAction)sendButton:(id)sender
{
    NSLog(@"%@",self.textToSend.text);
    [self sendMessage];
}

-(void)sendMessage
{
    if ([self.textToSend.text length] > 0) {
        Message *myMessage = [Message new];
        myMessage.messageText = self.textToSend.text;
        myMessage.isMine = YES;
        myMessage.sendDate = [NSDate date];
        [self.messages addObject:myMessage];
        [self.uploadingMessages addObject:myMessage];
        
        self.messages = [self sortMessagesByDate:self.messages];
        [self.tableView reloadData];
        
        NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
            [self.network sendMessage:myMessage];
        }];
        
        if (self.tempBlockOperation == nil) {
            self.tempBlockOperation = blockOperation;
        }
        else
        {
            [blockOperation addDependency:self.tempBlockOperation];
            self.tempBlockOperation = blockOperation;
        }
        
        [self.operationQueue addOperation:blockOperation];
        self.textToSend.text = @"";
        [self.view endEditing:YES];
    }
}

#pragma mark - Networ Delegate
-(void)didReceiveMessage:(Message*)message
{
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self.messages addObject:message];
        self.messages = [self sortMessagesByDate:self.messages];
        [self.tableView reloadData];
        [self.coreDataManager saveMessageToDB:message];
//        NSLog(@"count: %i",[[self.coreDataManager allMassegesFromDB]count]);
    });
}

-(void)didSendMessage:(Message*)sentMessage initialMessage:(Message*)message
{
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self.coreDataManager saveMessageToDB:sentMessage];
        [self.uploadingMessages removeObject:message];
        [self.tableView reloadData];
//        NSLog(@"count: %i",[[self.coreDataManager allMassegesFromDB]count]);
    });
    
}

-(NSString*)dateToString:(NSDate*)date
{
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    dateFormater.dateFormat = @"hh:mm:ss";
    [dateFormater setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormater setTimeStyle:NSDateFormatterMediumStyle];
    return [dateFormater stringFromDate:date];
}

#pragma mark - sorting

-(NSMutableArray *)sortMessagesByDate:(NSArray *)array
{
    if ([array count] == 1) {
        return [NSMutableArray arrayWithArray:array];
    }
    NSArray *sortedArray = [array sortedArrayUsingComparator: ^(Message *d1, Message *d2) {
        return [d2.sendDate compare:d1.sendDate];
    }];
    return [NSMutableArray arrayWithArray:sortedArray];
    
//    NSArray *sortDescriptor = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"self.sendDate" ascending:NO]];
//    return [NSMutableArray arrayWithArray:[array sortedArrayUsingDescriptors:sortDescriptor]];
}

@end
