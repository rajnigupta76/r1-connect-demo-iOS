#import "REInitialViewController.h"
#import "RETextValueCell.h"
#import "R1SDK.h"
#import "R1Emitter.h"
#import "R1Push.h"
#import "R1Inbox.h"

#import "RESharedParametersViewController.h"
#import "REEmitterParametersViewController.h"
#import "REPushParametersViewController.h"
#import "REGeofencingViewController.h"
#import "REEmitterViewController.h"
#import "R1SampleInboxViewController.h"
#import "REWebViewController.h"

@interface REInitialViewController ()

@property (nonatomic, strong) R1InboxMessages *inboxMessages;

@end

@implementation REInitialViewController

- (id) initViewController
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self)
    {
        self.navigationItem.title = @"R1Connect SDK";
        
        self.inboxMessages = [R1Inbox sharedInstance].messages;
        
        [self.inboxMessages addDelegate:(id)self];
    }
    return self;
}

- (void) dealloc
{
    [self.inboxMessages removeDelegate:(id)self];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    R1SDK *sdk = [R1SDK sharedInstance];
    
    if (!sdk.emitter.isStarted && !sdk.push.isStarted)
        return 1;
    
    switch (section)
    {
        case 0:
            return 1;
        case 1:
            return sdk.emitter.isStarted ? 3 : 0;
        case 2:
            return sdk.push.isStarted ? 1 : 0;
        case 3:
        case 4:
            return 1;

        default:
            break;
    }

    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    switch (indexPath.section)
    {
        case 0:
            cell.textLabel.text = @"Shared Options";
            break;
        case 1:
            if (indexPath.row == 0)
                cell.textLabel.text = @"Emitter Options";
            else if (indexPath.row == 1)
                cell.textLabel.text = @"Emitter Methods";
            else if (indexPath.row == 2)
                cell.textLabel.text = @"Emitter Web View";
            break;
        case 2:
            cell.textLabel.text = @"Push Options";
            break;
        case 3:
            cell.textLabel.text = [NSString stringWithFormat:@"Inbox (%lu unread)", (unsigned long)self.inboxMessages.unreadMessagesCount];
            break;
        case 4:
            cell.textLabel.text = @"Geofencing Options";
            break;

        default:
            break;
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *viewController = nil;
    switch (indexPath.section)
    {
        case 0:
            viewController = [[RESharedParametersViewController alloc] initViewController];
            break;
        case 1:
            if (indexPath.row == 0)
            {
                viewController = [[REEmitterParametersViewController alloc] initViewController];
            }else if (indexPath.row == 1)
            {
                viewController = [[REEmitterViewController alloc] initViewController];
            }else if (indexPath.row == 2)
            {
                viewController = [[REWebViewController alloc] initViewController];
            }
            break;
        case 2:
            viewController = [[REPushParametersViewController alloc] initViewController];
            break;
        case 3:
        {
            R1SampleInboxViewController *inboxVC = [[R1SampleInboxViewController alloc] initInboxViewController];
            inboxVC.inboxDelegate = (id)self;
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:inboxVC];
            
            [self presentViewController:navController
                               animated:YES
                             completion:nil];
        }
            break;
        case 4:
            viewController = [[REGeofencingViewController alloc] initViewController];
            break;
            
        default:
            break;
    }
    
    if (viewController != nil)
    {
        [self.navigationController pushViewController:viewController animated:YES];
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void) inboxMessageUnreadCountChanged
{
    if (![self isViewLoaded])
        return;
    
    [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]].textLabel.text = [NSString stringWithFormat:@"Inbox (%lu unread)", (unsigned long)self.inboxMessages.unreadMessagesCount];
}

- (void) sampleInboxViewControllerDidFinished:(R1SampleInboxViewController *) sampleInboxViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
