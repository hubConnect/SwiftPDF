//
//  PDFActivityViewController.m
//  twttest
//
//  Created by Jon Kotowski on 4/5/14.
//  Copyright (c) 2014 Jon Kotowski. All rights reserved.
//

#import "AppDelegate.h"
#import "SpeedViewController.h"
#import "PDFActivityViewController.h"
#import "FXBlurView.h"
#import "LargeSpeedViewController.h"
#import "FileContentsTableViewTableViewController.h"
#import "CloudTableViewController.h"

@interface PDFActivityViewController ()
@property (strong,nonatomic) UIActivityIndicatorView *aSpinner;

@end

@implementation PDFActivityViewController

FXBlurView *blurLayer;
SpeedViewController *speedVC;
UIToolbar *toolbar;
NSOperationQueue *nsOpQ;


FileContentsTableViewTableViewController * fileContentsController;
NSData * cachedPDF;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(void)viewWillAppear:(BOOL)animated {
    
    
    CGRect mainScreen = [[UIScreen mainScreen] bounds];
    self.view.frame = CGRectMake(0, 0, mainScreen.size.width, mainScreen.size.height);
    blurLayer.frame = CGRectMake(0, 0, mainScreen.size.width, mainScreen.size.height);
    
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
        _webView.frame =  CGRectMake(0, 0, mainScreen.size.height, mainScreen.size.width);
        toolbar.frame = CGRectMake(0, 0, mainScreen.size.height, 30);
        
    } else {
        _webView.frame = mainScreen;
        toolbar.frame = CGRectMake(0, 0, mainScreen.size.width, 30);
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    } else {
        // iOS 6
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
    
    
    self.view.frame = [[UIScreen mainScreen] bounds];
    
    [self.navigationController setNavigationBarHidden:YES];
	// Do any additional setup after loading the view.
    
    nsOpQ = [[NSOperationQueue alloc] init];
    
    NSLog(@"Yeah here");
    toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    
    [toolbar setBackgroundColor:[UIColor darkGrayColor]];
    [toolbar setAlpha:.6];
    [toolbar setBackgroundImage:[PDFActivityViewController imageWithColor: [UIColor darkGrayColor] andSize:CGSizeMake(toolbar.frame.size.width, toolbar.frame.size.height)] forToolbarPosition:UIBarPositionTop barMetrics:UIBarMetricsDefault];
        [self.view addSubview:toolbar];
    
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"settingsbutton"] style:UIBarButtonItemStylePlain target:nil action:@selector(settingsAction)];
    
    
    [toolbar setItems:[NSArray arrayWithObject:settingsButton]];
//    
//    //Create the blur layer, set options, add as subview, set hidden.
//    blurLayer = [[FXBlurView alloc] initWithFrame:self.view.frame];
//    [blurLayer setBlurEnabled:NO];
//    [blurLayer setBlurRadius:3];
//    [blurLayer setTintColor:[UIColor colorWithRed:100 green:100 blue:100 alpha:.3]];
//    [blurLayer setBlurRadius:0];
//    [blurLayer setBlurEnabled:YES];
//    //[self.view addSubview:blurLayer];
//    [blurLayer setHidden:YES];
//    
    speedVC = [[SpeedViewController alloc] initWithNibName:@"SpeedViewController" bundle:nil];
    
    [self addChildViewController:speedVC];
    [self.view addSubview:speedVC.SpeedView];
    
    speedVC.SpeedView.hidden = YES;
    //[self loadPDF:@"http://gv.pl/pdf/lord_of_the_flies.pdf"];
    
}

- (void) settingsAction {
    NSLog(@"SettingsButtonHit");
    
    [((AppDelegate *)[UIApplication sharedApplication].delegate).sideMenuViewController openMenuAnimated:YES completion:nil];
    
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    UIMenuItem *customMenuItem1 = [[UIMenuItem alloc] initWithTitle:@"Save" action:@selector(SaveString)] ;
    UIMenuItem *customMenuItem2 = [[UIMenuItem alloc] initWithTitle:@"Read" action:@selector(ReadString)] ;
    [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObjects:customMenuItem1, customMenuItem2, nil]];
    
}

- (void) storeCachedCopy {
    
    [self writePDFToDeviceAsTitle:@"cache"];

}

- (void) writePDFToDeviceAsTitle: (NSString *) title {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *file = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.pdf",title]];
    
    if (self.cachedPDFData == nil) {
        NSLog(@"NIL FUK");
        return;
    }
    
    NSError *error = nil;
    if ([self.cachedPDFData writeToFile:file options:NSDataWritingAtomic error:&error]) {
        // file saved
        NSLog(@"Cache saved");
    } else {
        // error writing file
        NSLog(@"Unable to write PDF to %@. Error: %@", file, error);
    }
}

- (void) loadPDFFromDevice {
    NSLog(@"Loading");
    if (fileContentsController == nil) {
        
        fileContentsController = [[FileContentsTableViewTableViewController alloc] init];
        
    }
    CGRect newScreen;
    CGRect mainScreen = [[UIScreen mainScreen] bounds];
    
    
    
    if (UIInterfaceOrientationIsLandscape( [UIDevice currentDevice ].orientation ) ) {
        newScreen = CGRectMake(0, 0, mainScreen.size.height, mainScreen.size.width);
    } else {
        newScreen = CGRectMake(0, 0, mainScreen.size.width, mainScreen.size.height);
    }
    
    for (NSString * str in [self listFileAtPath:nil]) {
        NSLog(@"%@",str);
    }
    [fileContentsController setDataItems:[self listFileAtPath: nil]];
    [self addChildViewController:fileContentsController];
  
    [self.view addSubview:fileContentsController.view];
    
    
}

- (void) loadPDFFromCloud {
    
    CloudTableViewController * cont = [[CloudTableViewController alloc] init];
    [self addChildViewController:cont];
    [self.view addSubview:cont.view];
    
}

- (void ) loadPDFSynchronous: (NSString *) withString {
    
}

-(NSArray *)listFileAtPath:(NSString *)path
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    path = documentsDirectory;
    
    NSLog(@"LISTING ALL FILES FOUND");
    
    int count;
    
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:NULL];
    NSLog(@"COunt - %d",[directoryContent count]);
    
    for (count = 0; count < (int)[directoryContent count]; count++)
    {
        NSLog(@"File %d: %@", (count + 1), [directoryContent objectAtIndex:count]);
    }
    return directoryContent;
}



-(void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


- (void) loadPDFFromDevice: (NSString *) withString {
    
    if (_webView == nil) {
        NSLog(@"Webview creating");
        _webView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [_webView setScalesPageToFit:YES];
        [_webView setDelegate:self];
        [self.view addSubview:_webView];
        [self.view addSubview:toolbar];
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];

    documentsDir = [documentsDir stringByAppendingPathComponent:withString];
    
    NSData *data = [NSData dataWithContentsOfFile:documentsDir];
    
    [_webView loadData:data MIMEType:@"application/pdf" textEncodingName:@"utf-8" baseURL:nil];
    self.cachedPDFData = [data copy];
    
    NSLog(@" Blark and %d",data.length);
    [self storeCachedCopy];
    
}


- (void) loadPDF: (NSString *) withString {
    
    NSString * path = withString;
    
    [nsOpQ addOperationWithBlock:^{
        
        NSURL *targetURL = [NSURL URLWithString:path];
        NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
        
        [self setSpinner];
        
        NSData * dataStuff = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        //NSData *dataStuff = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:path]];
        NSString * stringOfDataStuff = [[NSString alloc] initWithData:dataStuff encoding:NSUTF8StringEncoding];
        NSLog(@" Blark and path %@",path);
        cachedPDF = [dataStuff copy];
        self.cachedPDFData = [cachedPDF copy];
        [self loadPDFFromData:dataStuff];
        
        
        NSLog(@"About to request PDF document loading...");
        [self.webView loadData:dataStuff    MIMEType:@"application/pdf" textEncodingName:@"utf-8" baseURL:nil];

        NSLog(@"BLAM");
        [self storeCachedCopy];
    }];
    
    
    if ( path ) {
        NSLog(@"LOADING");
//        
//        [NSURLConnection sendAsynchronousRequest:request queue:nsOpQ completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//            NSLog(@"complete");
//            
//            
//            [webView loadData:data  MIMEType:@"application/pdf" textEncodingName:@"UTF-8" baseURL:nil];
//
//        }];
        
    }
}


- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

- (void) loadPDFFromData: (NSData *) data {
    
    [self.webView loadData:data MIMEType:@"application/pdf" textEncodingName:@"UTF-8" baseURL:nil];
}

- (void) setSpinner {
    
    
    if (self.aSpinner == nil) {
        UIActivityIndicatorView *tempSpinner = [[UIActivityIndicatorView alloc]  initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        self.aSpinner = tempSpinner;
    }
    
    self.aSpinner.frame = CGRectMake(((self.view.frame.size.width / 2) - (self.aSpinner.frame.size.width / 2)), ((self.view.frame.size.height / 2) - (self.aSpinner.frame.size.height / 2)), self.aSpinner.frame.size.width, self.aSpinner.frame.size.height);
    
    [self.webView addSubview:self.aSpinner];
    [self.aSpinner startAnimating];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.aSpinner stopAnimating];
    [self.aSpinner removeFromSuperview];
    
}
     
     
+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size
{
    UIImage *img = nil;
        
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,
                                       color.CGColor);
    CGContextFillRect(context, rect);
        
    img = UIGraphicsGetImageFromCurrentImageContext();
        
    UIGraphicsEndImageContext();
        
    return img;
}

- (void) SaveString {
    NSLog(@"");
    
}

- (void) ReadString {
    [[UIApplication sharedApplication] sendAction:@selector(copy:) to:nil from:self forEvent:nil];
    
    NSString *theSelectedText = [UIPasteboard generalPasteboard].string;
    NSLog(@"reading it - %@",[_webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.textContent;"]);
    
    speedVC.stringToRead = theSelectedText;
    
    //blurLayer.hidden = NO;
    speedVC.view.alpha = 0;
    [self.view addSubview: speedVC.view];
    
    [UIView animateWithDuration:1 animations:^{
        
        speedVC.view.alpha = 1;
    }];
    
    [blurLayer setBlurRadius:4];
    
    NSLog(@"Hit");
    
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    CGRect mainScreen = [[UIScreen mainScreen] bounds];
    
    
    
    if (UIInterfaceOrientationIsLandscape( toInterfaceOrientation) ) {
        
        CGRect newScreen = CGRectMake(0, 0, mainScreen.size.height, mainScreen.size.width);
        self.view.frame = newScreen;
        _webView.frame =  newScreen;
        
    } else {
        CGRect newScreen = CGRectMake(0, 0, mainScreen.size.height, mainScreen.size.width);
        
        self.view.frame = newScreen;
        _webView.frame =  newScreen;
    }
    
    toolbar.frame = CGRectMake(0, 0,mainScreen.size.height, 30);
    
    [self.view addSubview:_webView];
    [self.view addSubview:toolbar];
    
    
    if (fileContentsController != nil) {
        
        [self.view addSubview:fileContentsController.view];
    }
    
    NSLog(@"HIT  %f height and %f width",mainScreen.size.height,mainScreen.size.width);
    
}

- (void) removeBlur {
    [blurLayer setHidden: YES];
    [blurLayer setBlurRadius: 0];
    
    [speedVC.view removeFromSuperview];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[UIMenuController sharedMenuController] setMenuItems:nil];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    
    if (action == @selector(copyIt)) {
        NSLog(@"Got it");
        return YES;
    }
    
    return [super canPerformAction:action withSender:sender];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
