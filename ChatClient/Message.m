#import "Message.h"

@implementation Message

-(void)dealloc
{
	self.messageText = nil;
	self.sendDate = nil;
}

@end