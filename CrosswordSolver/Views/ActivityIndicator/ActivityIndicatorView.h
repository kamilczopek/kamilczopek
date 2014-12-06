//
//  BTEActivityIndicatorView.h
//  BT One Phone
//
//  Created by Lukasz Zwolinski on 4/9/14.
//
//  Application's activity indicator
//

#import <UIKit/UIKit.h>

@interface ActivityIndicatorView : UIView

/**
 * Creates an activity indicator dispalyed as subview of a provided view
 * @param view parent view for the indicator
 * @param title title to display
 * @return BTEActivityIndicator instance
 */
- (id)initWithView:(UIView *)view andTitle:(NSString *)title;

/**
 * Creates an activity indicator dispalyed as subview of a provided window
 * @param window parent window for the indicator
 * @param title title to display
 * @return BTEActivityIndicator instance
 */
- (id)initWithWindow:(UIWindow *)window andTitle:(NSString *)title;

/**
 * Shows the indicator
 */
- (void)show;

/**
 * Hides the indicator
 */
- (void)hide;

@end
