//
//  SearchViewController.m
//  LIOLI_2
//
//  Created by Raymond Elward on 11/18/11.
//  Copyright (c) 2011 Raymond Elward. All rights reserved.
//
#define URL_TEMPLATE (@"http://lioli.net/init/services/call/json/get_entry/%@")

#import "SearchViewController.h"

@implementation SearchViewController
@synthesize idInputField;
@synthesize submitButton;
@synthesize bodyTextArea;
@synthesize activityIndicator;
@synthesize receivedData;
@synthesize loveLabel;
@synthesize leaveLabel;
@synthesize ageLabel;
@synthesize genderLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView
 {
 }
 */


 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad
 {
     [super viewDidLoad];
     [activityIndicator setHidesWhenStopped:YES];
     [bodyTextArea setHidden:YES];
     [loveLabel setHidden:YES];
     [leaveLabel setHidden:YES];
     [ageLabel setHidden:YES];
     [genderLabel setHidden:YES];
 }
 

- (void)viewDidUnload
{
    [self setIdInputField:nil];
    [self setSubmitButton:nil];
    [self setBodyTextArea:nil];
    [self setActivityIndicator:nil];
    [self setLoveLabel:nil];
    [self setLeaveLabel:nil];
    [self setAgeLabel:nil];
    [self setGenderLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma mark - status management

-(void)receiveDidStart
{
    [submitButton setHidden:YES];
    [activityIndicator startAnimating];
    [bodyTextArea setHidden:YES];
    [loveLabel setHidden:YES];
    [leaveLabel setHidden:YES];
    [ageLabel setHidden:YES];
    [genderLabel setHidden:YES];
}
-(void) receiveDidEnd
{
    [submitButton setHidden:NO];
    [activityIndicator stopAnimating];
}

#pragma mark - touch events

/*
 This method responds when the user touches down on the submit button;
 */
- (IBAction)submitTouchDown:(id)sender 
{
    //remove keyboard and submit button, start the activity indicator:
    [idInputField resignFirstResponder];
    //grab the uniqueId entered into the text field
    NSString *uniqueId = [idInputField text];
    //input validation.
    if ([uniqueId length] == 0) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Invalid input" 
                                                           delegate:self 
                                                  cancelButtonTitle:@"OK" 
                                                  otherButtonTitles:nil];
        [alertView show];
        [self receiveDidEnd];
    }
    else {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:URL_TEMPLATE, uniqueId]]
                                                                      cachePolicy: NSURLRequestUseProtocolCachePolicy
                                                                  timeoutInterval: 30.0];
        
        NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
       
        
        if (connection) {
            receivedData = [NSMutableData data];
            [self receiveDidStart];
        } else {
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:@"There was a network connection error.  Could not receive data." 
                                                               delegate:self 
                                                      cancelButtonTitle:@"OK" 
                                                      otherButtonTitles:nil];
            [alertView show];
        }
    }
}

/*
 This method removes the keyboard if the user touches the screen.
 */
- (IBAction)backgroundTouchDown:(id)sender 
{
    [idInputField resignFirstResponder];
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
    [self receiveDidEnd];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data
    // receivedData is declared as a method instance elsewhere
    
    NSDictionary *result = 
    (NSDictionary *)[NSJSONSerialization JSONObjectWithData:receivedData 
                                                    options:NSJSONReadingMutableContainers 
                                                      error:nil];
    NSLog(@"result: %@", result);
    if ([result objectForKey:@"wrongid"] != NULL || result == NULL){
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"The id you searched is incorrect or has not been approved yet." 
                                                           delegate:self 
                                                  cancelButtonTitle:@"OK" 
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    else {
        
        [bodyTextArea setText:[result objectForKey:@"body"]];
        [bodyTextArea setHidden:NO];
        [loveLabel setText:[NSString stringWithFormat:@"Loves: %@",[result objectForKey:@"loves"]]];
        [loveLabel setHidden:NO];
        [leaveLabel setText:[NSString stringWithFormat:@"Leaves: %@",[result objectForKey:@"leaves"]]];
        [leaveLabel setHidden:NO];
        [ageLabel setText:[NSString stringWithFormat:@"Age: %@",[result objectForKey:@"age"]]];
        [ageLabel setHidden:NO];
        [genderLabel setText:[NSString stringWithFormat:@"Gender: %@",[result objectForKey:@"gender"]]];
        [genderLabel setHidden:NO];
    }
    
    
    [self receiveDidEnd];
    
}


@end
