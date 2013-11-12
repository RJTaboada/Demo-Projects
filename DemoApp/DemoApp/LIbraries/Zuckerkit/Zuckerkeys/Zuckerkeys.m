#import "Zuckerkeys.h"

static NSString *rootKey = @"Zuckerkit";

NSDictionary *rootDictionary()
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:rootKey];
}

NSString *ModeKey()
{
    BOOL isProduction = [[rootDictionary() objectForKey:@"Production"] boolValue];
    return isProduction ? @"Production Keys" : @"Development Keys";
}

BOOL isProduction()
{
    return [ModeKey() isEqualToString:@"Production"];
}

NSString *FacebookAppId()
{
    return rootDictionary()[ModeKey()][@"id"];
}

NSString *FacebookDisplayName()
{
    return rootDictionary()[ModeKey()][@"name"];
}
