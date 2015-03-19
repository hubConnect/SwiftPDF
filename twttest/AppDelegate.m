//
//  AppDelegate.m
//  twttest
//
//  Created by Jon Kotowski on 3/20/14.
//  Copyright (c) 2014 Jon Kotowski. All rights reserved.
//

#import "AppDelegate.h"
#import "SpeedViewController.h"
#import "PDFActivityViewController.h"

@implementation AppDelegate
SpeedViewController * spvc ;bool didLaunchFromURL = NO;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    
    if (_didLaunchFromFile) {
        NSLog(@"FUCK IT");
    }
    
    self.pathForPDF = @"blah";
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.menuViewController = [[MenuViewController alloc] initWithNibName:nil bundle:nil];
    
    if (!didLaunchFromURL) {
        self.mainViewController = [[MainViewController alloc] init];
        self.mainViewController.view.frame = CGRectMake(0, 0, self.window.frame.size.width, self.window.frame.size.height);
        
    }
    
    NSURL *url = (NSURL *)[launchOptions valueForKey:UIApplicationLaunchOptionsURLKey];
    if ([url isFileURL]) {
        _urlToLoad = url;
    }
    
    self.sideMenuViewController = [[TWTSideMenuViewController alloc] initWithMenuViewController:self.menuViewController mainViewController:[[PDFActivityViewController alloc] initWithNibName:@"PDFActivityView" bundle:nil]];
    self.sideMenuViewController.mainViewController.view.frame = self.window.bounds;
    self.PDFActivityViewController = (PDFActivityViewController* )self.sideMenuViewController.mainViewController;
    self.sideMenuViewController.mainViewController.navigationController.navigationBarHidden = YES;
    self.sideMenuViewController.shadowColor = [UIColor grayColor];
    self.sideMenuViewController.edgeOffset = (UIOffset) { .horizontal = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 18.0f : 0.0f };
    self.sideMenuViewController.zoomScale = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 0.5634f : 0.85f;
    self.sideMenuViewController.delegate = self;
    
    self.window.rootViewController = self.sideMenuViewController;
    self.window.backgroundColor = [UIColor clearColor];
    [self.window makeKeyAndVisible];
    
    self.sideMenuViewController.view.frame = CGRectMake(0, 0, self.window.frame.size.width, self.window.frame.size.height);
    
    
    [self loadCached];
    return YES;
}

- (void) loadCached {
    [self.PDFActivityViewController loadPDFFromDevice:@"cache.pdf"];
}


-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSFileManager *filemgr = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* inboxPath = [documentsDirectory stringByAppendingPathComponent:@"Inbox"];
    NSArray *dirFiles = [filemgr contentsOfDirectoryAtPath:inboxPath error:nil];
    NSString *contents = dirFiles[0];
    
    _didLaunchFromFile = YES;
    
    if (self.PDFActivityViewController == nil) {
        
        self.PDFActivityViewController = [[PDFActivityViewController alloc] initWithNibName:@"PDFActivityView" bundle:nil];
    }
    
    
    [self attemptToLoadPDF:contents];
    
    return YES;
}

- (void) saveToCloud: (NSData *) data withName: (NSString *) string {
//    
//    data = self.PDFActivityViewController.cachedPDFData;
//    
//    PFFile *PDF = [PFFile fileWithName:[NSString stringWithFormat:@"%@.pdf",string ] data:data];
//    
//    
//    [PDF saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        
//        if (error) {
//            NSLog(@"Save error");
//            
//        }
//        if (succeeded) {
//            PFObject *PDFAssociation = [PFObject objectWithClassName:@"PDFThing"];
//            
//            PDFAssociation[@"Name"] = [NSString stringWithFormat:@"%@.pdf",string ];
//            PDFAssociation[@"File"] = PDF;
//            
//            [PDFAssociation saveInBackground];
//            
//            NSLog(@"Save succeess");
//        }
//        NSLog(@"Completed save");
//    }];
    
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (UIStatusBarStyle)sideMenuViewController:(TWTSideMenuViewController *)sideMenuViewController statusBarStyleForViewController:(UIViewController *)viewController
{
    if (viewController == self.menuViewController) {
        return UIStatusBarStyleLightContent;
    } else {
        return UIStatusBarStyleDefault;
    }
}

- (void)sideMenuViewControllerWillOpenMenu:(TWTSideMenuViewController *)sender {
    NSLog(@"willOpenMenu");
    [self.menuViewController.menuTable setDataSource:nil];
    [self.menuViewController.menuTable reloadData];
}

- (void)sideMenuViewControllerDidOpenMenu:(TWTSideMenuViewController *)sender {
    NSLog(@"didOpenMenu");
    
    [self.menuViewController.menuTable setDataSource:self.menuViewController];
    [self.menuViewController reloadTable];
}

- (void)sideMenuViewControllerWillCloseMenu:(TWTSideMenuViewController *)sender {
    NSLog(@"willCloseMenu");
}

- (void)sideMenuViewControllerDidCloseMenu:(TWTSideMenuViewController *)sender {
	NSLog(@"didCloseMenu");
}

- (bool) attemptToLoadPDF: (NSString *) fromString {
    
    if (self.PDFActivityViewController == nil) {
    NSLog(@"Attempting to launch");
        return NO;
    }
    
    NSLog(@" loading %@",_urlToLoad);
    
    if (_urlToLoad.isFileURL) {
        NSLog(@"It's a file");
        
        NSData *dataStuff = [[NSData alloc] initWithContentsOfURL:_urlToLoad];

        [self.PDFActivityViewController loadPDFFromData:dataStuff];
    } else {
        
        NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:_urlToLoad];
        
        [self.PDFActivityViewController.webView loadRequest:req];
    }
    
    return YES;
}

-(void)launchReader:(NSString *)withString {
   
    
    [self.mainViewController.navigationController popViewControllerAnimated:NO];
    spvc = [[SpeedViewController alloc] initWithNibName:@"SpeedViewController" bundle:nil];
    spvc.view.frame = CGRectMake(0, 0, 200, 200);
    NSLog(@"launching");
    [((MainViewController *)self.mainViewController).pageViewController.navigationController pushViewController:spvc animated:YES];
    
}


@end
