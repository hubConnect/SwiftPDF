//
//  PDFScreenViewController.m
//  twttest
//
//  Created by Jon Kotowski on 4/5/14.
//  Copyright (c) 2014 Jon Kotowski. All rights reserved.
//

#import "PDFScreenViewController.h"
#import "PDFActivityViewController.h"
#import "AppDelegate.h"
#import "WebScreenViewController.h"

@interface PDFScreenViewController ()

@end

@implementation PDFScreenViewController

AppDelegate * appD;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    UIMenuItem *customMenuItem1 = [[UIMenuItem alloc] initWithTitle:@"Custom 1" action:@selector(copyIt)] ;
    UIMenuItem *customMenuItem2 = [[UIMenuItem alloc] initWithTitle:@"Custom 2" action:@selector(copyIt)] ;
    [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObjects:customMenuItem1, customMenuItem2, nil]];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self
               action:@selector(openButtonPressed)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Show View" forState:UIControlStateNormal];
    button.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
    [button setTitle:@"One" forState:UIControlStateNormal];
    //[self.view addSubview:button];

    appD = (AppDelegate * )[UIApplication sharedApplication].delegate;
    
	// Do any additional setup after loading the view.
 
    
    
    self.AwesomeButtonOutlet.layer.shadowOffset = CGSizeMake(-15, 20);
    self.AwesomeButtonOutlet.layer.shadowRadius = 5;
    self.AwesomeButtonOutlet.layer.shadowOpacity = 0.5;
}


- (void) openButtonPressed {
    [UIView animateWithDuration:.5 animations:^{
        
        appD.mainViewController = appD.PDFScreenViewController;
        appD.mainViewController.view = appD.PDFScreenViewController.view;
        
        NSLog(@"ah");
    }];
    [self swapControllers];
}
- (void) swapControllers {
    UINavigationController *myNavigationController = self.navigationController;
    
    [myNavigationController popViewControllerAnimated:NO];
    
    PDFActivityViewController *controller = [[PDFActivityViewController alloc] initWithNibName:@"PDFActivityView" bundle:nil];
    [(AppDelegate *) [UIApplication sharedApplication].delegate setPDFActivityViewController:controller];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration: 0.65];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:myNavigationController.view cache:YES];
    [myNavigationController pushViewController:controller animated:NO];
    [UIView commitAnimations];
    
}

- (void) copyIt {
    NSLog(@"Hit");
   // UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 10, 200, 200)];
    
    NSURL *targetURL = [NSURL URLWithString:@"http://developer.apple.com/iphone/library/documentation/UIKit/Reference/UIWebView_Class/UIWebView_Class.pdf"];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    //[webView loadRequest:request];
    NSLog(@"Yeah here");
    //[self.view addSubview:webView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    
}

- (IBAction)ActionOpen:(id)sender {
    [self openButtonPressed];
}
@end
