//
//  TWTMainViewController.m
//  TWTSideMenuViewController-Sample
//
//  Created by Josh Johnson on 8/14/13.
//  Copyright (c) 2013 Two Toasters. All rights reserved.
//

#import "MainViewController.h"
#import "TWTSideMenuViewController.h"
#import "SpeedViewController.h"
#import "ContentContainerController.h"
#import "WebScreenViewController.h"
#import "PDFScreenViewController.h"
#import "AppDelegate.h"

#import "PDFActivityViewController.h"
#define kOffset 44

@interface MainViewController ()

@end

@implementation MainViewController

UIView * hierarchy;
CGPoint pointOfLastTouch;
UIImageView * pullTabView;
bool isSlidingOpenOrClosed = NO;
CGPoint centerOfClosedState;
CGPoint centerOfOpenState;
NSArray *viewControllers;

UIImage * pullTab;
CGFloat newLocation;


- (id)init
{
    self = [super initWithNibName:@"View" bundle:nil];
    if (self != nil)
    {
        // Further initialization if needed
    }
    return self;
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
+ (UIImage *)applyBlurOnImage: (UIImage *)imageToBlur withRadius: (CGFloat)blurRadius {
    CIImage *originalImage = [CIImage imageWithCGImage: imageToBlur.CGImage];
    CIFilter *filter = [CIFilter filterWithName: @"CIGaussianBlur" keysAndValues: kCIInputImageKey, originalImage, @"inputRadius", @(blurRadius), nil];
    CIImage *outputImage = filter.outputImage;
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef outImage = [context createCGImage: outputImage fromRect: [outputImage extent]];
    return [UIImage imageWithCGImage: outImage];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}
-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    if (viewController == viewControllers[1]) {
        return viewControllers[0];
    } else return viewControllers[1];
    
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    if (viewController == viewControllers[0]) {
        return viewControllers[1];
    } else return viewControllers[0];
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

    [self.navigationController setNavigationBarHidden:YES];
    
//    self.title = @"My View";
//   
//    UIBarButtonItem *openItem = [[UIBarButtonItem alloc] initWithTitle:@"Open" style:UIBarButtonItemStylePlain target:self action:@selector(openButtonPressed)];
//    self.navigationItem.leftBarButtonItem = openItem;
//
    
    UIViewController * PDFChoiceScreen = [[PDFActivityViewController alloc] initWithNibName:@"PDFActivityView" bundle:nil];
    
    [(AppDelegate *) [UIApplication sharedApplication].delegate setPDFActivityViewController:PDFChoiceScreen];
    UIViewController * WebChoiceScreen = [[WebScreenViewController alloc] initWithNibName:@"WebChoiceScreen" bundle:nil];
    viewControllers = [[NSArray alloc] initWithObjects:PDFChoiceScreen,WebChoiceScreen, nil];
    NSLog(@"%@ %@",PDFChoiceScreen,WebChoiceScreen);
    
   // _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationVertical options: @{UIPageViewControllerOptionInterPageSpacingKey:[NSNumber numberWithFloat:-100]}];
    _pageViewController = PDFChoiceScreen;
    
    _pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width , self.view.frame.size.height);
    NSArray *startController = [[NSArray alloc] initWithObjects:viewControllers[0], nil];
//    [_pageViewController setViewControllers:startController direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
//    [_pageViewController setDataSource:self];
//    [_pageViewController setDelegate:self];
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    
//    
//    hierarchy = [[UIView alloc] init];
//    hierarchy.frame = CGRectMake( 0, 0, self.view.frame.size.width , self.view.frame.size.height);
//     [self.view addSubview:hierarchy];
//    UIViewController * containerController = [[ContentContainerController alloc] init];
//    CGRect frame =[[UIScreen mainScreen] bounds];
//    frame.origin.y = frame.origin.y + kOffset;
//    containerController.view.frame = frame;
//    [self addChildViewController:containerController];
//    
//    UIViewController * speedController = [[SpeedViewController alloc] init];
//    speedController.view.frame = CGRectMake(hierarchy.frame.origin.x, hierarchy.frame.origin.y + kOffset, hierarchy.frame.size.width, kOffset);
//    [self addChildViewController:speedController];
//    
//    pullTab = [UIImage imageNamed:@"pull-tab-2"];
//    pullTabView = [[UIImageView alloc] initWithImage:pullTab];
//    pullTabView.frame = CGRectMake(60, 53, 40, 15);
//    pullTabView.alpha = .9;
//    pullTabView.userInteractionEnabled = YES;
//    
//    UIImage * dasBlurredImage = [UIImage imageNamed:@"aluminum_tbg"];
//    UIImage *bg = [MainViewController imageWithImage:dasBlurredImage scaledToSize: hierarchy.frame.size];
//    UIImageView *iv = [[UIImageView alloc] initWithImage:bg];
//    iv.frame = hierarchy.frame;
//    
//    [hierarchy addSubview:speedController.view];
//    [hierarchy addSubview:containerController.view];
//    [hierarchy addSubview:pullTabView];
//    [hierarchy addSubview:iv];
//    
//    dasBlurredImage = [MainViewController applyBlurOnImage:dasBlurredImage withRadius:.5];
 
    
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button2 addTarget:self
               action:@selector(openButtonPressed)
     forControlEvents:UIControlEventTouchUpInside];
    [button2 setTitle:@"Show View" forState:UIControlStateNormal];
    button2.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
    [button2 setTitle:@"two" forState:UIControlStateNormal];
    [[viewControllers[1] view ] addSubview:button2];
    
    
//    
//    
//    NSLog(@"%lf %lf origins, %lf %lf",hierarchy.frame.origin.x,hierarchy.frame.origin.y,hierarchy.frame.size.height,hierarchy.frame.size.width);
//    
//    [self.view addSubview:hierarchy];
//    centerOfClosedState = hierarchy.center;
//    
//    UIToolbar *fakeToolbar = [[UIToolbar alloc] initWithFrame:self.view.frame]; // .bounds or .frame? Not really sure!
//    fakeToolbar.autoresizingMask = self.view.autoresizingMask;
//     fakeToolbar.barTintColor = [UIColor grayColor]; // Customize base color to a non-standard one if you wish
//    fakeToolbar.alpha = .4;
//    [self.view insertSubview:fakeToolbar atIndex:0];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)openButtonPressed
{
    
    [self.sideMenuViewController openMenuAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    pointOfLastTouch = [touch locationInView:self.view];
    
    if ([touch.view isEqual: pullTabView]) {
        isSlidingOpenOrClosed = YES;
        
        NSLog(@"Yeah");
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (isSlidingOpenOrClosed == YES) {
        
        UITouch *touch = [[event allTouches] anyObject];
    
        CGPoint touchLocation = [touch locationInView:self.view];
    
        newLocation = touchLocation.y - pointOfLastTouch.y ;
        newLocation = newLocation - (pullTabView.center.y - 22);
        NSLog(@"%f",newLocation);
        
        if (newLocation < 22 && newLocation > -44) {
            
            hierarchy.frame = CGRectMake(hierarchy.frame.origin.x,newLocation, hierarchy.frame.size.width, hierarchy.frame.size.height);
            
        }
        //NSLog(@"%lf %lf",touchLocation.x,touchLocation.y);
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (isSlidingOpenOrClosed) {
        isSlidingOpenOrClosed = NO;
        if (newLocation > -10) {
            
            NSLog(@"All set");
            CGRect blah = [[UIScreen mainScreen] bounds];
            CGFloat center = blah.size.height / 2;
            CGPoint point = CGPointMake(hierarchy.center.x, center + 44);
            hierarchy.center = point;
        } else {
        
            hierarchy.center = centerOfClosedState;
        }
       // NSLog(@"%f",hierarchy.);
        
    }
}
@end
