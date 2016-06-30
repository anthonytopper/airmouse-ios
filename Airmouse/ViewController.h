//
//  ViewController.h
//  Airmouse
//
//  Created by anthony on 1/15/16.
//  Copyright © 2016 Topper Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BTManager.h"

typedef CF_ENUM(uint32_t, CGMouseButton) {
    kCGMouseButtonLeft = 0,
    kCGMouseButtonRight = 1,
    kCGMouseButtonCenter = 2
};

#define NX_NULLEVENT		0	/* internal use */

/* mouse events */

#define NX_LMOUSEDOWN		1	/* left mouse-down event */
#define NX_LMOUSEUP		2	/* left mouse-up event */
#define NX_RMOUSEDOWN		3	/* right mouse-down event */
#define NX_RMOUSEUP		4	/* right mouse-up event */
#define NX_MOUSEMOVED		5	/* mouse-moved event */
#define NX_LMOUSEDRAGGED	6	/* left mouse-dragged event */
#define NX_RMOUSEDRAGGED	7	/* right mouse-dragged event */
#define NX_MOUSEENTERED		8	/* mouse-entered event */
#define NX_MOUSEEXITED		9	/* mouse-exited event */

/* other mouse events
 *
 * event.data.mouse.buttonNumber should contain the
 * button number (2-31) changing state.
 */
#define NX_OMOUSEDOWN		25	/* other mouse-down event */
#define NX_OMOUSEUP		26	/* other mouse-up event */
#define NX_OMOUSEDRAGGED	27	/* other mouse-dragged event */

/* keyboard events */

#define NX_KEYDOWN		10	/* key-down event */
#define NX_KEYUP		11	/* key-up event */
#define NX_FLAGSCHANGED		12	/* flags-changed event */

/* composite events */

#define NX_KITDEFINED		13	/* application-kit-defined event */
#define NX_SYSDEFINED		14	/* system-defined event */
#define NX_APPDEFINED		15	/* application-defined event */
/* There are additional DPS client defined events past this point. */

/* Scroll wheel events */

#define NX_SCROLLWHEELMOVED	22

/* Zoom events */
#define NX_ZOOM             28


typedef CF_ENUM(uint32_t, CGEventType) {
    /* The null event. */
    kCGEventNull = NX_NULLEVENT,
    
    /* Mouse events. */
    kCGEventLeftMouseDown = NX_LMOUSEDOWN,
    kCGEventLeftMouseUp = NX_LMOUSEUP,
    kCGEventRightMouseDown = NX_RMOUSEDOWN,
    kCGEventRightMouseUp = NX_RMOUSEUP,
    kCGEventMouseMoved = NX_MOUSEMOVED,
    kCGEventLeftMouseDragged = NX_LMOUSEDRAGGED,
    kCGEventRightMouseDragged = NX_RMOUSEDRAGGED,
    
    /* Keyboard events. */
    kCGEventKeyDown = NX_KEYDOWN,
    kCGEventKeyUp = NX_KEYUP,
    kCGEventFlagsChanged = NX_FLAGSCHANGED,
    
    /* Specialized control devices. */
    kCGEventScrollWheel = NX_SCROLLWHEELMOVED,
    kCGEventOtherMouseDown = NX_OMOUSEDOWN,
    kCGEventOtherMouseUp = NX_OMOUSEUP,
    kCGEventOtherMouseDragged = NX_OMOUSEDRAGGED,
    
    /* Out of band event types. These are delivered to the event tap callback
     to notify it of unusual conditions that disable the event tap. */
    kCGEventTapDisabledByTimeout = 0xFFFFFFFE,
    kCGEventTapDisabledByUserInput = 0xFFFFFFFF
};

@interface ViewController : UIViewController<MCAdvertiserAssistantDelegate> {
    BOOL calibrateActionON;
    BOOL releaseActionON;
    int calCount;
    BOOL prev;
    int click;
    int action;
}

- (IBAction)calibrateAction:(id)sender;
- (IBAction)rightClick:(id)sender;
- (IBAction)leftClick:(id)sender;
- (IBAction)leftDown:(id)sender;
- (IBAction)rightDown:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *xLabel;
@property (weak, nonatomic) IBOutlet UILabel *yLabel;
@property (weak, nonatomic) IBOutlet UILabel *zLabel;
@property (nonatomic,retain) CMMotionManager *motionManager;
@property (nonatomic,retain) BTManager *bluetooth;
@end

