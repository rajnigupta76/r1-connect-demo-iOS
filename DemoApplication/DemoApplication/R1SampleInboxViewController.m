#import "R1SampleInboxViewController.h"
#import "R1SampleInboxTableViewCell.h"
#import "R1Inbox.h"

@interface R1SampleInboxViewController ()

@property (nonatomic, strong) R1InboxMessages *inboxMessages;

@end

@implementation R1SampleInboxViewController

// Initialize UITableViewController
- (id) initInboxViewController
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self)
    {
        self.inboxMessages = [R1Inbox sharedInstance].messages;
        
        [self updateTitle];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                              target:self action:@selector(closeInboxViewController)];
    }
    return self;
}

// Called when user presses 'Done' button
- (void) closeInboxViewController
{
    [self.inboxDelegate sampleInboxViewControllerDidFinished:self];
}

// Updates the title of ViewController with number of unread messages
- (void) updateTitle
{
    if (self.inboxMessages.unreadMessagesCount == 0)
        self.navigationItem.title = @"Inbox";
    else
        self.navigationItem.title = [NSString stringWithFormat:@"Inbox (%lu unread)", (unsigned long)self.inboxMessages.unreadMessagesCount];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateTitle];

    // Add this view controller to the list of delegates when it appears
    [self.inboxMessages addDelegate:self];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    // Remove this view controller from the list of delegates when it disappears
    [self.inboxMessages removeDelegate:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Returns the total number of Inbox messages
    return self.inboxMessages.messagesCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Returns the calculated height of the cell for R1InboxMessage object in row
    return [R1SampleInboxTableViewCell heightForCellWithInboxMessage:[self.inboxMessages.messages objectAtIndex:indexPath.row]
                                                           cellWidth:self.tableView.frame.size.width];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    R1SampleInboxTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil)
    {
        cell = [[R1SampleInboxTableViewCell alloc] initWithReuseIdentifier:@"Cell"];
    }
    
    // Sets up the cell for displaying R1InboxMessage object
    cell.inboxMessage = [self.inboxMessages.messages objectAtIndex:indexPath.row];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    R1InboxMessage *message = [self.inboxMessages.messages objectAtIndex:indexPath.row];

    // Shows Inbox message when user interacts to the cell
    [[R1Inbox sharedInstance] showMessage:message
                           messageDidShow:^{
                               [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
                           }];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    R1InboxMessage *message = [self.inboxMessages.messages objectAtIndex:indexPath.row];
    
    [self.inboxMessages deleteMessage:message];
}

#pragma mark - R1InboxMessagesDelegate methods

// This method called when the list of Inbox messages gets updated
- (void) inboxMessagesWillChanged
{
    [self.tableView beginUpdates];
}

// This method called when any item in the list of Inbox messages gets changed (modified, inserted or removed)
- (void) inboxMessagesDidChangeMessage:(R1InboxMessage *) inboxMessage
                               atIndex:(NSUInteger) index
                         forChangeType:(R1InboxMessagesChangeType)changeType
                              newIndex:(NSUInteger) newIndex
{
    switch (changeType)
    {
        case R1InboxMessagesChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:index inSection:0] ]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case R1InboxMessagesChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:index inSection:0] ]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case R1InboxMessagesChangeUpdate:
            ((R1SampleInboxTableViewCell *)[self.tableView cellForRowAtIndexPath: [NSIndexPath indexPathForRow:index inSection:0] ]).inboxMessage = [self.inboxMessages.messages objectAtIndex:index];

            break;
            
        default:
            break;
    }
}

// This method called when the changes to list of Inbox messages are over
- (void) inboxMessagesDidChanged
{
    [self.tableView endUpdates];
}

// This method called when the number of unread Inbox messages gets changed
- (void) inboxMessageUnreadCountChanged
{
    [self updateTitle];
}

@end
