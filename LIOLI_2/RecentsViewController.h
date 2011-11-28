//
//  RecentsViewController.h
//  LIOLI_2
//
//  Created by Raymond Elward on 11/19/11.
//  Copyright (c) 2011 Raymond Elward. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REURLConnection.h"

@interface RecentsViewController : UITableViewController

@property (nonatomic, retain) NSMutableData *receivedData;
@property (nonatomic, retain) NSMutableArray *dataArray;

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

-(void)loadTenEntriesFromPage:(NSNumber *)pageNumber;



@end
