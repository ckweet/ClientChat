
#import "Message.h"

@protocol NetworkDelegate <NSObject>

-(void)didReceiveMessage:(Message*)message;
-(void)didSendMessage:(Message*)sentMessage initialMessage:(Message*)message;

@end

@interface Network : NSObject

@property (nonatomic, assign) id<NetworkDelegate> delegate;

-(void)sendMessage:(Message*)message;

@end
