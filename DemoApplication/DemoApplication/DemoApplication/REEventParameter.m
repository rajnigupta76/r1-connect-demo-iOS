#import "REEventParameter.h"

@implementation REEventParameter

- (id) init
{
    self = [super init];
    if (self)
    {
    }
    return self;
}

- (id) initPredefinedWithKey:(NSString *) key visibleKey:(NSString *) visibleKey
{
    self = [super init];
    if (self)
    {
        self.key = key;
        _visibleKey = [visibleKey copy];
        _isPredefined = YES;
    }
    return self;
}

+ (REEventParameter *) eventPredefinedParameterWithKey:(NSString *) key visibleKey:(NSString *) visibleKey type:(REEventParameterType) type
{
    REEventParameter *eventParameter = [[REEventParameter alloc] initPredefinedWithKey:key visibleKey:visibleKey];
    eventParameter.type = type;
    
    [eventParameter generateRandomValue];
    
    return eventParameter;
}

- (void) dealloc
{
    self.key = nil;
    self.value = nil;
    _visibleKey = nil;
}

- (NSString *) stringFromValue
{
    switch (self.type)
    {
        case REEventParameterTypeString:
            return (NSString *)self.value;
        case REEventParameterTypeLong:
            return [NSString stringWithFormat:@"%ld", [(NSNumber *)self.value longValue]];
        case REEventParameterTypeDouble:
            return [NSString stringWithFormat:@"%f", [(NSNumber *)self.value doubleValue]];
        case REEventParameterTypeBool:
            return [(NSNumber *)self.value boolValue] ? @"YES" : @"NO";
            
        default:
            break;
    }
    
    return nil;
}

- (BOOL) valueFromString:(NSString *) str
{
    NSScanner *scanner = [NSScanner scannerWithString:str];

    switch (self.type)
    {
        case REEventParameterTypeUnknown:
            return NO;
        case REEventParameterTypeString:
            self.value = str;
            break;
        case REEventParameterTypeLong:
            {
                long long longVal;
                if (![scanner scanLongLong:&longVal])
                    return NO;
                self.value = [NSNumber numberWithLong:(long)longVal];
            }
            break;
        case REEventParameterTypeDouble:
            {
                double doubleVal;
                if (![scanner scanDouble:&doubleVal])
                    return NO;
                self.value = [NSNumber numberWithDouble:doubleVal];
            }
            break;
            
        default:
            break;
    }
    
    return YES;
}

+ (NSString *) typeToString:(REEventParameterType) type
{
    switch (type)
    {
        case REEventParameterTypeString:
            return @"String";
        case REEventParameterTypeLong:
            return @"Long";
        case REEventParameterTypeDouble:
            return @"Double";
        case REEventParameterTypeBool:
            return @"Bool";
            
        default:
            break;
    }
    
    return @"Unknown";
}

- (BOOL) isValueValid
{
    if (self.value == nil)
        return NO;
    
    if (self.type == REEventParameterTypeString)
    {
        if ([(NSString *)self.value length] == 0)
            return NO;
    }
    
    return YES;
}

+ (BOOL) isValueValue:(NSString *) strValue type:(REEventParameterType) type
{
    NSScanner *scanner = [NSScanner scannerWithString:strValue];
    
    switch (type)
    {
        case REEventParameterTypeString:
            return ([strValue length] > 0);
        case REEventParameterTypeLong:
            {
                long long longVal;
                if ([scanner scanLongLong:&longVal])
                    return YES;
            }
            break;
        case REEventParameterTypeDouble:
            {
                double doubleVal;
                if ([scanner scanDouble:&doubleVal])
                    return YES;
            }
            break;
            
        default:
            break;
    }
    
    return NO;
}

- (NSInteger) randomSign
{
    return (arc4random() % 2 > 0) ? -1 : 1;
}

+ (NSString *) randomString
{
    NSString *alphabet  = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXZY0123456789";
    NSMutableString *s = [NSMutableString stringWithCapacity:10];
    for (int64_t i = 3; i < 5+(arc4random() % 6); i++) {
        u_int32_t r = arc4random() % [alphabet length];
        unichar c = [alphabet characterAtIndex:r];
        [s appendFormat:@"%C", c];
    }
    return s;
}

- (void) generateRandomValue
{
    switch (self.type)
    {
        case REEventParameterTypeString:
            self.value = [REEventParameter randomString];
            break;
        case REEventParameterTypeLong:
            self.value = [NSNumber numberWithLong:[self randomSign]*arc4random()];
            break;
        case REEventParameterTypeDouble:
            self.value = [NSNumber numberWithDouble:[self randomSign]*(arc4random()+1.0/arc4random())];
            break;
        case REEventParameterTypeBool:
            self.value = [NSNumber numberWithBool:(arc4random() % 2)];
            
        default:
            break;
    }

}

@end
