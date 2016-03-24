#import <Foundation/Foundation.h>

typedef enum
{
    REEventParameterTypeUnknown = 0,
    REEventParameterTypeString,
    REEventParameterTypeLong,
    REEventParameterTypeDouble,
    REEventParameterTypeBool
} REEventParameterType;

@interface REEventParameter : NSObject

@property (nonatomic, retain) NSString *key;
@property (nonatomic, assign) REEventParameterType type;
@property (nonatomic, retain) NSObject *value;

@property (nonatomic, readonly) BOOL isValueValid;

@property (nonatomic, readonly) BOOL isPredefined;
@property (nonatomic, readonly) NSString *visibleKey;

- (id) init;
- (id) initPredefinedWithKey:(NSString *) key visibleKey:(NSString *) visibleKey;

+ (REEventParameter *) eventPredefinedParameterWithKey:(NSString *) key visibleKey:(NSString *) visibleKey type:(REEventParameterType) type;

- (NSString *) stringFromValue;
- (BOOL) valueFromString:(NSString *) str;

+ (NSString *) typeToString:(REEventParameterType) type;

+ (BOOL) isValueValue:(NSString *) strValue type:(REEventParameterType) type;

- (void) generateRandomValue;

+ (NSString *) randomString;

@end
