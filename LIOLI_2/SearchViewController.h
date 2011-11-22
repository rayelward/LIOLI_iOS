//
//  SearchViewController.h
//  LIOLI_2
//
//  Created by Raymond Elward on 11/18/11.
//  Copyright (c) 2011 Raymond Elward. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController


@property (weak, nonatomic) IBOutlet UITextField *idInputField;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UITextView *bodyTextArea;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) NSMutableData *receivedData;
@property (weak, nonatomic) IBOutlet UILabel *loveLabel;
@property (weak, nonatomic) IBOutlet UILabel *leaveLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;


- (IBAction)submitTouchDown:(id)sender;
- (IBAction)backgroundTouchDown:(id)sender;

@end
