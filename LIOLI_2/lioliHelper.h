//
//  lioliHelper.h
//  LIOLI_2
//
//  Created by Raymond Elward on 11/18/11.
//  Copyright (c) 2011 Raymond Elward. All rights reserved.
//
#define URL_TEMPLATE (@"http://lioli.net/init/services/call/json/%s")
#import <Foundation/Foundation.h>


/*
 * This class uses the services from lioli.net to populate the data in the app.
 * it pulls data through JSON and uses remote procedure calls to increment votes
 */
@interface lioliHelper : NSObject



+(NSArray *)getRecentTen;
+(NSArray *)getRandomTen;
+(NSNumber *)sendPost:(NSDictionary *)story;
+(bool)addLoves:(NSNumber *)uniqueId;
+(bool)addLeaves:(NSNumber *)uniqueId;
+(NSDictionary *)getEntry:(NSNumber *)uniqueId;


@end
