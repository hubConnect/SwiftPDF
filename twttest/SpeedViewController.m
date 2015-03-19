//
//  SpeedViewController.m
//  twttest
//
//  Created by Jon Kotowski on 3/29/14.
//  Copyright (c) 2014 Jon Kotowski. All rights reserved.
//

#import "SpeedViewController.h"
#import "PDFActivityViewController.h"
#import "Word.h"
#import "HorizontalPickerView/HorizontalPickerView.h"

#define LANDSCAPEOFFSET 10

@interface SpeedViewController ()

@end

@implementation SpeedViewController
BOOL isPaused = NO;
NSOperationQueue *nsOP;
BOOL isReading = NO;
BOOL cancelNow = NO;
NSNumber *readerSpeed;
CGFloat posOfLabel;
CGFloat redTint;
double pauseAmount;
NSArray *speedList;
HorizontalPickerView *pickerThing;

- (NSInteger)numberOfRowsInPickerView:(HorizontalPickerView *)pickerView
{
    return speedList.count;
}


#pragma mark -  HPickerViewDelegate

- (NSString *)pickerView:(HorizontalPickerView *)pickerView titleForRow:(NSInteger)row
{
    return [[NSString alloc] initWithFormat:@"%@",speedList[row]];
}

- (void)pickerView:(HorizontalPickerView *)pickerView didSelectRow:(NSInteger)row
{
   // self.selectedRowLabel.text = [NSString stringWithFormat:@"%@", @(row)];
    NSLog(@"%@",speedList[row] );
    
    [self setSpeed:speedList[row] ];
    
    [pickerThing removeFromSuperview];
}

- (void) setSpeed: (NSNumber *)  newSpeed {
    readerSpeed = newSpeed;
    self.WMPlabel.text = [[NSString alloc] initWithFormat:@"%@ WPM",readerSpeed];
    pauseAmount = [readerSpeed longLongValue];
    NSLog(@"%lf",pauseAmount);
    double thing = (60 / pauseAmount);
    NSLog(@"%lf",thing);
    pauseAmount = thing;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    NSLog(@"fff  %@",self.stringToRead);
    
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
    
        CGFloat y = 0;
        CGFloat x = 0;
        
        self.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.5, 1.5);
        y = [[UIScreen mainScreen] bounds].size.width / 2;
        y = y - (self.view.frame.size.height / 2);
        
        x = [[UIScreen mainScreen] bounds].size.height  - self.view.frame.size.width;
        x = x / 2;
        
        self.view.frame = CGRectMake(x, y, self.view.frame.size.width, self.view.frame.size.height);
    } else  {
        
        CGFloat x = 0;
        x = [[UIScreen mainScreen] bounds].size.width  - self.view.frame.size.width;
        x = x / 2;
        self.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
        self.view.frame = CGRectMake(x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
        
    }
    
}

-(void)viewDidAppear:(BOOL)animated {
    
    [self.view addSubview: self.SpeedView];
    
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {

    CGFloat y = 0;
    CGFloat x = 0;
    
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
        
        self.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.5, 1.5);
        
        y = [[UIScreen mainScreen] bounds].size.width / 2;
        y = y - (self.view.frame.size.height / 2);
        
        x = [[UIScreen mainScreen] bounds].size.height  - self.view.frame.size.width;
        x = x / 2;
        
    } else {
        
        self.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
        
        y = [[UIScreen mainScreen] bounds].size.height / 2;
        y = y - (self.view.frame.size.height / 2);
        
        x = [[UIScreen mainScreen] bounds].size.width  - self.view.frame.size.width;
        x = x / 2;
        
        NSLog(@"ToPortrait");
    }
    
    pickerThing.frame = CGRectMake(x, ( y - 44), self.view.frame.size.width, 44);
    self.view.frame = CGRectMake(x, y, self.view.frame.size.width, self.view.frame.size.height);
    NSLog(@"SpeedVC Rotating");
    
    [self.parentViewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self.parentViewController.view addSubview:self.view];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"FASTLOAD");
    posOfLabel = self.SpeedViewContentLabel.frame.origin.x;
    
    speedList = @[@50,@100,@150,@200,@250,@300,@350,@400,@450,@500,@550,@600,@650,@700,@750,@800,@850,@900,@950,@1000];
    
    [self setSpeed:@250];
    self.SpeedBborderImage.frame = CGRectMake(0, 0, 1, 1);
    // Do any additional setup after loading the view from its nib.
    //self.SpeedView.layer.masksToBounds = NO;
    
    self.view.layer.cornerRadius = 8; // if you like rounded corners
    self.view.layer.shadowOffset = CGSizeMake(-15, 20);
    self.view.layer.shadowRadius = 5;
    self.view.layer.shadowOpacity = 0.5;
    
    redTint = (225 / 255);
    
    self.SpeedViewContentLabel.text = self.stringToRead;
    self.pauseBetweenWords = 0;
    readerSpeed = @500;
    
    CGFloat y = [[UIScreen mainScreen] bounds].size.height / 2;
    y = y - (self.view.frame.size.height / 2);
    
    self.view.frame = CGRectMake(0, y, self.view.frame.size.width, self.view.frame.size.height);
    
   // svc.view.frame = CGRectMake(100, 100, self.view.frame.size.width, self.view.frame.size.height);
    
    nsOP = [[NSOperationQueue alloc] init];
    
    self.WMPlabel.text = [NSString stringWithFormat:@"%.1f WMP",self.PickerSpeed.value];
    self.PickerSpeed.hidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)DismissControllerAction:(id)sender {
    
    [nsOP cancelAllOperations];
    cancelNow = YES;
    isReading = NO;
    [(PDFActivityViewController *)self.parentViewController removeBlur];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    CGPoint locationPoint = [[touches anyObject] locationInView:self.view];
    CGPoint viewPoint = [self.WMPlabel convertPoint:locationPoint fromView:self.view];
    
    if ([self.WMPlabel pointInside:viewPoint withEvent:event]) {
        
        if (pickerThing == nil) {
            
            CGFloat y = self.view.frame.origin.y - 44;
            pickerThing = [[HorizontalPickerView alloc] initWithFrame:CGRectMake(0, y, self.view.frame.size.width, 44)];
            
            [pickerThing setStyle:HPStyle_iOS7];
            [pickerThing setDataSource:self];
            [pickerThing setDelegate:self];
        }
        
        [self.parentViewController.view addSubview:pickerThing];
    }
}


- (IBAction)PlayButtonAction:(id)sender {
    
    cancelNow = NO;
    
    if (isPaused) {
        
        isPaused = NO;
    } else {
        
        NSLog(@"Starting Reading");
        
        if (!isReading) {
            
            NSLog(@"Started Reading");
            NSArray *arrayOfItems = [ self stringToTokensWithPunctuation:self.stringToRead ];
            NSMutableArray *arrayOfWords = [[NSMutableArray alloc] init];
            
            for (NSString * tmp in arrayOfItems) {
            
                Word *newWord = [[Word alloc] init];
                newWord.theWord = tmp.copy;
                newWord.displayTime = 1;
                [arrayOfWords addObject:newWord];
                NSLog(@"%@",newWord.theWord);
            }
            
            isReading = YES;
            [self DisplayWords:arrayOfWords];
            NSLog(@"Called Display with %@",arrayOfWords);

            
        }
    }
}

- (void) DisplayWords: (NSArray *) words
{
    NSLog(@"Blah");
    
    [nsOP addOperationWithBlock:^{
            
        for (Word *word in words) {
            
            while (isPaused) {
                if (cancelNow) {
                    break;
                }
            }
            NSLog(@"Blah");
            if (cancelNow) {
                NSLog(@"Cancelling");
                cancelNow= NO;
                break;
            }
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
                self.SpeedViewContentLabel.text = [word.theWord stringByTrimmingCharactersInSet:
                                                   [NSCharacterSet whitespaceCharacterSet]];
                
                NSMutableAttributedString *atString = self.SpeedViewContentLabel.attributedText ;
                
                int IndexToColor = 0;
                CGFloat distanceToOffsetLabel = 0;
                NSString *firstHalf = nil;
                NSDictionary *attributes = @{NSFontAttributeName: self.SpeedViewContentLabel.font};

                
                if (word.theWord.length == 2 || word.theWord.length == 3 ) {
                    
                    IndexToColor = 1;
                    firstHalf = [word.theWord substringToIndex:IndexToColor];
                    CGSize firstHalfSize = [firstHalf sizeWithAttributes:attributes];
                    distanceToOffsetLabel = firstHalfSize.width;
                    
                } else if (word.theWord.length > 3 && word.theWord.length < 5) {
                    
                    IndexToColor = 2;
                    
                    firstHalf = [word.theWord substringToIndex:IndexToColor];
                    CGSize firstHalfSize = [firstHalf sizeWithAttributes:attributes];
                    distanceToOffsetLabel = firstHalfSize.width;
                    
                } else if (word.theWord.length > 4) {
                    
                    IndexToColor = word.theWord.length * .4;
                    
                    firstHalf = [word.theWord substringToIndex:IndexToColor];
                    CGSize firstHalfSize = [firstHalf sizeWithAttributes:attributes];
                    distanceToOffsetLabel = firstHalfSize.width;
                }
                CGSize characterOffset;
                if(word.theWord.length > 0) {
                    characterOffset = [[word.theWord substringWithRange:NSMakeRange(IndexToColor, 1)] sizeWithAttributes:attributes];
                }
                CGFloat x = ([UIScreen mainScreen].bounds.size.width * .5) - distanceToOffsetLabel;
                x = x - (characterOffset.width * .5);
                NSLog(@"Coloring %@ at index %lf",word.theWord,x);
                
                self.SpeedViewContentLabel.frame = CGRectMake(x, self.SpeedViewContentLabel.frame.origin.y , self.SpeedViewContentLabel.frame.size.width, self.SpeedViewContentLabel.frame.size.height);                [atString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(IndexToColor, 1)];
                [self.view addSubview:self.SpeedViewContentLabel];

            }];
            
            [NSThread sleepUntilDate: [NSDate dateWithTimeIntervalSinceNow:pauseAmount]];
            
        }
        isReading = NO;
    }];
}

- (NSArray *) stringToWords: (NSString *) words {
    
    NSMutableArray * array = [[NSMutableArray alloc] init];
    CFStringRef string = (__bridge CFStringRef)(words); // Get string from somewhere
    CFLocaleRef locale = CFLocaleCopyCurrent();
    
    CFStringTokenizerRef tokenizer =
    CFStringTokenizerCreate(
                            kCFAllocatorDefault
                            , string
                            , CFRangeMake(0, CFStringGetLength(string))
                            , kCFStringTokenizerUnitWord
                            , locale);
    
    CFStringTokenizerTokenType tokenType = kCFStringTokenizerTokenNone;
    unsigned tokensFound = 0;
    
    while(kCFStringTokenizerTokenNone !=
          (tokenType = CFStringTokenizerAdvanceToNextToken(tokenizer))) {
        CFRange tokenRange = CFStringTokenizerGetCurrentTokenRange(tokenizer);
        CFStringRef tokenValue =
        CFStringCreateWithSubstring(
                                    kCFAllocatorDefault
                                    , string
                                    , tokenRange);
        
        NSString *string = (__bridge NSString *) tokenValue;
        
        [array addObject:string];
        
        // Do something with the token
        CFShow(tokenValue);
        CFRelease(tokenValue);
        ++tokensFound;
    }
    
    // Clean up
    CFRelease(tokenizer);
    CFRelease(locale);
    
    return array;
}

- (NSArray *) stringToTokensWithPunctuation: (NSString *) theString {
    
    NSString *sep = @" \t   \n";
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:sep];
    NSArray *temp=[theString componentsSeparatedByCharactersInSet:set];
    
    return temp;
}

- (IBAction)Pause:(id)sender {
    isPaused = YES;
}


@end
