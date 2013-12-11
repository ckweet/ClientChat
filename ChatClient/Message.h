
@interface Message : NSObject

@property(nonatomic, assign) NSInteger messageId;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, retain) NSString *messageText;
@property (nonatomic, retain) NSDate *sendDate;
@property (nonatomic, assign) BOOL isMine;

@end
