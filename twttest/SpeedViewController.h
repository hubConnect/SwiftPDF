//
//  SpeedViewController.h
//  twttest
//
//  Created by Jon Kotowski on 3/29/14.
//  Copyright (c) 2014 Jon Kotowski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainSpeedViewController.h"
#import "HorizontalPickerView/HorizontalPickerView.h"
#import "FXBlurView.h"

@protocol SpeedViewControllerDelegate <NSObject>
- (void) hideSpeedViewController:(UIViewController *) controller;

@end

@interface SpeedViewController : MainSpeedViewController
<HPickerViewDataSource,HPickerViewDelegate>

@property (strong, nonatomic) IBOutlet UISlider *PickerSpeed;
@property (strong, nonatomic) IBOutlet UILabel *WMPlabel;
@property (strong, nonatomic) IBOutlet UILabel *SpeedBborderImage;
- (IBAction)SliderValueChanged:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *SpeedView;
@property (weak, nonatomic) IBOutlet UILabel *SpeedViewContentLabel;
@property (strong, nonatomic) NSString * stringToRead;
@property (strong, nonatomic) IBOutlet UIButton *DismissController;
@property (strong, nonatomic) IBOutlet UIButton *PlayButton;
- (IBAction)DismissControllerAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *PlayButtonController;
- (IBAction)PlayButtonAction:(id)sender;
- (IBAction)Pause:(id)sender;
@property CGFloat pauseBetweenWords;
@end
