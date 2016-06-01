//
//  InterfaceController.m
//  WatchKitExample Extension
//
//  Created by Piyawut Chantasrisawat on 25/05/2016.
//  Copyright © 2016 uts. All rights reserved.
//

#import "InterfaceController.h"
#import <WatchConnectivity/WatchConnectivity.h>

@interface InterfaceController()<WCSessionDelegate>

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    
    if([WCSession isSupported]){
        WCSession *session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
    }

}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (IBAction)BackButtonPressed {
    NSString *cmdString = @"Back";
    [self sendCommand:cmdString];
}

- (IBAction)ForwardButtonPressed {
    NSString *cmdString = @"Forward";
    [self sendCommand:cmdString];
}

- (IBAction)FavouriteButtonPressed {
    NSString *cmdString = @"Favourite";
    [self sendCommand:cmdString];
}

- (IBAction)RefreshButtonPressed {
    NSString *cmdString = @"Refresh";
    [self sendCommand:cmdString];
}

/**
 * send command to app
 */
- (void) sendCommand:(NSString*) cmdString{
    NSDictionary *applicationData = [[NSDictionary alloc] initWithObjects:@[cmdString] forKeys:@[@"cmdValue"]];
    
    [[WCSession defaultSession] sendMessage:applicationData
                               replyHandler:^(NSDictionary *reply) {
                                   //handle reply from iPhone app here
                               }
                               errorHandler:^(NSError *error) {
                                   //catch any errors here
                               }
     ];
}

/**
 * get current url from app
 */
- (void)session:(nonnull WCSession *)session didReceiveMessage:(nonnull NSDictionary<NSString *,id> *)message replyHandler:(nonnull void (^)(NSDictionary<NSString *,id> * __nonnull))replyHandler {
    NSString *url = [message objectForKey:@"url"];
    [_urlLabel setText:url];
}

@end



