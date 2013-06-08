//
//  CHLScannerController.h
//  Film Scanner
//
//  Created by Dr. G. von D. on 6/3/13.
//  Copyright (c) 2013 Chouette Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ImageCaptureCore/ImageCaptureCore.h>

@interface CHLScannerController : NSObject <ICDeviceBrowserDelegate, ICScannerDeviceDelegate>

@property (readonly, strong, nonatomic) ICDeviceBrowser *scannerBrowser;
@property (strong, nonatomic) ICScannerDevice *scanner;
@property (readonly, strong) NSMutableArray *scanners;

- (void)setFilmType:(id)sender;
- (void)scanPreview;


@end
