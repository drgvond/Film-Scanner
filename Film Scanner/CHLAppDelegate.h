//
//  CHLAppDelegate.h
//  Film Scanner
//
//  Created by Dr. G. von D. on 4/28/13.
//  Copyright (c) 2013 Chouette Labs. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <ImageCaptureCore/ImageCaptureCore.h>

@interface CHLAppDelegate : NSObject <NSApplicationDelegate, ICDeviceBrowserDelegate, ICScannerDeviceDelegate>

@property (strong, nonatomic) ICDeviceBrowser *scannerBrowser;
@property (weak) ICScannerDevice *scanner;

@property (assign) IBOutlet NSWindow *window;
@property (strong) IBOutlet NSPanel *scannerOptionsPanel;

- (IBAction)showHideScannerOptions:(id)sender;
@end
