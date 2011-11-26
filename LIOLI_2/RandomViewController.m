//
//  SecondViewController.m
//  LIOLI_2
//
//  Created by Raymond Elward on 10/16/11.
//  Copyright (c) 2011 Raymond Elward. All rights reserved.
//

#import "RandomViewController.h"

#define ARRAY_URL (@"http://lioli.net/init/services/call/json/random_ten")
#define LOVE_URL (@"http://lioli.net/init/services/call/json/add_loves/%@")
#define LEAVE_URL (@"http://lioli.net/init/services/call/json/add_leaves/%@")

@implementation RandomViewController

@synthesize randomEntries;
@synthesize currentEntry;
@synthesize receivedData;

@synthesize idTextLabel;
@synthesize ageTextLabel;
@synthesize genderTextLabel;
@synthesize bodyTextField;
@synthesize loveTextLabel;
@synthesize leaveTextLabel;
@synthesize nextButton;
@synthesize loveButton;
@synthesize leaveButton;
@synthesize activityIndicator;

@synthesize banner;
@synthesize contentView;



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    static NSString * const kADBannerViewClass = @"ADBannerView";
	if (NSClassFromString(kADBannerViewClass) != nil) {
        if (banner == nil) {
            [self createADBannerView];
        }
        [self layoutForCurrentOrientation:NO];
    }
}

- (void)viewDidUnload
{
    
    [self setBanner:nil];
    [self setNextButton:nil];
    [self setIdTextLabel:nil];
    [self setAgeTextLabel:nil];
    [self setGenderTextLabel:nil];
    [self setBodyTextField:nil];
    [self setLoveButton:nil];
    [self setLeaveButton:nil];
    [self setLoveTextLabel:nil];
    [self setLeaveTextLabel:nil];
    [self setActivityIndicator:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([randomEntries count] == 0) {
        randomEntries = [[NSMutableArray alloc] init];
        [activityIndicator startAnimating];
        
        [nextButton setHidden:YES];
        [idTextLabel setHidden:YES];
        [ageTextLabel setHidden:YES];
        [genderTextLabel setHidden:YES];
        [bodyTextField setHidden:YES];
        [loveButton setHidden:YES];
        [leaveButton setHidden:YES];
        
        [leaveTextLabel setHidden:YES];
        [loveTextLabel setHidden:YES];
        [self fillArray];
    }
    else {
        [self showEntry];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - view cycles

-(void) fillArray 
{
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:ARRAY_URL]
                                             cachePolicy: NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval: 30.0];
    
    REURLConnection *connection = [[REURLConnection alloc] initWithRequest:request delegate:self];
    [connection setTag:[NSString stringWithString:@"array"]];
    
    if (connection) 
    {
        receivedData = [NSMutableData data];
    }
    else 
    {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"There was a network connection error.  Could not receive data." 
                                                           delegate:self 
                                                  cancelButtonTitle:@"OK" 
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    
}

-(void) showEntry
{
    currentEntry = [[randomEntries objectAtIndex:0] copy];
    [randomEntries removeObjectAtIndex:0];
    
    [leaveTextLabel setHidden:YES];
    [loveTextLabel setHidden:YES];
    
    [nextButton setHidden:NO];
    
    
    [idTextLabel setText: [NSString stringWithFormat:@"ID: %@", [currentEntry objectForKey:@"unique_id"]]];
    [idTextLabel setHidden:NO];
    
    [ageTextLabel setText: [NSString stringWithFormat:@"Age: %@", [currentEntry objectForKey:@"age"]]];
    [ageTextLabel setHidden:NO];
    
    [genderTextLabel setText: [NSString stringWithFormat:@"Gender: %@", [currentEntry objectForKey:@"gender"]]];
    [genderTextLabel setHidden:NO];
    
    [bodyTextField setText: [NSString stringWithFormat:@"%@", [currentEntry objectForKey:@"body"]]];
    [bodyTextField setHidden:NO];
    
    [loveTextLabel setText: [NSString stringWithFormat:@"Loves: %@", [currentEntry objectForKey:@"loves"]]];
    [leaveTextLabel setText: [NSString stringWithFormat:@"Leaves: %@", [currentEntry objectForKey:@"leaves"] ]];
    [loveButton setHidden:NO];
    [leaveButton setHidden:NO];
    
    [activityIndicator stopAnimating];
}



#pragma mark - touch events

- (IBAction)nextTouchDown:(id)sender 
{
    [activityIndicator startAnimating];
    //hide next
    [nextButton setHidden:YES];
    
    [leaveButton setHidden:NO];
    [loveButton setHidden:NO];
    [loveTextLabel setHidden:YES];
    [leaveTextLabel setHidden:YES];
    //if array is empty collect 10 more
    if ([randomEntries count] == 0) {
        randomEntries = [[NSMutableArray alloc] init];
        [activityIndicator startAnimating];
        
        [nextButton setHidden:YES];
        [idTextLabel setHidden:YES];
        [ageTextLabel setHidden:YES];
        [genderTextLabel setHidden:YES];
        [bodyTextField setHidden:YES];
        [loveButton setHidden:YES];
        [leaveButton setHidden:YES];
        
        [leaveTextLabel setHidden:YES];
        [loveTextLabel setHidden:YES];
        [self fillArray];
    }
    else {
        [self showEntry];
    }
}

- (IBAction)leaveTouchDown:(id)sender 
{
    [activityIndicator startAnimating];
    //hide buttons
    [leaveButton setHidden:YES];
    [loveButton setHidden:YES];
    //show data
    [leaveTextLabel setHidden:NO];
    [loveTextLabel setHidden:NO];
    //cast vote
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:LEAVE_URL, [currentEntry objectForKey:@"unique_id"]]]
                                             cachePolicy: NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval: 30.0];
    
    REURLConnection *connection = [[REURLConnection alloc] initWithRequest:request delegate:self];
    [connection setTag:[NSString stringWithString:@"leave"]];
    
    if (connection) 
    {
        receivedData = [NSMutableData data];
    }
    else 
    {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"There was a network connection error.  Could not receive data." 
                                                           delegate:self 
                                                  cancelButtonTitle:@"OK" 
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
}

- (IBAction)loveTouchDown:(id)sender 
{
    [activityIndicator startAnimating];
    //hide buttons
    [leaveButton setHidden:YES];
    [loveButton setHidden:YES];
    //show data
    [leaveTextLabel setHidden:NO];
    [loveTextLabel setHidden:NO];
    //cast vote
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:LOVE_URL, [currentEntry objectForKey:@"unique_id"]]]
                                             cachePolicy: NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval: 30.0];
    
    REURLConnection *connection = [[REURLConnection alloc] initWithRequest:request delegate:self];
    [connection setTag:[NSString stringWithString:@"love"]];
    
    if (connection) 
    {
        receivedData = [NSMutableData data];
    }
    else 
    {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"There was a network connection error.  Could not receive data." 
                                                           delegate:self 
                                                  cancelButtonTitle:@"OK" 
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
}

#pragma mark - NSURLConnection delegate methods

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse.
    
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    // release the connection, and the data object
    // receivedData is declared as a method instance elsewhere
    
    // inform the user
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"There was a network connection error.  Could not receive data." 
                                                       delegate:self 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil];
    [alertView show];
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    [self setReceivedData:nil];
    
}

- (void)connectionDidFinishLoading:(REURLConnection *)connection
{
    // do something with the data
    // receivedData is declared as a method instance elsewhere
    
    NSLog(@"connection.tag: %@", [connection tag]);
    
    if ([[connection tag] isEqualToString:@"array"])
    {
        NSArray *result = (NSArray *)[NSJSONSerialization JSONObjectWithData:receivedData 
                                                                     options:NSJSONReadingMutableContainers 
                                                                       error:nil];
        NSLog(@"result: [%@]", result);
        randomEntries = [result mutableCopy];
        //show entry
        [self showEntry];
    } 
    else if ([[connection tag] isEqualToString:@"love"])
    {
        //update love tag
        NSDictionary *result = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:receivedData 
                                                                               options:NSJSONReadingMutableContainers 
                                                                                 error:nil];
        NSLog(@"result: [%@]", result);
        [loveTextLabel setText:[NSString stringWithFormat:@"Loves: %@", [result objectForKey:@"newloves"]]];
        [activityIndicator stopAnimating];
    }
    else if ([[connection tag] isEqualToString:@"leave"])
    {
        //update leave tag
        NSDictionary *result = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:receivedData 
                                                                               options:NSJSONReadingMutableContainers 
                                                                                 error:nil];
        NSLog(@"result: [%@]", result);
        [leaveTextLabel setText:[NSString stringWithFormat:@"Leaves: %@", [result objectForKey:@"newleaves"]]];
        [activityIndicator stopAnimating];
    }
    
}

#pragma mark - ADBannerView delegate methods.

-(void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    [self layoutForCurrentOrientation:YES];
}

-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    [self layoutForCurrentOrientation:YES];
}

-(BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    return YES;
}

-(void)bannerViewActionDidFinish:(ADBannerView *)banner
{
}

-(void)createADBannerView
{
    // --- WARNING ---
    // If you are planning on creating banner views at runtime in order to support iOS targets that don't support the iAd framework
    // then you will need to modify this method to do runtime checks for the symbols provided by the iAd framework
    // and you will need to weaklink iAd.framework in your project's target settings.
    // See the iPad Programming Guide, Creating a Universal Application for more information.
    // http://developer.apple.com/iphone/library/documentation/general/conceptual/iPadProgrammingGuide/Introduction/Introduction.html
    // --- WARNING ---
    
    // Depending on our orientation when this method is called, we set our initial content size.
    // If you only support portrait or landscape orientations, then you can remove this check and
    // select either ADBannerContentSizeIdentifierPortrait (if portrait only) or ADBannerContentSizeIdentifierLandscape (if landscape only).
	NSString *contentSize;
	if (&ADBannerContentSizeIdentifierPortrait != nil)
	{
		contentSize = UIInterfaceOrientationIsPortrait(self.interfaceOrientation) ? ADBannerContentSizeIdentifierPortrait : ADBannerContentSizeIdentifierLandscape;
	}
	else
	{
		// user the older sizes 
		contentSize = UIInterfaceOrientationIsPortrait(self.interfaceOrientation) ? ADBannerContentSizeIdentifierPortrait : ADBannerContentSizeIdentifierLandscape;
    }
	
    // Calculate the intial location for the banner.
    // We want this banner to be at the bottom of the view controller, but placed
    // offscreen to ensure that the user won't see the banner until its ready.
    // We'll be informed when we have an ad to show because -bannerViewDidLoadAd: will be called.
    CGRect frame;
    frame.size = [ADBannerView sizeFromBannerContentSizeIdentifier:contentSize];
    frame.origin = CGPointMake(0.0f, CGRectGetMaxY(self.view.bounds));
    
    // Now to create and configure the banner view
    ADBannerView *bannerView = [[ADBannerView alloc] initWithFrame:frame];
    // Set the delegate to self, so that we are notified of ad responses.
    bannerView.delegate = self;
    // Set the autoresizing mask so that the banner is pinned to the bottom
    bannerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin;
    
	// Since we support all orientations in this view controller, support portrait and landscape content sizes.
    // If you only supported landscape or portrait, you could remove the other from this set
	bannerView.requiredContentSizeIdentifiers = (&ADBannerContentSizeIdentifierPortrait != nil) ?
    [NSSet setWithObjects:ADBannerContentSizeIdentifierPortrait, ADBannerContentSizeIdentifierLandscape, nil] : 
    [NSSet setWithObjects:ADBannerContentSizeIdentifierPortrait, ADBannerContentSizeIdentifierLandscape, nil];
    
    // At this point the ad banner is now be visible and looking for an ad.
    [self.view addSubview:bannerView];
    self.banner = bannerView;
    //[bannerView release];
}

-(void)layoutForCurrentOrientation:(BOOL)animated
{
    CGFloat animationDuration = animated ? 0.2f : 0.0f;
    // by default content consumes the entire view area
    CGRect contentFrame = self.view.bounds;
    // the banner still needs to be adjusted further, but this is a reasonable starting point
    // the y value will need to be adjusted by the banner height to get the final position
	CGPoint bannerOrigin = CGPointMake(CGRectGetMinX(contentFrame), CGRectGetMaxY(contentFrame));
    CGFloat bannerHeight = 0.0f;
    
    // First, setup the banner's content size and adjustment based on the current orientation
    if(UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
		banner.currentContentSizeIdentifier = (&ADBannerContentSizeIdentifierLandscape != nil) ? ADBannerContentSizeIdentifierLandscape : ADBannerContentSizeIdentifierLandscape;
    else
        banner.currentContentSizeIdentifier = (&ADBannerContentSizeIdentifierPortrait != nil) ? ADBannerContentSizeIdentifierPortrait : ADBannerContentSizeIdentifierPortrait; 
    bannerHeight = banner.bounds.size.height; 
	
    // Depending on if the banner has been loaded, we adjust the content frame and banner location
    // to accomodate the ad being on or off screen.
    // This layout is for an ad at the bottom of the view.
    if(banner.bannerLoaded)
    {
        contentFrame.size.height -= bannerHeight;
		bannerOrigin.y -= bannerHeight;
    }
    else
    {
		bannerOrigin.y += bannerHeight;
    }
    
    // And finally animate the changes, running layout for the content view if required.
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         contentView.frame = contentFrame;
                         [contentView layoutIfNeeded];
                         banner.frame = CGRectMake(bannerOrigin.x, bannerOrigin.y, banner.frame.size.width, banner.frame.size.height);
                     }];
}


@end
