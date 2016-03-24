#import "RETestCase.h"
#import "REEventParameter.h"
#import "R1Emitter.h"

@implementation RETestCase

- (id) initWithType:(RETestCaseType) type
{
    self = [super init];
    if (self)
    {
        _type = type;
    }
    return self;
}

+ (RETestCase *) testCaseWithType:(RETestCaseType) type
{
    return [[RETestCase alloc] initWithType:type];
}

- (NSString *) title
{
    switch (self.type)
    {
        case RETestCaseTypeEvent:
            return @"Emit Event";
            
        default:
            break;
    }
    
    NSString *predefinedEvent = [self predefinedEventName];
    if (predefinedEvent == nil)
        return nil;
    
    return [NSString stringWithFormat:@"Emit %@", predefinedEvent];
}

- (BOOL) hasParameters
{
    return YES;
}

- (NSString *) predefinedEventName
{
    switch (self.type)
    {
        case RETestCaseTypeLogin:
            return @"Login Event";
        case RETestCaseTypeUserInfo:
            return @"User Info";
        case RETestCaseTypeRegistration:
            return @"Registration Event";
        case RETestCaseTypeFBConnect:
            return @"FBConnect Event";
        case RETestCaseTypeTConnect:
            return @"TConnect Event";
        case RETestCaseTypeTransaction:
            return @"Transaction Event";
        case RETestCaseTypeTransactionItem:
            return @"TransactionItem Event";
        case RETestCaseTypeCartCreate:
            return @"Cart Create Event";
        case RETestCaseTypeCartDelete:
            return @"Cart Delete Event";
        case RETestCaseTypeAddToCart:
            return @"Add To Cart Event";
        case RETestCaseTypeDeleteFromCart:
            return @"Delete From Cart Event";
        case RETestCaseTypeUpgrade:
            return @"Upgrade Event";
        case RETestCaseTypeTrialUpgrade:
            return @"Trial Upgrade Event";
        case RETestCaseTypeScreenView:
            return @"Screen View Event";
            
        default:
            break;
    }
    
    return nil;
}

- (NSArray *) predefinedEventParameters
{
    NSMutableArray *parameters = [NSMutableArray array];
    
    switch (self.type)
    {
        case RETestCaseTypeLogin:
            [parameters addObject:[REEventParameter eventPredefinedParameterWithKey:@"userID" visibleKey:@"UserID" type:REEventParameterTypeString]];
            [parameters addObject:[REEventParameter eventPredefinedParameterWithKey:@"userName" visibleKey:@"UserName" type:REEventParameterTypeString]];
            break;
        case RETestCaseTypeUserInfo:
            [parameters addObject:[REEventParameter eventPredefinedParameterWithKey:@"userID" visibleKey:@"UserID" type:REEventParameterTypeString]];
            [parameters addObject:[REEventParameter eventPredefinedParameterWithKey:@"userName" visibleKey:@"UserName" type:REEventParameterTypeString]];
            [parameters addObject:[REEventParameter eventPredefinedParameterWithKey:@"email" visibleKey:@"Email" type:REEventParameterTypeString]];
            [parameters addObject:[REEventParameter eventPredefinedParameterWithKey:@"firstName" visibleKey:@"FirstName" type:REEventParameterTypeString]];
            [parameters addObject:[REEventParameter eventPredefinedParameterWithKey:@"lastName" visibleKey:@"LastName" type:REEventParameterTypeString]];
            [parameters addObject:[REEventParameter eventPredefinedParameterWithKey:@"streetAddress" visibleKey:@"Street Address" type:REEventParameterTypeString]];
            [parameters addObject:[REEventParameter eventPredefinedParameterWithKey:@"phone" visibleKey:@"Phone" type:REEventParameterTypeString]];
            [parameters addObject:[REEventParameter eventPredefinedParameterWithKey:@"city" visibleKey:@"City" type:REEventParameterTypeString]];
            [parameters addObject:[REEventParameter eventPredefinedParameterWithKey:@"state" visibleKey:@"State" type:REEventParameterTypeString]];
            [parameters addObject:[REEventParameter eventPredefinedParameterWithKey:@"zip" visibleKey:@"Zip" type:REEventParameterTypeString]];
            break;
        case RETestCaseTypeRegistration:
            [parameters addObject:[REEventParameter eventPredefinedParameterWithKey:@"userID" visibleKey:@"UserID" type:REEventParameterTypeString]];
            [parameters addObject:[REEventParameter eventPredefinedParameterWithKey:@"userName" visibleKey:@"UserName" type:REEventParameterTypeString]];
            [parameters addObject:[REEventParameter eventPredefinedParameterWithKey:@"country" visibleKey:@"Country" type:REEventParameterTypeString]];
            [parameters addObject:[REEventParameter eventPredefinedParameterWithKey:@"state" visibleKey:@"State" type:REEventParameterTypeString]];
            [parameters addObject:[REEventParameter eventPredefinedParameterWithKey:@"city" visibleKey:@"City" type:REEventParameterTypeString]];
            break;
        case RETestCaseTypeFBConnect:
            break;
        case RETestCaseTypeTConnect:
            [parameters addObject:[REEventParameter eventPredefinedParameterWithKey:@"userID" visibleKey:@"UserID" type:REEventParameterTypeString]];
            [parameters addObject:[REEventParameter eventPredefinedParameterWithKey:@"userName" visibleKey:@"UserName" type:REEventParameterTypeString]];
            break;
        case RETestCaseTypeTransaction:
            [parameters addObject:[REEventParameter eventPredefinedParameterWithKey:@"transactionID" visibleKey:@"TransactionID" type:REEventParameterTypeString]];
            [parameters addObject:[REEventParameter eventPredefinedParameterWithKey:@"storeID" visibleKey:@"StoreID" type:REEventParameterTypeString]];
            [parameters addObject:[REEventParameter eventPredefinedParameterWithKey:@"storeName" visibleKey:@"StoreName" type:REEventParameterTypeString]];
            [parameters addObject:[REEventParameter eventPredefinedParameterWithKey:@"cartID" visibleKey:@"CartID" type:REEventParameterTypeString]];
            [parameters addObject:[REEventParameter eventPredefinedParameterWithKey:@"orderID" visibleKey:@"OrderID" type:REEventParameterTypeString]];
            [parameters addObject:[REEventParameter eventPredefinedParameterWithKey:@"totalSale" visibleKey:@"TotalSale" type:REEventParameterTypeDouble]];
            [parameters addObject:[REEventParameter eventPredefinedParameterWithKey:@"currency" visibleKey:@"Currency" type:REEventParameterTypeString]];
            [parameters addObject:[REEventParameter eventPredefinedParameterWithKey:@"shippingCosts" visibleKey:@"ShippingCosts" type:REEventParameterTypeDouble]];
            [parameters addObject:[REEventParameter eventPredefinedParameterWithKey:@"transactionTax" visibleKey:@"TransactionTax" type:REEventParameterTypeDouble]];
            break;
        case RETestCaseTypeTransactionItem:
            [parameters addObject:[REEventParameter eventPredefinedParameterWithKey:@"transactionID" visibleKey:@"TransactionID" type:REEventParameterTypeString]];
            break;
        case RETestCaseTypeCartCreate:
            [parameters addObject:[REEventParameter eventPredefinedParameterWithKey:@"cartID" visibleKey:@"CartID" type:REEventParameterTypeString]];
            break;
        case RETestCaseTypeCartDelete:
            [parameters addObject:[REEventParameter eventPredefinedParameterWithKey:@"cartID" visibleKey:@"CartID" type:REEventParameterTypeString]];
            break;
        case RETestCaseTypeAddToCart:
            [parameters addObject:[REEventParameter eventPredefinedParameterWithKey:@"cartID" visibleKey:@"CartID" type:REEventParameterTypeString]];
            break;
        case RETestCaseTypeDeleteFromCart:
            [parameters addObject:[REEventParameter eventPredefinedParameterWithKey:@"cartID" visibleKey:@"CartID" type:REEventParameterTypeString]];
            break;
        case RETestCaseTypeScreenView:
            [parameters addObject:[REEventParameter eventPredefinedParameterWithKey:@"documentTitle" visibleKey:@"DocumentTitle" type:REEventParameterTypeString]];
            [parameters addObject:[REEventParameter eventPredefinedParameterWithKey:@"contentDescription" visibleKey:@"ContentDescription" type:REEventParameterTypeString]];
            [parameters addObject:[REEventParameter eventPredefinedParameterWithKey:@"documentLocationUrl" visibleKey:@"LocationUrl" type:REEventParameterTypeString]];
            [parameters addObject:[REEventParameter eventPredefinedParameterWithKey:@"documentHostName" visibleKey:@"HostName" type:REEventParameterTypeString]];
            [parameters addObject:[REEventParameter eventPredefinedParameterWithKey:@"documentPath" visibleKey:@"Path" type:REEventParameterTypeString]];
            break;
            
        default:
            return nil;
    }
    
    return parameters;
}

- (BOOL) hasLineItem
{
    switch (self.type)
    {
        case RETestCaseTypeTransactionItem:
        case RETestCaseTypeAddToCart:
        case RETestCaseTypeDeleteFromCart:
            return YES;
            
        default:
            break;
    }
    
    return NO;
}

- (BOOL) hasPermissions
{
    switch (self.type)
    {
        case RETestCaseTypeFBConnect:
        case RETestCaseTypeTConnect:
            return YES;
            
        default:
            break;
    }
    
    return NO;
}

- (void) emitWithEventName:(NSString *) eventName withParameters:(NSDictionary *) parameters
{
    R1Emitter *emitter = [R1Emitter sharedInstance];
    
    switch (self.type)
    {
        case RETestCaseTypeEvent:
            [emitter emitEvent:eventName
                withParameters:parameters];
            break;
        case RETestCaseTypeLogin:
            [emitter emitLoginWithUserID:[parameters objectForKey:@"userID"]
                                userName:[parameters objectForKey:@"userName"]
                               otherInfo:[parameters objectForKey:@"other_info"]];
            break;
        case RETestCaseTypeUserInfo:
        {
            R1EmitterUserInfo *userInfo = [R1EmitterUserInfo userInfoWithUserID:[parameters objectForKey:@"userID"]
                                                                       userName:[parameters objectForKey:@"userName"]
                                                                          email:[parameters objectForKey:@"email"]
                                                                      firstName:[parameters objectForKey:@"firstName"]
                                                                       lastName:[parameters objectForKey:@"lastName"]
                                                                  streetAddress:[parameters objectForKey:@"streetAddress"]
                                                                          phone:[parameters objectForKey:@"phone"]
                                                                           city:[parameters objectForKey:@"city"]
                                                                          state:[parameters objectForKey:@"state"]
                                                                            zip:[parameters objectForKey:@"zip"]];
            [emitter emitUserInfo:userInfo
                        otherInfo:[parameters objectForKey:@"other_info"]];
        }
            break;
        case RETestCaseTypeRegistration:
            [emitter emitRegistrationWithUserID:[parameters objectForKey:@"userID"]
                                       userName:[parameters objectForKey:@"userName"]
                                        country:[parameters objectForKey:@"country"]
                                          state:[parameters objectForKey:@"state"]
                                           city:[parameters objectForKey:@"city"]
                                      otherInfo:[parameters objectForKey:@"other_info"]];
            break;
        case RETestCaseTypeFBConnect:
            [emitter emitFBConnectWithPermissions:[parameters objectForKey:@"permissions"]
                                        otherInfo:[parameters objectForKey:@"other_info"]];

            break;
        case RETestCaseTypeTConnect:
            [emitter emitTConnectWithUserID:[parameters objectForKey:@"userID"]
                                   userName:[parameters objectForKey:@"userName"]
                                permissions:[parameters objectForKey:@"permissions"]
                                  otherInfo:[parameters objectForKey:@"other_info"]];

            break;
        case RETestCaseTypeTransaction:
            [emitter emitTransactionWithID:[parameters objectForKey:@"transactionID"]
                                   storeID:[parameters objectForKey:@"storeID"]
                                 storeName:[parameters objectForKey:@"storeName"]
                                    cartID:[parameters objectForKey:@"cartID"]
                                   orderID:[parameters objectForKey:@"orderID"]
                                 totalSale:[[parameters objectForKey:@"totalSale"] doubleValue]
                                  currency:[parameters objectForKey:@"currency"]
                             shippingCosts:[[parameters objectForKey:@"shippingCosts"] doubleValue]
                            transactionTax:[[parameters objectForKey:@"transactionTax"] doubleValue]
                                 otherInfo:[parameters objectForKey:@"other_info"]];
            break;
        case RETestCaseTypeTransactionItem:
            [emitter emitTransactionItemWithTransactionID:[parameters objectForKey:@"transactionID"]
                                                 lineItem:[parameters objectForKey:@"lineItem"]
                                                otherInfo:[parameters objectForKey:@"other_info"]];
            break;
        case RETestCaseTypeCartCreate:
            [emitter emitCartCreateWithCartID:[parameters objectForKey:@"cartID"]
                                    otherInfo:[parameters objectForKey:@"other_info"]];
            break;
        case RETestCaseTypeCartDelete:
            [emitter emitCartDeleteWithCartID:[parameters objectForKey:@"cartID"]
                                    otherInfo:[parameters objectForKey:@"other_info"]];
            break;
        case RETestCaseTypeAddToCart:
            [emitter emitAddToCartWithCartID:[parameters objectForKey:@"cartID"]
                                    lineItem:[parameters objectForKey:@"lineItem"]
                                   otherInfo:[parameters objectForKey:@"other_info"]];
            break;
        case RETestCaseTypeDeleteFromCart:
            [emitter emitDeleteFromCartWithCartID:[parameters objectForKey:@"cartID"]
                                         lineItem:[parameters objectForKey:@"lineItem"]
                                        otherInfo:[parameters objectForKey:@"other_info"]];
            break;
        case RETestCaseTypeUpgrade:
            [emitter emitUpgradeWithOtherInfo:parameters];
            break;
        case RETestCaseTypeTrialUpgrade:
            [emitter emitTrialUpgradeWithOtherInfo:parameters];
            break;
        case RETestCaseTypeScreenView:
            [emitter emitScreenViewWithDocumentTitle:[parameters objectForKey:@"documentTitle"]
                                  contentDescription:[parameters objectForKey:@"contentDescription"]
                                 documentLocationUrl:[parameters objectForKey:@"documentLocationUrl"]
                                    documentHostName:[parameters objectForKey:@"documentHostName"]
                                        documentPath:[parameters objectForKey:@"documentPath"]
                                           otherInfo:[parameters objectForKey:@"other_info"]];
            break;
            
        default:
            break;
    }
}

@end
