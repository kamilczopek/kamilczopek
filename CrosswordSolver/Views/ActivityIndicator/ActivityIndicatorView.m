//
//  BTEActivityIndicatorView.m
//  BT One Phone
//
//  Created by Lukasz Zwolinski on 4/9/14.
//
//

#import "ActivityIndicatorView.h"

@interface ActivityIndicatorView()

@property (copy, nonatomic) NSString *title;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;

@end

@implementation ActivityIndicatorView

- (id)initWithView:(UIView *)view andTitle:(NSString *)title
{
    self = [super initWithFrame:view.frame];
    if (self) {
        self.title = title;
        [self setupViewWithFrame:view.frame];
        [view addSubview:self];
    }
    return self;
}

- (id)initWithWindow:(UIWindow *)window andTitle:(NSString *)title
{
    self = [super initWithFrame:window.frame];
    if (self) {
        self.title = title;
        [self setupViewWithFrame:window.frame];
        [window addSubview:self];
    }
    return self;
}

- (void)setupViewWithFrame:(CGRect)frame
{
    self.hidden = YES;
    
    //setup dark cover UI
    CGPoint point = CGPointMake(frame.size.width * 1/6, frame.size.height * 2/5);
    CGSize size = CGSizeMake(frame.size.width * 2/3, frame.size.height * 1/5);
    CGRect darkCoverFrame = CGRectMake(point.x, point.y, size.width, size.height);
    UIView *darkCover = [[UIView alloc] initWithFrame:darkCoverFrame];
    darkCover.backgroundColor = [UIColor blackColor];
    darkCover.alpha = 0.7;
    darkCover.layer.cornerRadius = 5;
    darkCover.layer.masksToBounds = YES;
    [self addSubview:darkCover];
    
    //setup UILabel with title
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.text = self.title;
    titleLabel.numberOfLines = 2;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    [titleLabel sizeToFit];
    point = CGPointMake(darkCoverFrame.origin.x + darkCoverFrame.size.width / 2 - titleLabel.frame.size.width / 2, darkCoverFrame.origin.y + darkCoverFrame.size.height * 1/6);
    size = titleLabel.frame.size;
    CGRect labelFrame = CGRectMake(point.x, point.y, size.width, size.height);
    titleLabel.frame = labelFrame;
    [self addSubview:titleLabel];
    
    //setup Activity Indicator
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    point = CGPointMake(darkCoverFrame.origin.x + darkCoverFrame.size.width / 2, darkCoverFrame.origin.y + darkCoverFrame.size.height * 3/5);
    self.activityIndicatorView.center = point;
    [self addSubview:self.activityIndicatorView];
}

- (void)show
{
    self.hidden = NO;
    [self.activityIndicatorView startAnimating];
}

- (void)hide
{
    self.hidden = YES;
    [self.activityIndicatorView stopAnimating];
}

@end
