//
//  SubmitViewController.m
//  LIOLI_2
//
//  Created by Raymond Elward on 11/18/11.
//  Copyright (c) 2011 Raymond Elward. All rights reserved.
//
#define URL_TEMPLATE (@"http://lioli.net/init/services/call/json/submit")

#import "SubmitViewController.h"

@implementation SubmitViewController
@synthesize bodyTextField;
@synthesize genderTextField;
@synthesize outputTextView;
@synthesize ageTextField;
@synthesize submitButton;
@synthesize activityIndicator;

@synthesize receivedData;

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
}


- (void)viewDidUnload
{
    [self setSubmitButton:nil];
    [self setAgeTextField:nil];
    [self setGenderTextField:nil];
    [self setBodyTextField:nil];
    [self setOutputTextView:nil];
    [self setActivityIndicator:nil];
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
}
-(void) receiveDidEnd
{
    [submitButton setHidden:NO];
    [activityIndicator stopAnimating];
}

#pragma mark - input validation methods

-(bool)validateBody:(NSString *)body age:(NSString *)age gender:(NSString *)gender
{
    //check that they're not empty
    if ([body length] < 1 || [age length] < 1 || [gender length] < 1)
    {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Please fill out all the fields." 
                                                           delegate:self 
                                                  cancelButtonTitle:@"OK" 
                                                  otherButtonTitles:nil];
        [alertView show];
        return NO;
    }
    //check that age is < 125 and > 0
    if ([age intValue] < 0 || [age intValue] > 125)
    {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"I'm sorry that age is out of our age range for submissions." 
                                                           delegate:self 
                                                  cancelButtonTitle:@"OK" 
                                                  otherButtonTitles:nil];
        [alertView show];
        return NO;
    }
    //check that gender is M or F
    if ( (![gender isEqualToString:@"M"]) && (![gender isEqualToString:@"F"]) )
    {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Gender must be M or F." 
                                                           delegate:self 
                                                  cancelButtonTitle:@"OK" 
                                                  otherButtonTitles:nil];
        [alertView show];
        return NO;
    }
    //check that body is less than 2048 characters.
    if ([body length] > 2048)
    {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Please keep your submission under 2048 characters." 
                                                           delegate:self 
                                                  cancelButtonTitle:@"OK" 
                                                  otherButtonTitles:nil];
        [alertView show];
        return NO;
    }
    return YES;
}

#pragma mark - Touch event methods

- (IBAction)submitTouchDown:(id)sender 
{
    [bodyTextField resignFirstResponder];
    [genderTextField resignFirstResponder];
    [ageTextField resignFirstResponder];
    
    NSString *body = [bodyTextField text];
    NSString *age = [ageTextField text];
    NSString *gender = [genderTextField text];
    NSLog(@"body: %@", body);
    NSLog(@"age: %@", age);
    NSLog(@"gender: %@", gender);
    
    if ([self validateBody:body age:age gender:gender]){
        //send post
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString:URL_TEMPLATE]
                                                 cachePolicy: NSURLRequestUseProtocolCachePolicy
                                             timeoutInterval: 30.0];
        NSLog(@"nsurl: %@", request);
        NSString *params = [NSString stringWithFormat:@"body=%@&age=%@&gender=%@", body, age, gender];
        
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
        
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
        
        [self receiveDidStart];
    }
}

- (IBAction)backgroundTouchDown:(id)sender 
{
    [bodyTextField resignFirstResponder];
    [genderTextField resignFirstResponder];
    [ageTextField resignFirstResponder];
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
                                                            message:@"There was an error with the server.  sorry.." 
                                                           delegate:self 
                                                  cancelButtonTitle:@"OK" 
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    else {
        NSString *uniqueId = [result objectForKey:@"unique_id"];
        
        [outputTextView setText:[NSString stringWithFormat:@"Thank you.  Your submission is awaiting moderator approval.  keep %@ for your records to look up later.", uniqueId]];
       
    }
    
    
    [self receiveDidEnd];
    
}

@end
