//
//  RecentsViewController.m
//  LIOLI_2
//
//  Created by Raymond Elward on 11/19/11.
//  Copyright (c) 2011 Raymond Elward. All rights reserved.
//

#import "RecentsViewController.h"

#define URL_TEMPLATE (@"http://lioli.net/init/services/call/json/recents/%@")

@implementation RecentsViewController

@synthesize receivedData;
@synthesize dataArray;
@synthesize myTableView;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    dataArray = [NSMutableArray array];
    
    [self loadTenEntriesFromPage: [NSNumber numberWithInt: 0]];
    NSLog(@"viewDidLoad");
}

- (void)viewDidUnload
{
    [self setMyTableView:nil];
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *entry = [dataArray objectAtIndex:[indexPath row]];
    
    // Configure the cell...
    [cell.textLabel setText:[NSString stringWithFormat:@"unique: %@", [entry objectForKey:@"unique_id"]]];
    
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark - Getting data from the server

-(void)loadTenEntriesFromPage:(NSNumber *)pageNumber
{
    NSLog(@"URL: %@", [NSString stringWithFormat:URL_TEMPLATE, pageNumber]);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:URL_TEMPLATE, pageNumber]]
                                             cachePolicy: NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval: 30.0];
    
    REURLConnection *connection = [[REURLConnection alloc] initWithRequest:request delegate:self];
    
    [connection setTag:@"array"];
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
        [dataArray addObjectsFromArray:result];
        [myTableView reloadData];
    } 
    else if ([[connection tag] isEqualToString:@"love"])
    {
        //update love tag
        NSDictionary *result = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:receivedData 
                                                                               options:NSJSONReadingMutableContainers 
                                                                                 error:nil];
        NSLog(@"result: [%@]", result);
        
    }
    else if ([[connection tag] isEqualToString:@"leave"])
    {
        //update leave tag
        NSDictionary *result = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:receivedData 
                                                                               options:NSJSONReadingMutableContainers 
                                                                                 error:nil];
        NSLog(@"result: [%@]", result);
    }
    
}

@end
