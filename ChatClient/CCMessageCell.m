//
//  CCMessageCell.m
//  ChatClient
//
//  Created by Victor on 09.12.13.
//  Copyright (c) 2013 Victor. All rights reserved.
//

#import "CCMessageCell.h"

@implementation CCMessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
