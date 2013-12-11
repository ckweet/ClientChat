//
//  CCViewController.h
//  ChatClient
//
//  Created by Victor on 09.12.13.
//  Copyright (c) 2013 Victor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Network.h"

@interface CCViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,NetworkDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
