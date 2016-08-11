//
//  JTTextView.m
//  RichTextEdit
//
//  Created by JobsTorvalds on 16/8/10.
//  Copyright © 2016年 JobsTorvalds. All rights reserved.
//
#define JTRGB(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define SCREEN_Width [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#import "JTTextView.h"
#import "UITextView+Helper.h"

@interface JTTextView ()
{
    UIColor *textColorValue;//默认颜色
    CGFloat fontSize;//默认字体大小
    CGFloat INclineValue;//默认斜体的倾斜程度
    float UnderlineValue;//下划线
    float TextWidth;//加粗字体
    UIViewController *VC;//所在的控制器
    CGRect MyFrame;//初始位置
    UIView *ButtonsView;//初始菜单
    UIView *colorView;//颜色选择区域
    UIView *fontView;//字体选择区域
    UIView *linkView;//添加链接的区域
    UITextField *URLTF;//网址的输入框
    UITextField *PlaceTF;//字体框
    BOOL boolColor;//颜色
    BOOL boolSize;//大小
    BOOL boolLink;//链接页面
    CGFloat KeyBoardConverMaxY; //键盘覆盖屏幕高度
    BOOL ShowModel;//展示状态
    UILabel *PlaceholdLabel;//占位字符的标签
    NSDictionary *LastTypeAttrubute;//加入链接前的文字
    
}
@end

@implementation JTTextView

- (instancetype)initWithFrame:(CGRect)frame textContainer:(NSTextContainer *)textContainer
{
    if (self = [super initWithFrame:frame textContainer:textContainer]) {
        [self initSomeValues];
        [self initDidAction];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self initSomeValues];
        [self initDidAction];
    }
    return self;
}
- (void)initSomeValues{
    self.MplaceString = @"请输入内容!";
    textColorValue = [UIColor blackColor];
    fontSize = 16;
    INclineValue = 0.0;
    UnderlineValue = 0;
    TextWidth = 0.0;
    boolLink = NO;
    boolColor = NO;
    boolSize = NO;
    ShowModel = NO;
    VC = [[UIViewController alloc]init];
    fontView = [[UIView alloc]init];
    colorView = [[UIView alloc]init];
    linkView = [[UIView alloc]init];
    URLTF = [[UITextField alloc]init];
    PlaceTF = [[UITextField alloc]init];
    
}
#warning need some new func
- (void)initDidAction
{
    colorView.hidden = YES;
    fontView.hidden = YES;
    linkView.hidden = YES;
    ButtonsView = [self SetButtonsView];
    self.inputAccessoryView = ButtonsView;
    
    self.layer.cornerRadius = 5.0f;
    self.clipsToBounds = YES;
    [self.typingAttributes setValue:[UIFont systemFontOfSize:fontSize] forKey:NSFontAttributeName];
    [self addPlaceHolder:_MplaceString];
}

- (void)addPlaceHolder:(NSString *)placeStr{
    [PlaceholdLabel removeFromSuperview];
    PlaceholdLabel = [[UILabel alloc]initWithFrame:CGRectMake(4, 8,self.textContainer.size.width - self.textContainer.lineFragmentPadding * 2, 18)];
    PlaceholdLabel.text = placeStr;
    PlaceholdLabel.textColor = JTRGB(0, 0, 25,.22);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChanged) name:UITextViewTextDidChangeNotification object:nil];
    [self addSubview:PlaceholdLabel];
}
- (void)textDidChanged{
    if (![self.text  isEqual: @""]) {
        PlaceholdLabel.hidden = YES;
    }else{
        PlaceholdLabel.hidden = NO;
    }
}




//parm - 初始化键盘顶端功能按钮
- (UIView *)SetButtonsView{
    UIView *accessView = [[UIView alloc]init];
    accessView.frame = CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width ,50);
    accessView.backgroundColor = JTRGB(237, 237, 237,1);
    return [self addBtnToButtonsView:accessView];
    
}
//parm - 给顶端View添加按钮
- (UIView *)addBtnToButtonsView:(UIView *)accessView
{
    CGFloat buttonWidth = accessView.frame.size.width / 8;
    CGFloat buttonHeight = accessView.frame.size.height ;
    CGFloat imageViewX = buttonWidth / 4;
    CGFloat imageViewY = buttonHeight / 3.5;
    CGFloat imageViewWidth = buttonWidth / 1.8;
    CGFloat imageViewHeight = buttonWidth / 1.8;
    CGRect imageFrame = CGRectMake(imageViewX, imageViewY, imageViewWidth, imageViewHeight);
    
    UIButton *ColorButton = [[UIButton alloc]init];
    UIImageView *ColorImageView = [[UIImageView alloc]initWithFrame:imageFrame];
    ColorImageView.image = [UIImage imageNamed:@"70colors"];
    ColorButton.frame = CGRectMake(0, 0, buttonWidth, buttonHeight);
    [ColorButton addTarget:self action:@selector(ColorButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [ColorButton addSubview:ColorImageView];
    [accessView addSubview:ColorButton];
    
    
    UIButton *addImageButton = [[UIButton alloc]init];
    UIImageView *addImageView = [[UIImageView alloc]initWithFrame:imageFrame];
    addImageView.image = [UIImage imageNamed:@"70ima"];
    addImageButton.frame = CGRectMake(buttonWidth, 0, buttonWidth, buttonHeight);
    [addImageButton addTarget:self action:@selector(addImage) forControlEvents:UIControlEventTouchUpInside];
    [addImageButton addSubview:addImageView];
    [accessView addSubview:addImageButton];
    
    UIButton *fontButton = [[UIButton alloc]init];
    UIImageView *fontImageView = [[UIImageView alloc]initWithFrame:imageFrame];
    fontImageView.image = [UIImage imageNamed:@"70font"];
    fontButton.frame = CGRectMake(buttonWidth * 2, 0, buttonWidth, buttonHeight);
    [fontButton addTarget:self action:@selector(fontButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [fontButton addSubview:fontImageView];
    [accessView addSubview:fontButton];
    
    UIButton *boldButton = [[UIButton alloc]init];
    UIImageView *boldImageView = [[UIImageView alloc]initWithFrame:imageFrame];
    boldImageView.image = [UIImage imageNamed:@"70bold"];
    boldButton.frame = CGRectMake(buttonWidth * 3, 0, buttonWidth, buttonHeight);
    [boldButton addTarget:self action:@selector(boldButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [boldButton addSubview:boldImageView];
    [accessView addSubview:boldButton];
    
    UIButton *InclineButton = [[UIButton alloc]init];
    UIImageView *InclineImageView = [[UIImageView alloc]initWithFrame:imageFrame];
    InclineImageView.image = [UIImage imageNamed:@"70clinder"];
    InclineButton.frame = CGRectMake(buttonWidth * 4, 0, buttonWidth, buttonHeight);
    [InclineButton addTarget:self action:@selector(InclineButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [InclineButton addSubview:InclineImageView];
    [accessView addSubview:InclineButton];
    
    UIButton *UnderlineButton = [[UIButton alloc]init];
    UIImageView *UnderlineImageView = [[UIImageView alloc]initWithFrame:imageFrame];
    UnderlineImageView.image = [UIImage imageNamed:@"70Under"];
    UnderlineButton.frame = CGRectMake(buttonWidth * 5, 0, buttonWidth, buttonHeight);
    [UnderlineButton addTarget:self action:@selector(UnderlineButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [UnderlineButton addSubview:UnderlineImageView];
    [accessView addSubview:UnderlineButton];
    
    UIButton *linkButton = [[UIButton alloc]init];
    UIImageView *linkImageView = [[UIImageView alloc]initWithFrame:imageFrame];
    linkImageView.image = [UIImage imageNamed:@"70LinkB"];
    linkButton.frame = CGRectMake(buttonWidth * 6, 0, buttonWidth, buttonHeight);
    [linkButton addTarget:self action:@selector(addlineButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [linkButton addSubview:linkImageView];
    [accessView addSubview:linkButton];
    
    UIButton *tabelButton = [[UIButton alloc]init];
    UIImageView *tabelImageView = [[UIImageView alloc]initWithFrame:imageFrame];
    tabelImageView.image = [UIImage imageNamed:@"70TableB"];
    tabelButton.frame = CGRectMake(buttonWidth * 7, 0, buttonWidth, buttonHeight);
    [tabelButton addTarget:self action:@selector(tabelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [tabelButton addSubview:tabelImageView];
    [accessView addSubview:tabelButton];
    
    return accessView;
}
- (void)ColorButtonClicked:(UIButton *)sender{
    fontView.hidden = YES;
    linkView.hidden = YES;
    if (boolColor == NO) {
        [self addColorVieewToKeyBoard:colorView];
        boolColor = true;
    }
    UIWindow *top = [UIApplication sharedApplication].windows.lastObject;
    [top addSubview:colorView];
    [top bringSubviewToFront:colorView];
    colorView.hidden = colorView.hidden == NO ? YES:NO;
}
- (void)addIamge{
    [self _selectImageWithAlertForGalleryOrCamera:nil];
    colorView.hidden = YES;
    fontView.hidden = YES;
    linkView.hidden = YES;
}
- (void)fontButtonClicked{
    colorView.hidden = YES;
    linkView.hidden = YES;
    if (boolSize == NO) {
        
    }
}


#pragma mark - Second Lists
- (void)addColorVieewToKeyBoard:(UIView *)ColorView{
    ColorView.backgroundColor = JTRGB(240, 240, 240, 1);
    ColorView.frame = CGRectMake(0, KeyBoardConverMaxY + 50, SCREEN_Width,35);
    
}
//添加颜色按钮
- (void)addColorButtons:(UIView *)ColorView
{
    CGFloat buttonWidth = ColorView.frame.size.width / 6;
    CGFloat buttonHeight = (ColorView.frame.size.height - 13)/2;
    
    UIButton *RedButton = [[UIButton alloc]init];
    RedButton.frame = CGRectMake((buttonWidth - buttonHeight) / 2, 0, buttonHeight, buttonHeight);
    RedButton.backgroundColor = [UIColor redColor];
    RedButton.layer.cornerRadius = RedButton.frame.size.width / 2;
    RedButton.clipsToBounds = YES;
    RedButton.layer.borderWidth = 3.0;
    RedButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [RedButton addTarget:self action:@selector(redButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [ColorView addSubview:RedButton];
    
    UIButton *YellowButton = [[UIButton alloc]init];
    YellowButton.frame = CGRectMake((buttonWidth - buttonHeight) / 2 + buttonWidth, 0, buttonHeight, buttonHeight);
    YellowButton.layer.cornerRadius = YellowButton.frame.size.width / 2;
    YellowButton.clipsToBounds = YES;
    YellowButton.backgroundColor = [UIColor yellowColor];
    YellowButton.layer.borderWidth = 3.0;
    YellowButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [YellowButton addTarget:self action:@selector(yellowButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [ColorView addSubview:YellowButton];
    
    
    UIButton *GreenButton = [[UIButton alloc]init];
    GreenButton.frame = CGRectMake((buttonWidth - buttonHeight) / 2 + buttonWidth * 2, 0, buttonHeight, buttonHeight);
    GreenButton.layer.cornerRadius = GreenButton.frame.size.width / 2;
    GreenButton.clipsToBounds = YES;
    GreenButton.backgroundColor = [UIColor greenColor];
    GreenButton.layer.borderWidth = 3.0;
    GreenButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [GreenButton addTarget:self action:@selector(greenButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [ColorView addSubview:GreenButton];
    
    UIButton *BlueButton = [[UIButton alloc]init];
    BlueButton.frame = CGRectMake((buttonWidth - buttonHeight) / 2 + buttonWidth * 3, 0, buttonHeight, buttonHeight);
    BlueButton.layer.cornerRadius = BlueButton.frame.size.width / 2;
    BlueButton.clipsToBounds = YES;
    BlueButton.backgroundColor = [UIColor blueColor];
    BlueButton.layer.borderWidth = 3.0;
    BlueButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [BlueButton addTarget:self action:@selector(blueButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [ColorView addSubview:BlueButton];
    
    
    UIButton *GragButton = [[UIButton alloc]init];
    GragButton.frame = CGRectMake((buttonWidth - buttonHeight) / 2 + buttonWidth * 4, 0, buttonHeight, buttonHeight);
    GragButton.layer.cornerRadius = GragButton.frame.size.width / 2;
    GragButton.clipsToBounds = YES;
    GragButton.backgroundColor = [UIColor grayColor];
    GragButton.layer.borderWidth = 3.0;
    GragButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [GragButton addTarget:self action:@selector(grayButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [ColorView addSubview:GragButton];
    
    UIButton *BlackButton = [[UIButton alloc]init];
    BlackButton.frame = CGRectMake((buttonWidth - buttonHeight) / 2 + buttonWidth * 5, 0, buttonHeight, buttonHeight);
    BlackButton.layer.cornerRadius = BlackButton.frame.size.width / 2;
    BlackButton.clipsToBounds = YES;
    BlackButton.backgroundColor = [UIColor blackColor];
    BlackButton.layer.borderWidth = 3.0;
    BlackButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [BlackButton addTarget:self action:@selector(blackButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [ColorView addSubview:BlackButton];
    
    
    UIButton *PinkButton = [[UIButton alloc]init];
    PinkButton.frame = CGRectMake((buttonWidth - buttonHeight) / 2 + buttonWidth * 3, buttonHeight + 8, buttonHeight, buttonHeight);
    PinkButton.backgroundColor = JTRGB(253, 130, 264, 1);
    PinkButton.layer.cornerRadius = RedButton.frame.size.width / 2;
    PinkButton.clipsToBounds = YES;
    PinkButton.layer.borderWidth = 3.0;
    PinkButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [PinkButton addTarget:self action:@selector(pinkButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [ColorView addSubview:PinkButton];
    
    UIButton *BrownButton = [[UIButton alloc]init];
    BrownButton.frame = CGRectMake((buttonWidth - buttonHeight) / 2, buttonHeight + 8, buttonHeight, buttonHeight);
    BrownButton.backgroundColor = [UIColor brownColor];
    BrownButton.layer.cornerRadius = RedButton.frame.size.width / 2;
    BrownButton.clipsToBounds = YES;
    BrownButton.layer.borderWidth = 3.0;
    BrownButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [BrownButton addTarget:self action:@selector(brownButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [ColorView addSubview:BrownButton];
    
    UIButton *OrangiButton = [[UIButton alloc]init];
    OrangiButton.frame = CGRectMake((buttonWidth - buttonHeight) / 2 + buttonWidth, buttonHeight + 8, buttonHeight, buttonHeight);
    OrangiButton.backgroundColor = JTRGB(250, 193, 90, 1);
    OrangiButton.layer.cornerRadius = RedButton.frame.size.width / 2;
    OrangiButton.clipsToBounds = YES;
    OrangiButton.layer.borderWidth = 3.0;
    OrangiButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [OrangiButton addTarget:self action:@selector(orangiButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [ColorView addSubview:OrangiButton];
    
    UIButton *PupolButton = [[UIButton alloc]init];
    PupolButton.frame = CGRectMake((buttonWidth - buttonHeight) / 2 + buttonWidth * 2, buttonHeight + 8, buttonHeight, buttonHeight);
    PupolButton.backgroundColor = JTRGB(137, 255, 245, 1);
    PupolButton.layer.cornerRadius = RedButton.frame.size.width / 2;
    PupolButton.clipsToBounds = YES;
    PupolButton.layer.borderWidth = 3.0;
    PupolButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [PupolButton addTarget:self action:@selector(purpolButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [ColorView addSubview:PupolButton];
    
    UIButton *SkyBUtton = [[UIButton alloc]init];
    SkyBUtton.frame = CGRectMake((buttonWidth - buttonHeight) / 2 + buttonWidth * 4, buttonHeight + 8, buttonHeight, buttonHeight);
    SkyBUtton.backgroundColor = JTRGB(179, 98, 255, 1);
    SkyBUtton.layer.cornerRadius = RedButton.frame.size.width / 2;
    SkyBUtton.clipsToBounds = YES;
    SkyBUtton.layer.borderWidth = 3.0;
    SkyBUtton.layer.borderColor = [UIColor whiteColor].CGColor;
    [SkyBUtton addTarget:self action:@selector(skyButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [ColorView addSubview:SkyBUtton];
    
    UIButton *LightGray = [[UIButton alloc]init];
    LightGray.frame = CGRectMake((buttonWidth - buttonHeight) / 2 + buttonWidth * 5, buttonHeight + 8, buttonHeight, buttonHeight);
    LightGray.backgroundColor = JTRGB(197, 197, 197, 1);
    LightGray.layer.cornerRadius = RedButton.frame.size.width / 2;
    LightGray.clipsToBounds = YES;
    LightGray.layer.borderWidth = 3.0;
    LightGray.layer.borderColor = [UIColor whiteColor].CGColor;
    [LightGray addTarget:self action:@selector(lightGrayButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [ColorView addSubview:LightGray];
}
- (void)redButtonClick{
    [self changeValueForColor:[UIColor redColor] selectLength:self.selectedRange.length];
    colorView.hidden = YES;
}
- (void)yellowButtonClick{
    [self changeValueForColor:[UIColor yellowColor] selectLength:self.selectedRange.length];
    colorView.hidden = YES;
}
- (void)greenButtonClick{
    [self changeValueForColor:[UIColor greenColor] selectLength:self.selectedRange.length];
    colorView.hidden = YES;
}
- (void)blueButtonClick{
    [self changeValueForColor:[UIColor blueColor] selectLength:self.selectedRange.length];
    colorView.hidden = YES;
}
- (void)grayButtonClick{
    [self changeValueForColor:[UIColor grayColor] selectLength:self.selectedRange.length];
    colorView.hidden = YES;
}
- (void)blackButtonClick{
    [self changeValueForColor:[UIColor blackColor] selectLength:self.selectedRange.length];
    colorView.hidden = YES;
}
- (void)brownButtonClick{
    [self changeValueForColor:[UIColor brownColor] selectLength:self.selectedRange.length];
    colorView.hidden = YES;
}
- (void)orangiButtonClick{
    [self changeValueForColor:JTRGB(250, 193, 90, 1) selectLength:self.selectedRange.length];
    colorView.hidden = YES;
}
- (void)skyButtonClick{
    [self changeValueForColor:JTRGB(179, 98, 255, 1) selectLength:self.selectedRange.length];
    colorView.hidden = YES;
}
- (void)purpolButtonClick{
    [self changeValueForColor:JTRGB(137, 255, 245, 1) selectLength:self.selectedRange.length];
    colorView.hidden = YES;
}
- (void)pinkButtonClick{
    [self changeValueForColor:JTRGB(253, 130, 264, 1) selectLength:self.selectedRange.length];
    colorView.hidden = YES;
}
- (void)lightGrayButtonClick{
    [self changeValueForColor:[UIColor lightGrayColor] selectLength:self.selectedRange.length];
    colorView.hidden = YES;
}
- (void)changeValueForColor:(UIColor *)color selectLength:(NSUInteger)length{
    if (length == 0) {
        [self.typingAttributes setValue:color forKey:NSForegroundColorAttributeName];
    } else {
        NSMutableAttributedString *mutStr = self.attributedText.mutableCopy;
        NSRange textRange = self.selectedRange;
        [mutStr addAttribute:NSForegroundColorAttributeName value:color range:textRange];
        self.attributedText = (NSAttributedString *)mutStr.copy;
        self.selectedRange = NSMakeRange(textRange.location, textRange.length);
        [self scrollRangeToVisible:NSMakeRange(textRange.location, textRange.length)];
    }
}
//字体大小菜单
- (void)addFontViewToKeyBoard:(UIView *)fontView{
    fontView.backgroundColor = JTRGB(240, 240, 240, 1);
    fontView.frame = CGRectMake(0, KeyBoardConverMaxY + 50, SCREEN_Width, 35);
    
}
- (void)addFontSlider:(UIView *)fontView{
    UISlider *slider = [[UISlider alloc]initWithFrame:CGRectMake(30, 0, fontView.frame.size.width - 60, fontView.frame.size.height)];
    slider.minimumValue = 3;
    slider.maximumValue = 60;
    if (self.selectedRange.length == 0) {
        [slider setThumbImage:[self changeValueForSliderKey:@"14"] forState:UIControlStateNormal];
        slider.value = 14;
    }
    [slider addTarget:self action:@selector(sliderChangeValues:) forControlEvents:UIControlEventTouchUpInside];
    [fontView addSubview:slider];
    UILabel *minLabel = [[UILabel alloc]init];
    minLabel.frame = CGRectMake(0, 0, 30, fontView.frame.size.height);
    minLabel.text = @"3";
    minLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
    minLabel.textColor = [UIColor grayColor];
    minLabel.textAlignment = NSTextAlignmentCenter;
    [fontView addSubview:minLabel];
    UILabel *maxLabel = [[UILabel alloc]init];
    maxLabel.frame = CGRectMake(fontView.frame.size.width - 30, 0, 30, fontView.frame.size.height);
    maxLabel.textAlignment = NSTextAlignmentCenter;
    maxLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
    maxLabel.textColor = [UIColor grayColor];
    maxLabel.text = @"60";
    [fontView addSubview:maxLabel];
}
- (void)sliderChangeValues:(UISlider *)slider{
    CGFloat senderFloat = (CGFloat)[slider value];
    [slider setThumbImage:[self changeValueForSliderKey:[NSString stringWithFormat:@"%f",senderFloat]] forState:UIControlStateNormal];
    
}
- (UIImage *)changeValueForSliderKey:(NSString *)values{
    UIImage *image = [UIImage imageNamed:@"30key"];
    UIGraphicsBeginImageContext(image.size);
    [image drawAtPoint:CGPointZero];
    NSString *string = (NSString *)values;
    [string drawAtPoint:CGPointMake(7.5, 6) withAttributes:nil];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
- (void)SetValueForTextFont:(CGFloat)changeSize selectLength:(NSInteger)length{
    if (length == 0) {
        fontSize = changeSize;
        [self.typingAttributes setValue:[UIFont systemFontOfSize:fontSize] forKey:NSFontAttributeName];
    }else{
        NSMutableAttributedString *mulStr = self.attributedText.mutableCopy;
        NSString *string = (NSString *)mulStr;
        NSRange returnRange = self.selectedRange;
        NSRange TextRange = self.selectedRange;
        NSAttributedString *textss = [mulStr attributedSubstringFromRange:self.selectedRange];
        NSDictionary *dixt = [textss attribute:string atIndex:1 effectiveRange:&TextRange];
        for (NSDictionary *Item in dixt){
            
        }
    }
}


@end
