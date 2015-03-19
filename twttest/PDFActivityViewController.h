//
//  PDFActivityViewController.h
//  twttest
//
//  Created by Jon Kotowski on 4/5/14.
//  Copyright (c) 2014 Jon Kotowski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDFActivityViewController : UIViewController
<UIWebViewDelegate,UITableViewDelegate>

- (void) removeBlur;
- (void) loadPDF: (NSString *) withString;
- (void) writePDFToDeviceAsTitle: (NSString *) title;
- (void) loadPDFFromDevice;
- (void) loadPDFFromCloud;
- (void) loadPDFFromData: (NSData *) data;
- (void) loadPDFFromDevice: (NSString *) withString;
-(NSArray *)listFileAtPath:(NSString *)path;



@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) NSData *cachedPDFData;

@end
