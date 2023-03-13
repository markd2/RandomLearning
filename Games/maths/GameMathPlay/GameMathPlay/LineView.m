#import "LineView.h"

#import "cheesy-math-lib.h"

static const CGFloat kLineWidth = 3.0;

@interface LineView ()

@property (assign, nonatomic) CGPoint line1start;
@property (assign, nonatomic) CGPoint line1end;

@property (assign, nonatomic) CGPoint line2start;
@property (assign, nonatomic) CGPoint line2end;

@property (assign, nonatomic) CGPoint *draggingPoint;

@end // extension


@implementation LineView

- (BOOL) isFlipped { return YES; }


- (void) awakeFromNib {
    [super awakeFromNib];

    self.line1start = CGPointMake(10, 10);
    self.line1end = CGPointMake(250, 250);

    self.line2start = CGPointMake(250, 10);
    self.line2end = CGPointMake(10, 250);

} // awakeFromNib


static inline CGRect rectAroundPoint(CGPoint point, CGFloat radius) {
    CGRect blah = (CGRect) { point.x - radius / 2.0,
                             point.y - radius / 2.0, radius, radius };
    return blah;

} // rectAroundPoint


- (void) drawLineFrom: (CGPoint) start  to: (CGPoint) end {
    const CGFloat radius = 10.0;

    // draw the projection of the lines out to 'infinity'

    NSBezierPath *dashedBez = NSBezierPath.new;
    CGFloat dasher[] = { 2.0, 2.0 };
    [dashedBez setLineDash: dasher  count: sizeof(dasher) / sizeof(*dasher)  phase: 0.0];
    
    CheesySlopeInterceptLine line = slopeInterceptFromPoints(*((CheesyPoint*)&start),
                                                             *((CheesyPoint*)&end));
    double farLeftX = CGRectGetMinX(self.bounds) - 100;
    double farLeftY = evalYForSlopeIntercept(line, farLeftX);

    double farRightX = CGRectGetMaxX(self.bounds) + 100;
    double farRightY = evalYForSlopeIntercept(line, farRightX);

    [NSColor.grayColor set];
    CGPoint farLeft = (CGPoint) { farLeftX, farLeftY };
    CGPoint farRight = (CGPoint) { farRightX, farRightY };
    [dashedBez moveToPoint: farLeft];
    [dashedBez lineToPoint: farRight];
    [dashedBez stroke];

    NSBezierPath *bez = NSBezierPath.new;
    bez.lineWidth = kLineWidth;
    bez.lineCapStyle = NSLineCapStyleRound;

    [bez moveToPoint: start];
    [bez lineToPoint: end];

    [NSColor.purpleColor set];
    [bez stroke];

    CGRect control1 = rectAroundPoint(start, radius);
    CGRect control2 = rectAroundPoint(end, radius);

    [NSColor.orangeColor set];
    bez = [NSBezierPath bezierPathWithOvalInRect: control1];
    [bez stroke];
    bez = [NSBezierPath bezierPathWithOvalInRect: control2];
    [bez stroke];

    CheesyPoint midpoint = cheesyMidpoint(*((CheesyPoint*)&start), *((CheesyPoint*)&end));

    CGRect midpointRect = rectAroundPoint(*((CGPoint*)&midpoint), radius / 2);
    [NSColor.grayColor set];
    bez = [NSBezierPath bezierPathWithOvalInRect: midpointRect];
    [bez stroke];

} // drawLineFrom


- (BOOL) orthogonal_p {
    if (self.line1start.x == self.line1end.x) {
        // line 1 is vertical
        NSLog(@"line 1 vertical");
        return NO;

    } else if (self.line2start.x == self.line2end.x) {
        // line 2 is vertical
        NSLog(@"line 2 vertical");
        return NO;

    } else {
        CGFloat slope1 = slopeBetweenPoints((double*)&_line1start,
                                            (double*)&_line1end);
        CGFloat slope2 = slopeBetweenPoints((double*)&_line2start, 
                                            (double*)&_line2end);

        const CGFloat epsilon = 0.02;
        if (areSlopesOrthogonal(slope1, slope2, epsilon)) {
            NSLog(@"YAY");
            return YES;
        }
        return NO;
    }
} // orthogonal_p


- (CheesyLineIntersectionType) lineRelationship {
    CheesyPoint line1start = *((CheesyPoint*) &_line1start);
    CheesyPoint line1end = *((CheesyPoint*) &_line1end);

    CheesyPoint line2start = *((CheesyPoint*) &_line2start);
    CheesyPoint line2end = *((CheesyPoint*) &_line2end);

    CheesySlopeInterceptLine line1 = 
        slopeInterceptFromPoints(line1start, line1end);
    CheesySlopeInterceptLine line2 = 
        slopeInterceptFromPoints(line2start, line2end);

    double epsilon = 0.005; // dialed in until it felt right
    CheesyLineIntersectionType relationship = intersectionTypeOf(line1, line2,
                                                                 epsilon);

    if (relationship == kLineParallel) {
        // hard to get overlap with human moosing, so factor in line width
        double y1 = evalYForSlopeIntercept(line1, 0);
        double y2 = evalYForSlopeIntercept(line2, 0);
        if (fabs(y1 - y2) < kLineWidth / 2.0) {
            relationship = kLineOverlaps;
        }
    }

    return relationship;
} // lineRelationship


- (void)drawRect: (NSRect) dirtyRect {
    [super drawRect: dirtyRect];

    [NSColor.whiteColor set];
    NSRectFill(self.bounds);

    [self drawLineFrom: self.line1start
                    to: self.line1end];
    [self drawLineFrom: self.line2start
                    to: self.line2end];

    CheesyPointSlopeLine ps1 = pointSlopeFromPoints(*((CheesyPoint*)&_line1start),
                                                    *((CheesyPoint*)&_line1end));
    CheesyPointSlopeLine ps2 = pointSlopeFromPoints(*((CheesyPoint*)&_line2start),
                                                    *((CheesyPoint*)&_line2end));

    [NSColor.blackColor set];
    NSFrameRect(self.bounds);

    if ([self orthogonal_p]) {
        [@"Yay Orthogonal" drawAtPoint: CGPointMake(5, 20)  withAttributes: @{}];
    }

    NSString *intersect;

    CheesyLineIntersectionType relationship = [self lineRelationship];
    switch (relationship) {
    case kLineIntersects: {
        intersect = @"intersect";
        CheesyPoint intersectionCheesyPoint = intersectionPointOfLines(ps1, ps2);
        CGRect intersectionRect = rectAroundPoint(*((CGPoint*)&intersectionCheesyPoint), 6);
        [NSColor.greenColor set];
        NSBezierPath *bez = [NSBezierPath bezierPathWithOvalInRect: intersectionRect];
        [bez fill];

        break;
    }
    case kLineOverlaps:
        intersect = @"overlap";
        break;
    case kLineParallel: {
        intersect = @"parallel";
        break;
    }
    default:
        intersect = @"???";
        break;
    }
    [intersect drawAtPoint: CGPointMake(5, 30)  withAttributes: @{}];

} // drawRect


static inline bool hitsRectWithPointAnchoredAt(CGPoint click, 
                                               CGPoint point, CGFloat radius) {
    CGRect rect = rectAroundPoint(point, radius);
    return CGRectContainsPoint(rect, click);
} // hitRectWithPoint


- (void) mouseDown: (NSEvent *) event {
    NSPoint click = [self convertPoint: [event locationInWindow] fromView: nil];
    const CGFloat radius = 12.0;

    CGPoint *points[] = { &_line1start, &_line1end, &_line2start, &_line2end };

    self.draggingPoint = NULL;

    for (int i = 0; i < sizeof(points) / sizeof(*points); i++) {
        if (hitsRectWithPointAnchoredAt(click, *points[i], radius)) {
            self.draggingPoint = points[i];
            break;
        }
    }

} // mooseDown


- (void) mouseDragged: (NSEvent *) event {
    if (self.draggingPoint == NULL) return;

    NSPoint point = [self convertPoint: [event locationInWindow] fromView: nil];
    *self.draggingPoint = point;

    [self setNeedsDisplay: YES];

} // mooseDragged


@end // LineView


