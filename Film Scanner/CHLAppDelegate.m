//
//  CHLAppDelegate.m
//  Film Scanner
//
//  Created by Dr. G. von D. on 4/28/13.
//  Copyright (c) 2013 Chouette Labs. All rights reserved.
//

#import "CHLAppDelegate.h"
#import "CHLScannerController.h"

@interface CHLScannerMenuItem : NSMenuItem
@property (weak) ICScannerDevice *scanner;
@end

@implementation CHLScannerMenuItem

- (id)initWithScanner:(ICScannerDevice *)scanner
{
    self = [super init];
    if (self) {
        self.scanner = scanner;
        self.title = scanner.name;
        self.image = [[NSImage alloc] initWithCGImage:scanner.icon size:NSMakeSize(32, 32)];
        self.target = [NSApp delegate];
        self.action = @selector(selectScanner:);
        if (scanner == ((CHLAppDelegate *)[NSApp delegate]).scannerController.scanner)
            self.state = NSOnState;
    }
    return self;
}

@end

@implementation CHLAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.scannerController = [[CHLScannerController alloc] init];
}

- (void)applicationWillTerminate:(NSNotification *)notification
{
    self.scannerController = nil;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
//    if (object == self.scannerController && [keyPath isEqualToString:@"scanners"])
//        ;
}

#pragma mask NSMenuDelegate -- Scanner Selection Menu

- (void)selectScanner:(CHLScannerMenuItem *)sender
{
    self.scannerController.scanner = sender.scanner;
}

- (void)menuNeedsUpdate:(NSMenu *)menu
{
    if (menu == self.scannersMenu) {
        [menu removeAllItems];
        
        for (ICScannerDevice *scanner in self.scannerController.scanners) {
            CHLScannerMenuItem *item = [[CHLScannerMenuItem alloc] initWithScanner:scanner];
            [menu addItem:item];
        }
    }
}

@end
