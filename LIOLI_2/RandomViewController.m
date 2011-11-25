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
}

- (void)viewDidUnload
{
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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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

-(void) receiveDidBegin
{
    
}
-(void) receiveDidEnd
{
    
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
@end
