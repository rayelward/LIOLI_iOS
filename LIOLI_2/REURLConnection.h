//
//  REURLConnection.h
//  LIOLI_2
//
//  Created by Raymond Elward on 11/23/11.
//  Copyright (c) 2011 Raymond Elward. All rights reserved.
//
// This was built so I could decifer between two or more NSURLConnection s
// going on at once in the same view controller.
//
// It's just a subclass of NSURLConnection with my initials and a tag property for
// distingushing between the connections in the delegate methods!

#import <Foundation/Foundation.h>

@interface REURLConnection : NSURLConnection

@property (nonatomic, retain) NSString *tag;
@end
