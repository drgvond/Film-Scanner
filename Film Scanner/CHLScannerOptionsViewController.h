//
//  CHLScannerOptionsViewController.h
//  Film Scanner
//
//  Created by Dr. G. von D. on 4/28/13.
//  Copyright (c) 2013 Chouette Labs. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <ImageCaptureCore/ImageCaptureCore.h>

@interface CHLScannerOptionsViewController : NSViewController

- (void)setScannerProperties:(ICScannerDevice *)scanner;

@end
