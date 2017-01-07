
#import <UIKit/UIKit.h>

@class  JSAnalogueStick;

@protocol JSAnalogueStickDelegate <NSObject>

@optional
- (void)analogueStickDidChangeValue:(JSAnalogueStick *)analogueStick;

@end

@interface JSAnalogueStick : UIView

@property (nonatomic, readonly) CGFloat xValue;
@property (nonatomic, readonly) CGFloat yValue;

@property (nonatomic, assign) BOOL invertedYAxis;

@property (nonatomic, assign) IBOutlet id <JSAnalogueStickDelegate> delegate;

@property (nonatomic, readonly) UIImageView *backgroundImageView;
@property (nonatomic, readonly) UIImageView *handleImageView;

@end
