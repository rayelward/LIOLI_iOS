//
//  lioliHelper.m
//  LIOLI_2
//
//  Created by Raymond Elward on 11/18/11.
//  Copyright (c) 2011 Raymond Elward. All rights reserved.
//

#import "lioliHelper.h"

@implementation lioliHelper



/*
 * Works but does a sync call for the most recent postings.
 */
+(NSArray *)getRecentTen: (NSNumber *) page
{
    NSString *callingUrl = [NSString stringWithFormat:@"recents/%@", page];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:URL_TEMPLATE, callingUrl]];
    NSArray *result = 
        (NSArray *)[NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:url] 
                                                   options:NSJSONReadingMutableContainers 
                                                     error:nil];
    return result;
}

/*
 * Brings in 10 random entries for the user to vote on.
 */
+(NSArray *)getRandomTen
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:URL_TEMPLATE, @"random_ten"]];
    NSArray *result = 
    (NSArray *)[NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:url] 
                                               options:NSJSONReadingMutableContainers 
                                                 error:nil];
    return result;
}
/*
 * TODO: send data to the server and get the unique id back.
 */
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
/*
 * Adds to the number of loves for a specific id.  Returns the new loves or wrong id
 */
+(bool)addLoves:(NSNumber *)uniqueId
{
    NSString *callingUrl = [NSString stringWithFormat:@"add_loves/%@", uniqueId];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:URL_TEMPLATE, callingUrl]];
    NSString *result = [[NSString alloc] initWithContentsOfURL:url 
                                                      encoding:NSUTF8StringEncoding 
                                                         error:NULL];
    NSLog(@"%@", result);
    return NO;
}
/*
 * Adds to the number of leaves for a specific id.  Returns the new loves or wrong id
 */
+(bool)addLeaves:(NSNumber *)uniqueId
{
    NSString *callingUrl = [NSString stringWithFormat:@"add_leaves/%@", uniqueId];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:URL_TEMPLATE, callingUrl]];
    NSString *result = [[NSString alloc] initWithContentsOfURL:url 
                                                      encoding:NSUTF8StringEncoding 
                                                         error:NULL];
    NSLog(@"%@", result);
    
    return NO;
}
/*
 * Gets a specific entry and returns it as a dictionary or wrong id
 */
+(NSDictionary *)getEntry:(NSNumber *)uniqueId
{
    NSString *callingUrl = [NSString stringWithFormat:@"get_entry/%@", uniqueId];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:URL_TEMPLATE, callingUrl]];
    NSDictionary *result = 
    (NSDictionary *)[NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:url] 
                                                    options:NSJSONReadingMutableContainers 
                                                      error:nil];
    
    if ([result objectForKey:@"wrongid"] != NULL){
        NSLog(@"wrongid:%@", [result objectForKey:@"wrongid"]);
    }
    else {
        NSLog(@"body:%@", [result objectForKey:@"body"]);
        NSLog(@"id:%@", [result objectForKey:@"unique_id"]);
        NSLog(@"love:%@", [result objectForKey:@"loves"]);
        NSLog(@"leave:%@", [result objectForKey:@"leaves"]);
        NSLog(@"gender:%@", [result objectForKey:@"gender"]);
        NSLog(@"age:%@", [result objectForKey:@"age"]);
    }
    
    return nil;
}



@end
