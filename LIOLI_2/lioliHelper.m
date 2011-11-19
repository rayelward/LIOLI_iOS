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
    NSString *callingUrl = [NSString stringWithFormat:@"recents/%@", page];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:URL_TEMPLATE, callingUrl]];
    NSArray *result = 
        (NSArray *)[NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:url] 
                                                        options:NSJSONReadingMutableContainers 
                                                          error:nil];
    NSLog(@"body:%@", [[result objectAtIndex:2] objectForKey:@"body"]);
    NSLog(@"id:%@", [[result objectAtIndex:2] objectForKey:@"unique_id"]);
    NSLog(@"love:%@", [[result objectAtIndex:2] objectForKey:@"loves"]);
    NSLog(@"leave:%@", [[result objectAtIndex:2] objectForKey:@"leaves"]);
    NSLog(@"gender:%@", [[result objectAtIndex:2] objectForKey:@"gender"]);
    NSLog(@"age:%@", [[result objectAtIndex:2] objectForKey:@"age"]);
    return result;
}
+(NSArray *)getRandomTen
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:URL_TEMPLATE, @"random_ten"]];
    NSArray *result = 
    (NSArray *)[NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:url] 
                                               options:NSJSONReadingMutableContainers 
                                                 error:nil];
    NSLog(@"getRandomTen: %@", result);
    return result;
}
+(NSNumber *)sendPost:(NSDictionary *) story
{
    NSString *callingUrl = [NSString stringWithFormat:@"submit/"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:URL_TEMPLATE, callingUrl]];
    NSDictionary *result = 
    (NSDictionary *)[NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:url] 
                                               options:NSJSONReadingMutableContainers 
                                                 error:nil];
    NSLog(@"%@", result);
    return nil;
}
+(bool)addLoves:(NSNumber *)uniqueId
{
    NSString *callingUrl = [NSString stringWithFormat:@"add_leaves/%@", uniqueId];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:URL_TEMPLATE, callingUrl]];
    NSString *result = [[NSString alloc] initWithContentsOfURL:url 
                                                      encoding:NSUTF8StringEncoding 
                                                         error:NULL];
    NSLog(@"%@", result);
    return NO;
}
+(bool)addLeaves:(NSNumber *)uniqueId
{
    NSString *callingUrl = [NSString stringWithFormat:@"add_loves/%@", uniqueId];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:URL_TEMPLATE, callingUrl]];
    NSString *result = [[NSString alloc] initWithContentsOfURL:url 
                                                      encoding:NSUTF8StringEncoding 
                                                         error:NULL];
    NSLog(@"%@", result);
    
    return NO;
}
+(NSDictionary *)getEntry:(NSNumber *)uniqueId
{
    NSString *callingUrl = [NSString stringWithFormat:@"get_entry/%@", uniqueId];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:URL_TEMPLATE, callingUrl]];
    NSDictionary *result = 
    (NSDictionary *)[NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:url] 
                                                    options:NSJSONReadingMutableContainers 
                                                      error:nil];
    NSLog(@"body:%@", [result objectForKey:@"body"]);
    NSLog(@"id:%@", [result objectForKey:@"unique_id"]);
    NSLog(@"love:%@", [result objectForKey:@"loves"]);
    NSLog(@"leave:%@", [result objectForKey:@"leaves"]);
    NSLog(@"gender:%@", [result objectForKey:@"gender"]);
    NSLog(@"age:%@", [result objectForKey:@"age"]);
    
    return nil;
}



@end
