//
//  CHLAppDelegate.h
//  Film Scanner
//
//  Created by Dr. G. von D. on 4/28/13.
//  Copyright (c) 2013 Chouette Labs. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>

@class CHLScannerController;

@interface CHLAppDelegate : NSObject <NSApplicationDelegate, NSMenuDelegate>

@property (strong) CHLScannerController *scannerController;

@property (assign) IBOutlet NSWindow *window;
@property (strong) IBOutlet NSMenu *scannersMenu;

@end
