import 'package:flutter/material.dart';
import 'dart:async';


//? A wrapper class for AnimatedScale to have expanding effect which occurs after `delay` seconds.

class ExpandWithDelay extends StatefulWidget {
	final Widget child;
	final int delay;
	final int duration;
	final double initialScale;
	final Curve curve;


	const ExpandWithDelay({ 
		Key? key,
		required this.child,
		required this.delay,
		required this.duration,
		this.initialScale = 0,
		this.curve = Curves.easeOut,
	}) : super(key: key);

	@override
	_ExpandWithDelayState createState() => _ExpandWithDelayState();
}


class _ExpandWithDelayState extends State<ExpandWithDelay> {
	double _scale = 0;


	@override
	void initState() {
		super.initState();
		_scale = widget.initialScale;

		Future.delayed(Duration(milliseconds: widget.delay), () {
			setState(()=> _scale = 1);
		});
	}


	@override
	Widget build(BuildContext context) {
		return AnimatedScale(
			duration: Duration(milliseconds: widget.duration), 
			scale: _scale,
			curve: widget.curve,
			child: widget.child,
		);
	}
}