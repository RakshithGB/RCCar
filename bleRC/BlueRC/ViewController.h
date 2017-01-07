
#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "JSAnalogueStick.h"
#import "BLE.h"
#import "DGActivityIndicatorView.h"
#import "UICountingLabel.h"
#import <TOMSMorphingLabel/TOMSMorphingLabel.h> 

@interface ViewController : UIViewController<JSAnalogueStickDelegate,BLEDelegate>
@property (weak, nonatomic) IBOutlet TOMSMorphingLabel *analogTextLabel;
@property (weak, nonatomic) IBOutlet JSAnalogueStick *analogStick;
@property (weak, nonatomic) IBOutlet JSAnalogueStick *analogueStick;
- (void)doThisToConnect;
- (void)toStartBT;
- (void)test;
- (void)refresh;
- (void)removing;
@property (weak, nonatomic) IBOutlet UIButton *changeParameter;
@property (weak, nonatomic) IBOutlet UILabel *con;
@property (weak, nonatomic) IBOutlet UIButton *connectButton;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@property (weak, nonatomic) IBOutlet UILabel *rssiLabel;
@property (weak, nonatomic) IBOutlet UICountingLabel *pwmLabel;
@property (weak, nonatomic) IBOutlet UIStepper *pwm;
@property (nonatomic, strong) BLE *ble;
@property (nonatomic, strong) DGActivityIndicatorView *activityIndicatorView;



@end
