//
//  CHLAppDelegate.m
//  Film Scanner
//
//  Created by Dr. G. von D. on 4/28/13.
//  Copyright (c) 2013 Chouette Labs. All rights reserved.
//

#import "CHLAppDelegate.h"

@implementation CHLAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.scannerBrowser = [[ICDeviceBrowser alloc] init];
    self.scannerBrowser.delegate = self;
    self.scannerBrowser.browsedDeviceTypeMask = ICDeviceTypeMaskScanner | ICDeviceLocationTypeMaskLocal;
    [self.scannerBrowser start];
}

#pragma mark ICDeviceBrowserDelegate

- (void)deviceBrowser:(ICDeviceBrowser*)browser didAddDevice:(ICDevice*)device moreComing:(BOOL)moreComing
{
    if (device.type & ICDeviceTypeScanner) {
        device.delegate = self;
        NSLog(@"added scanner %@", device);
    }
}

- (void)deviceBrowser:(ICDeviceBrowser*)browser didRemoveDevice:(ICDevice*)device moreGoing:(BOOL)moreGoing
{
    if (device.type & ICDeviceTypeScanner)
        NSLog(@"removed scanner %@", device);
}

#pragma mark ICScannerDeviceDelegate

- (void)didRemoveDevice:(ICDevice*)device
{
    self.scanner = nil;
}

- (void)device:(ICDevice*)device didOpenSessionWithError:(NSError*)error
{
    NSLog(@"session opened %@", error);
}

- (void)deviceDidBecomeReady:(ICDevice*)device
{
    NSLog(@"scanner ready %@", device);
    self.scanner = (ICScannerDevice *)device;
}

- (void)device:(ICDevice*)device didReceiveStatusInformation:(NSDictionary*)status
{
    NSLog(@"status notification %@", status);
}


#pragma mark IBActions

- (IBAction)showHideScannerOptions:(id)sender
{
    if (self.scannerOptionsPanel.isVisible)
        [self.scannerOptionsPanel orderOut:self];
    else
        [self.scannerOptionsPanel orderFront:self];
}

@end
