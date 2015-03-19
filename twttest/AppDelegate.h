//
//  AppDelegate.h
//  twttest
//
//  Created by Jon Kotowski on 3/20/14.
//  Copyright (c) 2014 Jon Kotowski. All rights reserved.
//

#import "MainViewController.h"
#import "MenuViewController.h"
#import "TWTSideMenuViewController.h"
#import <UIKit/UIKit.h>
#import "PDFScreenViewController.h"
#import "WebScreenViewController.h"
#import "PDFActivityViewController.h"
#import <Parse/Parse.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, TWTSideMenuViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIViewController* mainViewController;
@property (strong, nonatomic) TWTSideMenuViewController * sideMenuViewController;
@property (strong, nonatomic) MenuViewController * menuViewController;
@property (strong, nonatomic) PDFScreenViewController * PDFScreenViewController;
@property (strong, nonatomic) PDFActivityViewController * PDFActivityViewController;
@property (strong, nonatomic) WebScreenViewController * webScreenViewController;
@property (strong, nonatomic) NSString * pathForPDF;
@property bool didLaunchFromFile;
@property (strong, nonatomic) PFUser * user;

@property (strong, nonatomic) NSURL *urlToLoad;


- (bool) attemptToLoadPDF: (NSString *) fromString;
- (void) launchReader:(NSString *) withString;

- (void) saveToCloud: (NSData *) data withName: (NSString *) string;

@end
