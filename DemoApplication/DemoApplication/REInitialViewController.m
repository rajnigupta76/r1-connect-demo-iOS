#import "REInitialViewController.h"
#import "RETextValueCell.h"
#import "R1SDK.h"
#import "R1Emitter.h"
#import "R1Push.h"

#import "RESharedParametersViewController.h"
#import "REEmitterParametersViewController.h"
#import "REEmitterViewController.h"

@implementation REInitialViewController

- (id) initViewController
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self)
    {
        self.navigationItem.title = @"Emitter & Push SDK";
    }
    return self;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
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
            return sdk.emitter.isStarted ? 2 : 0;
        case 2:
            return sdk.push.isStarted ? 1 : 0;
            
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
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"StartCell"] autorelease];
        cell.textLabel.textAlignment = UITextAlignmentLeft;
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
            else
                cell.textLabel.text = @"Emitter Methods";
            break;
        case 2:
            cell.textLabel.text = @"Push Options";
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
        {
            RESharedParametersViewController *viewController = [[RESharedParametersViewController alloc] initViewController];
            [self.navigationController pushViewController:viewController animated:YES];
            [viewController release];
        }
            break;
        case 1:
            if (indexPath.row == 0)
            {
                REEmitterParametersViewController *viewController = [[REEmitterParametersViewController alloc] initViewController];
                [self.navigationController pushViewController:viewController animated:YES];
                [viewController release];
            }else
            {
                REEmitterViewController *viewController = [[REEmitterViewController alloc] initViewController];
                [self.navigationController pushViewController:viewController animated:YES];
                [viewController release];
            }
            break;
        case 2:
            [R1SDK showPushOptionsInNavigationController:self.navigationController animated:YES];
            break;
            
        default:
            break;
    }

    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
