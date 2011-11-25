//
//  SecondViewController.h
//  LIOLI_2
//
//  Created by Raymond Elward on 10/16/11.
//  Copyright (c) 2011 Raymond Elward. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REURLConnection.h"

@interface RandomViewController : UIViewController

@property (nonatomic, retain) NSMutableData *receivedData;
@property (nonatomic, retain) NSMutableArray *randomEntries;
@property (nonatomic, retain) NSDictionary *currentEntry;

@property (weak, nonatomic) IBOutlet UILabel *idTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderTextLabel;
@property (weak, nonatomic) IBOutlet UITextView *bodyTextField;
@property (weak, nonatomic) IBOutlet UILabel *loveTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *leaveTextLabel;

@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *loveButton;
@property (weak, nonatomic) IBOutlet UIButton *leaveButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (IBAction)nextTouchDown:(id)sender;
- (IBAction)leaveTouchDown:(id)sender;
- (IBAction)loveTouchDown:(id)sender;

-(void) showEntry;
-(void) fillArray;
-(void) receiveDidBegin;
-(void) receiveDidEnd;
@end
