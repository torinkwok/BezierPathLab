# BezierPathLab

BezierPathLab is a simple example demonstrating some of the features of NSBezierPath.  Various features of NSBezierPath are used to create the different line patterns and cap styles.  NSGraphicsContext and NSAffineTransform are used to rotate the path.  

The buttons, sliders, and color wells are used to set the attributes of the path.  Their actions are sent to a subclass of NSView, BezierView, which manages all the attributes of the bezier path.  This subclass overrides the -drawRect: method to apply the various settings to the path and draw the path to the view.  