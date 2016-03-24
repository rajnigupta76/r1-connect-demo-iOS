#import <UIKit/UIKit.h>
#import "R1Inbox.h"

@protocol R1SampleInboxViewControllerDelegate;

@interface R1SampleInboxViewController : UITableViewController <R1InboxMessagesDelegate>

@property (nonatomic, assign) id<R1SampleInboxViewControllerDelegate> inboxDelegate;

- (id) initInboxViewController;

@end

@protocol R1SampleInboxViewControllerDelegate <NSObject>

- (void) sampleInboxViewControllerDidFinished:(R1SampleInboxViewController *) sampleInboxViewController;

@end
