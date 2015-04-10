#import "REEventParameterTypeViewController.h"
#import "REEventParameter.h"

@implementation REEventParameterTypeViewController

- (id) initWithEventParameter:(REEventParameter *) eventParameter
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self)
    {
        self.navigationItem.title = @"Parameter Type";
        
        _eventParameter = eventParameter;
    }
    return self;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TypeCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [REEventParameter typeToString:(REEventParameterType)(indexPath.row+1)];
    cell.accessoryType = (self.eventParameter.type == indexPath.row+1) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger currentSelectedRow = self.eventParameter.type - 1;
    
    if (currentSelectedRow == indexPath.row)
    {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    
    self.eventParameter.type = (REEventParameterType)(indexPath.row+1);
    
    [self.tableView reloadRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:currentSelectedRow inSection:0], indexPath ] withRowAnimation:UITableViewRowAnimationNone];

    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
