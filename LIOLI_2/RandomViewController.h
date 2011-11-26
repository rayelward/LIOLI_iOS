//
//  SecondViewController.h
//  LIOLI_2
//
//  Created by Raymond Elward on 10/16/11.
//  Copyright (c) 2011 Raymond Elward. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "REURLConnection.h"

@interface RandomViewController : UIViewController <ADBannerViewDelegate>{
    bool bannerIsVisible;
}

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

@property (nonatomic, retain) IBOutlet ADBannerView *banner;
@property (nonatomic, retain) IBOutlet UIView *contentView;

// Layout the Ad Banner and Content View to match the current orientation.
// The ADBannerView always animates its changes, so generally you should
// pass YES for animated, but it makes sense to pass NO in certain circumstances
// such as inside of -viewDidLoad.
-(void)layoutForCurrentOrientation:(BOOL)animated;

// A simple method that creates an ADBannerView
// Useful if you need to create the banner view in code
// such as when designing a universal binary for iPad
-(void)createADBannerView;

@end
