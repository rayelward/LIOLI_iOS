//
//  AboutViewController.h
//  LIOLI_2
//
//  Created by Raymond Elward on 11/18/11.
//  Copyright (c) 2011 Raymond Elward. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MessageUI/MessageUI.h>

@interface AboutViewController : UIViewController < MFMailComposeViewControllerDelegate> {
    
}

- (IBAction)emailButton:(id)sender;
- (void) showEmailModalView;

@end

