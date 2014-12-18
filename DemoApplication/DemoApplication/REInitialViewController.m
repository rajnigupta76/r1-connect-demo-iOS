#import "REInitialViewController.h"
#import "RETestCase.h"
#import "R1Emitter.h"
#import "REEventParametersViewController.h"
#import "REEventParameter.h"
#import "RESDKParametersViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface REInitialViewController ()

@property (nonatomic, assign) BOOL started;
@property (nonatomic, retain) CLLocationManager *locationManager;

@property (nonatomic, retain) NSArray *testCases;

@end

@implementation REInitialViewController

- (id) initViewController
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self)
    {
        self.started = NO;
        self.navigationItem.title = @"R1 Emmiter Demo";
        
        self.locationManager = [[[CLLocationManager alloc] init] autorelease];
        self.locationManager.delegate = (id)self;
        if (self.locationManager.location != nil)
            [self updateLocation:self.locationManager.location];
        [self.locationManager startUpdatingLocation];
        
        [self initTestCases];
    }
    return self;
}

- (void) dealloc
{
    [self.locationManager stopUpdatingLocation];
    self.locationManager = nil;
    
    self.testCases = nil;
    
    [super dealloc];
}

- (void) initTestCases
{
    self.testCases = @[[RETestCase testCaseWithType:RETestCaseTypeEvent],
                       [RETestCase testCaseWithType:RETestCaseTypeAction],
                       [RETestCase testCaseWithType:RETestCaseTypeLogin],
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

- (void) updateLocation:(CLLocation *) location
{
    [R1Emitter sharedInstance].location = location.coordinate;
}

- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if (newLocation != nil)
        [self updateLocation:newLocation];
}

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSInteger locationsCount = [locations count];
    if (locationsCount > 0)
        [self updateLocation:[locations objectAtIndex:locationsCount-1]];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Emit Methods";
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
    
    [self presentModalViewController:navController animated:YES];
    
    [navController release];
    
    [parametersViewController release];
}

- (void) eventParametersViewControllerDidCancelled:(REEventParametersViewController *) eventParametersViewController
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void) eventParametersViewController:(REEventParametersViewController *) eventParametersViewController didFinishedWithEventName:(NSString *) eventName withParameters:(NSDictionary *) parameters
{
    [eventParametersViewController.testCase emitWithEventName:eventName withParameters:parameters];

    [self dismissModalViewControllerAnimated:YES];
}

@end
