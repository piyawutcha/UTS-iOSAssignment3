//
//  InterfaceController.h
//  WatchKitExample Extension
//
//  Created by Piyawut Chantasrisawat on 25/05/2016.
//  Copyright © 2016 uts. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface InterfaceController : WKInterfaceController
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *urlLabel;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceButton *BackButton;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceButton *ForwardButton;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceButton *FavouriteButton;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceButton *RefreshButton;

- (IBAction)BackButtonPressed;
- (IBAction)ForwardButtonPressed;
- (IBAction)FavouriteButtonPressed;
- (IBAction)RefreshButtonPressed;

@end
