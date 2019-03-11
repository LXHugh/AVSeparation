//
//  ringModel.m
//  ringApp
//
//  Created by Tommy on 2018/10/22.
//  Copyright © 2018 Tommy. All rights reserved.
//

#import "ringModel.h"

@implementation ringModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}


-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.ringName forKey:@"ringName"];
    [aCoder encodeObject:self.ringSize forKey:@"ringSize"];
    [aCoder encodeObject:self.ringTime forKey:@"ringTime"];
    [aCoder encodeObject:self.ringPath forKey:@"ringPath"];
}


-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.ringName = [aDecoder decodeObjectForKey:@"ringName"];
        self.ringSize = [aDecoder decodeObjectForKey:@"ringSize"];
        self.ringTime = [aDecoder decodeObjectForKey:@"ringTime"];
        self.ringPath = [aDecoder decodeObjectForKey:@"ringPath"];
    }
    
    return self;
}


@end
