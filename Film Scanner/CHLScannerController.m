//
//  CHLScannerController.m
//  Film Scanner
//
//  Created by Dr. G. von D. on 6/3/13.
//  Copyright (c) 2013 Chouette Labs. All rights reserved.
//

#import "CHLScannerController.h"

@implementation CHLScannerController

- (id)init
{
    self = [super init];
    if (self) {
        _scanner = nil;
        _scanners = [[NSMutableArray alloc] init];
        _scannerBrowser = [[ICDeviceBrowser alloc] init];
        _scannerBrowser.delegate = self;
        _scannerBrowser.browsedDeviceTypeMask = _scannerBrowser.browsedDeviceTypeMask
            | ICDeviceTypeMaskScanner | ICDeviceLocationTypeMaskLocal;
        [_scannerBrowser start];
    }
    
    return self;
}

- (void)dealloc
{
    [self.scanner requestCloseSession];
    self.scannerBrowser.delegate = nil;
    [self.scannerBrowser stop];
    _scannerBrowser = nil;
}

- (void)setScanner:(id)scanner {
    if (_scanner != scanner) {
        [_scanner requestCloseSession];
        _scanner = scanner;
//        _scanner.delegate = self;
        [_scanner requestOpenSession];
    }
}

- (void)setFilmType:(id)sender
{
    if (!self.scanner)
        return;
    
    ICScannerFunctionalUnitType type = ([sender tag] == 0 || [sender tag] == 1) ?
        ICScannerFunctionalUnitTypeNegativeTransparency : ICScannerFunctionalUnitTypePositiveTransparency;
    [self.scanner requestSelectFunctionalUnit:type];
}

#pragma mark ICDeviceBrowserDelegate

- (void)deviceBrowser:(ICDeviceBrowser*)browser didAddDevice:(ICDevice*)device moreComing:(BOOL)moreComing
{
    if (device.type & ICDeviceTypeScanner) {
        device.delegate = self;
        
        [self willChangeValueForKey:@"scanners"];
        [self.scanners addObject:device];
        [self didChangeValueForKey:@"scanners"];
        
//        if (!moreComing && self.scanners.count == 1)
//            self.scanner = self.scanners[0];
    }
}

- (void)deviceBrowser:(ICDeviceBrowser*)browser didRemoveDevice:(ICDevice*)device moreGoing:(BOOL)moreGoing
{
    if (device.type & ICDeviceTypeScanner) {
        device.delegate = nil;
        
        [self willChangeValueForKey:@"scanners"];
        [self.scanners removeObject:device];
        [self didChangeValueForKey:@"scanners"];
    }
}

#pragma mark ICScannerDeviceDelegate

- (void)didRemoveDevice:(ICDevice*)device
{
    device.delegate = nil;
    if (device == self.scanner)
        _scanner = nil;
}

- (void)device:(ICDevice*)device didOpenSessionWithError:(NSError*)error
{
    if (error) {
        NSAlert *alert = [NSAlert alertWithError:error];
        [alert runModal];
    } else {
        self.scanner = (ICScannerDevice *)device;
    }
    
}

- (void)device:(ICDevice*)device didCloseSessionWithError:(NSError*)error
{
    if (error) {
        NSAlert *alert = [NSAlert alertWithError:error];
        [alert runModal];
    }

    if (device == self.scanner)
        _scanner = nil;
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
    if (error) {
        NSAlert *alert = [NSAlert alertWithError:error];
        [alert runModal];
    }
    NSLog(@"selected functional unit %@", self.scanner.selectedFunctionalUnit);
}

@end
