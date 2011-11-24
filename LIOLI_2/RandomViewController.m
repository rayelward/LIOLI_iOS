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
        [self fillArray];
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
    connection.tag = [NSString stringWithString:@"array"];
    
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


-(void) receiveDidBegin
{
    
}
-(void) receiveDidEnd
{
    
}

#pragma mark - touch events

- (IBAction)nextTouchDown:(id)sender 
{
    //hide next
    
    //if array is empty collect 10 more
    
    //else add
}

- (IBAction)leaveTouchDown:(id)sender 
{
    //hide buttons
    
    //cast vote
}

- (IBAction)loveTouchDown:(id)sender 
{
    //hide buttons
    
    //show data
    
    //cast vote
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
    
    NSLog(@"connection.tag: %@", connection.tag);
    
    if ([connection.tag isEqualToString:@"array"])
    {
        NSArray *result = (NSArray *)[NSJSONSerialization JSONObjectWithData:receivedData 
                                                                     options:NSJSONReadingMutableContainers 
                                                                       error:nil];
        NSLog(@"result: [%@]", result);
        randomEntries = [result mutableCopy];
        //Array got filled!
    } 
    else if ([connection.tag isEqualToString:@"love"])
    {
        //update love tag
        NSDictionary *result = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:receivedData 
                                                                               options:NSJSONReadingMutableContainers 
                                                                                 error:nil];
        [loveTextLabel setText:[NSString stringWithFormat:@"Loves: %@", [result objectForKey:@"new_loves"]]];
    }
    else if ([connection.tag isEqualToString:@"leave"])
    {
        //update leave tag
        NSDictionary *result = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:receivedData 
                                                                               options:NSJSONReadingMutableContainers 
                                                                                 error:nil];
        [leaveTextLabel setText:[NSString stringWithFormat:@"Leaves: %@", [result objectForKey:@"new_leaves"]]];
    }
    
}
@end
