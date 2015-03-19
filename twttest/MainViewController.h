//
//  TWTMainViewController.h
//  TWTSideMenuViewController-Sample
//
//  Created by Josh Johnson on 8/14/13.
//  Copyright (c) 2013 Two Toasters. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController
 <UIPageViewControllerDataSource,UIPageViewControllerDelegate>

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
+ (UIImage *)applyBlurOnImage: (UIImage *)imageToBlur withRadius: (CGFloat)blurRadius;

@property (strong, nonatomic) UIViewController *pageViewController;

@end
