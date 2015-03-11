#import <UIKit/UIKit.h>

@class R1EmitterLineItem;
@protocol REEventLineItemEditorViewControllerDelegate;

@interface REEventLineItemEditorViewController : UITableViewController

@property (nonatomic, assign) id<REEventLineItemEditorViewControllerDelegate> delegate;

- (id) initWithNewLineItem;
- (id) initWithLineItem:(R1EmitterLineItem *) lineItem;

@end

@protocol REEventLineItemEditorViewControllerDelegate <NSObject>

- (void) eventLineItemEditorViewControllerDidCancelled:(REEventLineItemEditorViewController *) eventLineItemEditorViewController;
- (void) eventLineItemEditorViewController:(REEventLineItemEditorViewController *) eventLineItemEditorViewController didFinishedWithLineItem:(R1EmitterLineItem *) lineItem;

@end
