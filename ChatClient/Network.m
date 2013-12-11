
#import "Network.h"
#import "Message.h"

@interface Network ()

@property (nonatomic, strong) NSArray *messages;

@end

@implementation Network

-(id)init
{
	self = [super init];
	if (self)
	{
		self.messages = @[ @"Hello", @"How are you?", @"I'm fine"];
        [self generateMessage];        
	}
	return self;
}

-(void)generateMessage
{
	//loop for generation messages with some delay
    double delayInSeconds = 2.0 + rand() % 4;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        Message *receivedMessage = [Message new];
        receivedMessage.messageId = rand();
        receivedMessage.messageText = [self.messages objectAtIndex:rand() % [self.messages count]];
        receivedMessage.isMine = NO;
        receivedMessage.sendDate = [NSDate dateWithTimeIntervalSinceNow:-(rand() % 10)];
        receivedMessage.userId = 2;
        [self.delegate didReceiveMessage:receivedMessage];
//        [receivedMessage release];
        
        [self generateMessage];
    });
}


-(void)sendMessage:(Message*)message
{
	sleep(1 + rand() % 10);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        Message *sentMessage = [Message new];
        sentMessage.messageId = rand();
        sentMessage.messageText = message.messageText;
        sentMessage.isMine = YES;
        sentMessage.sendDate = message.sendDate;
        sentMessage.userId = 1;
        [self.delegate didSendMessage:sentMessage initialMessage:message];
//        [sentMessage release];
    });
}



@end
