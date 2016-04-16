//
//  Person.m
//  runTimeTest
//
//  Created by mac on 16/4/16.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "Person.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation Person


- (NSDictionary *)allProperties{
    
    unsigned int count = 0;
    objc_objectptr_t *properties = class_copyPropertyList([self class], &count);
    NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
    for (int i = 0; i < count; ++i) {
        const char *propertyName = property_getName(properties[i]);
        NSString *name = [NSString stringWithUTF8String:propertyName];
        
        id propertyValue = [self valueForKey:name];
        if (propertyValue) {
            resultDic[name] = propertyValue;
        }else{
            
            resultDic[name] = @"空的";
        }
    }
    
    free(properties);
    
    return resultDic;
}

- (NSDictionary *)allIvars{
    
    unsigned int count = 0;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    Ivar *ivars = class_copyIvarList([self class], &count);
    for (int i = 0; i < count; ++i) {
        
        const char *varName = ivar_getName(ivars[i]);
        NSString *name = [NSString stringWithUTF8String:varName];
        id varValue = [self valueForKey:name];
        if (varValue) {
            dict[name] = varValue;
        }else{
            
            dict[name] = @"--";
        }
    }
    
    free(ivars);
    return dict;
}


- (NSDictionary *)allMethods{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    unsigned int count = 0;
    Method *methods = class_copyMethodList([self class], &count);
    for (int i = 0; i < count; ++i) {
        SEL method = method_getName(methods[i]);
        const char *methodName = sel_getName(method);
        NSString *name = [NSString stringWithUTF8String:methodName];
        
        int argumentCount = method_getNumberOfArguments(methods[i]);
        
        dict[name] = @(argumentCount-2);
        
    }
    free(methods);
    
    return dict;
}

@end