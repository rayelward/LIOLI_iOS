//
//  lioliHelper.m
//  LIOLI_2
//
//  Created by Raymond Elward on 11/18/11.
//  Copyright (c) 2011 Raymond Elward. All rights reserved.
//

#import "lioliHelper.h"

@implementation lioliHelper

+(NSArray *)getRecentTen: (NSNumber *) page
{
    NSString *callingUrl = [NSString stringWithFormat:@"recents/%s", page];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:URL_TEMPLATE, callingUrl]];
    return nil;
}
+(NSArray *)getRandomTen
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:URL_TEMPLATE, @"random_ten"]];
    return nil;
}
+(NSNumber *)sendPost:(NSDictionary *) story
{
    NSString *callingUrl = [NSString stringWithFormat:@"submit/"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:URL_TEMPLATE, callingUrl]];
    return nil;
}
+(bool)addLoves:(NSNumber *)uniqueId
{
    NSString *callingUrl = [NSString stringWithFormat:@"add_leaves/%s", uniqueId];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:URL_TEMPLATE, callingUrl]];
    return NO;
}
+(bool)addLeaves:(NSNumber *)uniqueId
{
    NSString *callingUrl = [NSString stringWithFormat:@"add_loves/%s", uniqueId];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:URL_TEMPLATE, callingUrl]];
    
    return NO;
}
+(NSDictionary *)getEntry:(NSNumber *)uniqueId
{
    NSString *callingUrl = [NSString stringWithFormat:@"get_entry/%s", uniqueId];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:URL_TEMPLATE, callingUrl]];
    
    return nil;
}



@end
