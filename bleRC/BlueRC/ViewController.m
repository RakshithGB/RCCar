
#import "ViewController.h"
#import "AppDelegate.h"
#import "DGActivityIndicatorView.h"
#import "UICountingLabel.h"
#import <TOMSMorphingLabel/TOMSMorphingLabel.h> 

@interface ViewController ()

@end


@implementation ViewController{    
}

@synthesize ble,pwmLabel,pwm,rssiLabel,resetButton,activityIndicatorView,con,changeParameter;

int count = 0;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.analogStick.delegate = self;
    self.analogueStick.delegate = self;
    ble = [[BLE alloc]init];
    [ble controlSetup];
    ble.delegate = self;
   // con.text = @"Connect";
    [self.connectButton setTitle:@"       " forState:UIControlStateNormal];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.myViewController = self;    
    [self.connectButton addTarget:self action:@selector(scanForPeripherals:) forControlEvents:UIControlEventTouchUpInside];
    [self refresh];
    [self updateAnalogueLabel];
}

- (void)refresh{
    activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeBallScaleRippleMultiple tintColor:[UIColor whiteColor] size:30.0f];
    activityIndicatorView.frame = CGRectMake(448.0f, 284.0f, 0.0f, 0.0f);
    [self.view addSubview:activityIndicatorView];
}

- (void)refresh2{
    activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeThreeDots tintColor:[UIColor whiteColor] size:30.0f];
    activityIndicatorView.frame = CGRectMake(443.0f, 286.0f, 0.0f, 0.0f);
    [self.view addSubview:activityIndicatorView];

}

- (void)removing{
    [self.activityIndicatorView removeFromSuperview];
    activityIndicatorView = NULL;
}


- (BOOL)shouldAutorotate{
    return YES;
}
#if __IPHONE_OS_VERSION_MAX_ALLOWED < 90000
- (NSUInteger)supportedInterfaceOrientations
#else
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
#endif
{
    return UIInterfaceOrientationMaskLandscapeLeft;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationLandscapeLeft;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)updateAnalogueLabel
{
	[self.analogTextLabel setText:[NSString stringWithFormat:@"Analog 1: %.1f , %.1f, Analog 2: %.1f, %.1f", self.analogStick.xValue, self.analogStick.yValue, self.analogueStick.xValue, self.analogueStick.yValue]];
}

- (void)updateSpeed{
    int scalingFactor = pwm.value*5;
    int scaledval = fabsf(floorf((float)self.analogueStick.yValue*(109-scalingFactor)));
    int speedpwm = 146+scaledval+scalingFactor;
    float speed = (speedpwm*0.3529)*(3.1415/30)*4;
    float speedM = speed/100;
    float speedKM = speedM*(18/5);
    if (count == 1)
    {
          [self.analogTextLabel setText:[NSString stringWithFormat:@"              Speed: %.2f m/s", speedM]];
    }
    else if (count == 2)
    {
          [self.analogTextLabel setText:[NSString stringWithFormat:@"              Speed: %.2f km/hr", speedKM]];
    }
    else
    {
     [self.analogTextLabel setText:[NSString stringWithFormat:@"              Speed: %.2f cm/s", speed]];
    }
    
}

- (IBAction)stepperAction:(id)sender
{
    if([ble isConnected])
    {
        pwm.maximumValue = 22;
        int pwmScale = pwm.value*5;
        if (146+pwmScale > 255)
        {
            pwmScale = pwmScale - 1;
        }
        [pwmLabel countFromCurrentValueTo:(146+pwmScale) withDuration:0.2];
        UInt8 buf[2] = {0x09, 0x00};
        buf[1] = pwmScale;
        NSData *d = [[NSData alloc]initWithBytes:buf length:2];
        [ble write:d];
    }
}

- (IBAction)resetAction:(id)sender
{
    pwm.value = 0;
    if([ble isConnected])
    {
        int pwmScale = pwm.value*0;
        [pwmLabel countFromCurrentValueTo:146 withDuration:0.5];
        UInt8 buf[2] = {0x0A, 0x00};
        buf[1] = pwmScale;
        NSData *d = [[NSData alloc]initWithBytes:buf length:2];
        [ble write:d];
    }
}

- (IBAction)changingSpeedVal:(id)sender
{
    if([ble isConnected])
    {
        if ( count > 2 )
        {
            count = 0;
            [self updateSpeed];
        }
        else
        {
        count = count + 1;
        [self updateSpeed];
        }
    }
    else{
        [self updateSpeed];
        count = 0;
    }
}

-(void)processAnalogControls{
    if([ble isConnected])
    {
        int pwmScale2 = pwm.value*5;
        int scaledY1val = fabsf(floorf((float)self.analogueStick.yValue*(109-pwmScale2)));
        int scaledXval = fabsf(floorf((float)self.analogStick.xValue*(-30))+30);
        if(self.analogueStick.yValue >= 0 && self.analogStick.xValue <= 0 )
        {//forward right
            if (pwmScale2+146<255){
                [self forwardRight:scaledY1val:scaledXval];}
            else
            {
                [self forwardRight:0:scaledXval];
            }
        }
        else if (self.analogueStick.yValue >= 0 && self.analogStick.xValue >= 0)
        {//forward left
            if (pwmScale2+146<255){
                [self forwardLeft:scaledY1val:scaledXval];}
            else
            {
                [self forwardLeft:0:scaledXval];
            }
        }
        else if(self.analogueStick.yValue <= 0 && self.analogStick.xValue <= 0)
        {//backward right
            if (pwmScale2+146<255){
                [self backwardRight:scaledY1val:scaledXval];}
            else
            {
                [self backwardRight:0:scaledXval];
            }
        }
        else if(self.analogueStick.yValue <= 0 && self.analogStick.xValue >= 0)
        {//backward right
            if (pwmScale2+146<255){
                [self backwardLeft:scaledY1val:scaledXval];}
            else
            {
                [self backwardLeft:0:scaledXval];
            }
        }
    }
}

#pragma mark - JSAnalogueStickDelegate

- (void)analogueStickDidChangeValue:(JSAnalogueStick *)analogueStick
{
    if([ble isConnected])
    {
        [self updateSpeed];
        [self processAnalogControls];
    }
    else
    {
        [self updateAnalogueLabel];
        [self processAnalogControls];
    }
}

- (void)forward: (int)scaledY1val{
     UInt8 buf[2] = {0x01, 0x00};
    buf[1] = scaledY1val;
    NSData *d = [[NSData alloc]initWithBytes:buf length:2];
    [ble write:d];
}

- (void)backward: (int)scaledY1val {
    UInt8 buf[2] = {0x02, 0x00};
    buf[1] = scaledY1val;
    NSData *d = [[NSData alloc]initWithBytes:buf length:2];
    [ble write:d];
}
- (void)left: (int)scaledXval {
    UInt8 buf[2] = {0x03, 0x00};
    buf[1] = scaledXval;
    NSData *d = [[NSData alloc]initWithBytes:buf length:2];
    [ble write:d];
}

- (void)right: (int)scaledXval{
    UInt8 buf[2] = {0x04, 0x00};
    buf[1] = scaledXval;
    NSData *d = [[NSData alloc]initWithBytes:buf length:2];
    [ble write:d];
}

- (void)forwardRight: (int)scaledY1val :(int)scaledXval{
    UInt8 buf[3] = {0x05, 0x00, 0x00};
    buf[1] = scaledY1val;
    buf[2] = scaledXval;
    NSData *d = [[NSData alloc]initWithBytes:buf length:3];
    [ble write:d];
}

- (void)forwardLeft: (int)scaledY1val :(int)scaledXval{
    UInt8 buf[3] = {0x06, 0x00, 0x00};
    buf[1] = scaledY1val;
    buf[2] = scaledXval;
    NSData *d = [[NSData alloc]initWithBytes:buf length:3];
    [ble write:d];
}

- (void)backwardLeft: (int)scaledY1val :(int)scaledXval{
    UInt8 buf[3] = {0x07, 0x00, 0x00};
    buf[1] = scaledY1val;
    buf[2] = scaledXval;
    NSData *d = [[NSData alloc]initWithBytes:buf length:3];
    [ble write:d];
}

- (void)backwardRight: (int)scaledY1val :(int)scaledXval{
    UInt8 buf[3] = {0x08, 0x00, 0x00};
    buf[1] = scaledY1val;
    buf[2] = scaledXval;
    NSData *d = [[NSData alloc]initWithBytes:buf length:3];
    [ble write:d];
}

NSTimer *rssiTimer;

#pragma mark - BLEDelegate
-(void)bleDidConnect{
    [self updateSpeed];
    changeParameter.enabled = true;
    changeParameter.hidden = false;
    count = 0;
    pwmLabel.format = @"PWM: %d";
    pwmLabel.method = UILabelCountingMethodEaseIn;
    [pwmLabel countFrom:0 to:146 withDuration:0.6];
    activityIndicatorView.hidden = true;
    [activityIndicatorView stopAnimating];
    [con setText:@"Disconnect"];
    [self.connectButton setTitle:@"         " forState:UIControlStateNormal];
    [self.connectButton removeTarget:self action:@selector(scanForPeripherals:) forControlEvents:UIControlEventTouchUpInside];
    [self.connectButton addTarget:self action:@selector(disconnectFromPeripheral) forControlEvents:UIControlEventTouchUpInside];
    [self.connectButton setEnabled:YES];
    rssiTimer = [NSTimer scheduledTimerWithTimeInterval:(float)1.0 target:self selector:@selector(readRSSITimer:) userInfo:nil repeats:YES];
}

-(void)bleDidDisconnect{
    changeParameter.enabled = false;
    changeParameter.hidden = true;
    count = 0;
    [self.analogTextLabel setText:[NSString stringWithFormat:@"Analog 1: %.1f , %.1f, Analog 2: %.1f, %.1f", self.analogStick.xValue, self.analogStick.yValue, self.analogueStick.xValue, self.analogueStick.yValue]];
    pwmLabel.text = @"PWM: ";
    [con setText:@"Connect"];
    [self.connectButton setTitle:@"         " forState:UIControlStateNormal];
    [self.connectButton removeTarget:self action:@selector(disconnectFromPeripheral) forControlEvents:UIControlEventTouchUpInside];
    [self.connectButton addTarget:self action:@selector(scanForPeripherals:) forControlEvents:UIControlEventTouchUpInside];
    self.rssiLabel.text = @"RSSI";
    [self.connectButton setEnabled:YES];
}

-(void)bleDidReceiveData:(unsigned char *)data length:(int)length{
       NSData *d = [NSData dataWithBytes:data length:length];
    NSString *s = [[NSString alloc]initWithData:d encoding:NSUTF8StringEncoding];
    if([s isEqualToString:@"1"]){
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
    }
    
}

-(void)bleDidUpdateRSSI:(NSNumber *)rssi{
    self.rssiLabel.textColor = [ UIColor whiteColor];
    self.rssiLabel.text = [NSString stringWithFormat:@"RSSI: %@",rssi.stringValue];
}

#pragma mark - BLE Actions
-(void)scanForPeripherals:(id)sender{
   [self doThisToConnect];
    //[self test];
}

-(void) test{
    if(ble.CM.state != (CBCentralManagerStatePoweredOn)){
        [NSTimer scheduledTimerWithTimeInterval:(float)0.25 target:self selector:@selector(test) userInfo:nil repeats:NO];
        activityIndicatorView.hidden = false;
        [activityIndicatorView startAnimating];
    }
   activityIndicatorView.hidden = false;
   [activityIndicatorView startAnimating];
    [con setText:@"Searching"];
    [self.connectButton setTitle:@"         " forState:UIControlStateNormal];
    [NSTimer scheduledTimerWithTimeInterval:(float)3.0 target:self selector:@selector(test2) userInfo:nil repeats:NO];
    
}

-(void) test2{
    if (ble.peripherals.count == 0)
    {
        [ble findBLEPeripherals:2];
        activityIndicatorView.hidden = true;
        [activityIndicatorView stopAnimating];
        [con setText:@"Connect"];
        [self.connectButton setTitle:@"         " forState:UIControlStateNormal];
    }
    else{
        if (!(ble.activePeripheral != nil)) {
            [self removing];
            [self refresh2];
            activityIndicatorView.hidden = false;
            [activityIndicatorView startAnimating];
            [ble connectPeripheral:[ble.peripherals objectAtIndex:0]];
            [con setText:@"Connecting"];
            [self.connectButton setTitle:@"         " forState:UIControlStateNormal];
           
        }
    }
}

-(void) doThisToConnect{
    [self removing];
    [self refresh];
    activityIndicatorView.hidden = false;
    [activityIndicatorView startAnimating];
    [con setText:@"Searching"];
    [self.connectButton setTitle:@"         " forState:UIControlStateNormal];
    if(ble.peripherals){
        ble.peripherals = nil;
    }
    [self.connectButton setEnabled:NO];
    [ble findBLEPeripherals:2];
    [NSTimer scheduledTimerWithTimeInterval:(float)2.0 target:self selector:@selector(connectionTimer:) userInfo:nil repeats:NO];
}

-(void) toStartBT{
    ble = [[BLE alloc]init];
    [ble controlSetup];
    ble.delegate = self;
}

-(void)disconnectFromPeripheral{
    activityIndicatorView.hidden = true;
    [activityIndicatorView stopAnimating];
    [self.connectButton setEnabled:NO];
     if(ble.activePeripheral){
         if(ble.activePeripheral.state == CBPeripheralStateConnected) {
              [[ble CM] cancelPeripheralConnection:[ble activePeripheral]];
         }
     }
}

-(void)connectionTimer:(NSTimer*)timer{
    if(ble.peripherals.count > 0){
        [self removing];
        [self refresh2];
        activityIndicatorView.hidden = false;
        [activityIndicatorView startAnimating];
        [con setText:@"Connecting"];
        [self.connectButton setTitle:@"         " forState:UIControlStateNormal];
        [ble connectPeripheral:[ble.peripherals objectAtIndex:0]];
    }else{
        self.connectButton.enabled = YES;
        activityIndicatorView.hidden = true;
        [activityIndicatorView stopAnimating];
        [con setText:@"Connect"];
        [self.connectButton setTitle:@"         " forState:UIControlStateNormal];
    }
}

-(void) readRSSITimer:(NSTimer *)timer
{
    [ble readRSSI];
}

@end
