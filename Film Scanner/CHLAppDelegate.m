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
    self.scanner = nil;
}

- (void)applicationWillTerminate:(NSNotification *)notification
{
    [self.scanner requestCloseSession];
}

#pragma mark ICDeviceBrowserDelegate

- (void)deviceBrowser:(ICDeviceBrowser*)browser didAddDevice:(ICDevice*)device moreComing:(BOOL)moreComing
{
    if (device.type & ICDeviceTypeScanner) {
        device.delegate = self;
        if (!self.scanner) {
            self.scanner = (ICScannerDevice *)device;
            [self.scanner requestOpenSession];
        }
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
    if (device == self.scanner)
        self.scanner = nil;
}

- (void)device:(ICDevice*)device didOpenSessionWithError:(NSError*)error
{
    NSLog(@"session opened %@", error);
}

- (void)device:(ICDevice*)device didCloseSessionWithError:(NSError*)error
{
    NSLog(@"session closed %@", error);
    if (device == self.scanner)
        self.scanner = nil;
}

- (void)deviceDidBecomeReady:(ICDevice*)device
{
    NSLog(@"scanner ready %@", device);
    assert(device == self.scanner);
//    [self.scanner requestSelectFunctionalUnit:ICScannerFunctionalUnitTypeNegativeTransparency];
    
//    NSLog(@"vendor features %@", self.scanner.selectedFunctionalUnit.vendorFeatures);
}

- (void)device:(ICDevice*)device didReceiveStatusInformation:(NSDictionary*)status
{
    NSLog(@"status notification %@", status);
}

- (void)scannerDevice:(ICScannerDevice*)scanner didSelectFunctionalUnit:(ICScannerFunctionalUnit*)functionalUnit error:(NSError*)error
{
    NSLog(@"selected functional unit %@", self.scanner.selectedFunctionalUnit);    
}


#pragma mark IBActions

- (IBAction)showHideScannerOptions:(id)sender
{
    if (self.scannerOptionsPanel.isVisible)
        [self.scannerOptionsPanel orderOut:self];
    else
        [self.scannerOptionsPanel orderFront:self];
}

- (IBAction)setFilmType:(id)sender
{
    if (!self.scanner)
        return;
    
    ICScannerFunctionalUnitType type = ([sender tag] == 0 || [sender tag] == 1) ?
        ICScannerFunctionalUnitTypeNegativeTransparency :
        ICScannerFunctionalUnitTypePositiveTransparency;
    [self.scanner requestSelectFunctionalUnit:type];
}

@end
