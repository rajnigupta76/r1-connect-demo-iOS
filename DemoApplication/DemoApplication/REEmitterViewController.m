#import "REEmitterViewController.h"
#import "RETestCase.h"
#import "REEventParametersViewController.h"
#import "REEventParameter.h"
#import "REEmitterParametersViewController.h"
#import "R1Emitter.h"

@interface REEmitterViewController ()

@property (nonatomic, assign) BOOL started;

@property (nonatomic, retain) NSArray *testCases;

@end

@implementation REEmitterViewController

- (id) initViewController
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self)
    {
        self.started = NO;
        self.navigationItem.title = @"Emitter Methods";
        
        [self initTestCases];
    }
    return self;
}

- (void) dealloc
{
    self.testCases = nil;
    
    [super dealloc];
}

- (void) initTestCases
{
    self.testCases = @[[RETestCase testCaseWithType:RETestCaseTypeEvent],
                       [RETestCase testCaseWithType:RETestCaseTypeLogin],
                       [RETestCase testCaseWithType:RETestCaseTypeUserInfo],
                       [RETestCase testCaseWithType:RETestCaseTypeRegistration],
                       [RETestCase testCaseWithType:RETestCaseTypeFBConnect],
                       [RETestCase testCaseWithType:RETestCaseTypeTConnect],
                       [RETestCase testCaseWithType:RETestCaseTypeTransaction],
                       [RETestCase testCaseWithType:RETestCaseTypeTransactionItem],
                       [RETestCase testCaseWithType:RETestCaseTypeCartCreate],
                       [RETestCase testCaseWithType:RETestCaseTypeCartDelete],
                       [RETestCase testCaseWithType:RETestCaseTypeAddToCart],
                       [RETestCase testCaseWithType:RETestCaseTypeDeleteFromCart],
                       [RETestCase testCaseWithType:RETestCaseTypeUpgrade],
                       [RETestCase testCaseWithType:RETestCaseTypeTrialUpgrade],
                       [RETestCase testCaseWithType:RETestCaseTypeScreenView]];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.testCases count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"] autorelease];
    }
    
    cell.textLabel.text = ((RETestCase *)[self.testCases objectAtIndex:indexPath.row]).title;
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    RETestCase *testCase = [self.testCases objectAtIndex:indexPath.row];
    
    REEventParametersViewController *parametersViewController = [[REEventParametersViewController alloc] initViewControllerWithTestCase:testCase];
    parametersViewController.delegate = (id)self;
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:parametersViewController];
    
    [self presentViewController:navController animated:YES completion:nil];
    
    [navController release];
    [parametersViewController release];
}

- (void) eventParametersViewControllerDidCancelled:(REEventParametersViewController *) eventParametersViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) eventParametersViewController:(REEventParametersViewController *) eventParametersViewController didFinishedWithEventName:(NSString *) eventName withParameters:(NSDictionary *) parameters
{
    [eventParametersViewController.testCase emitWithEventName:eventName withParameters:parameters];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
