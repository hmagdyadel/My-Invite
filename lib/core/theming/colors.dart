import 'package:flutter/material.dart';

// Base colors
const Color bgColor = Color(0xff33364E);
const Color bgColorOverlay = Color(0xff252A41);
const Color navBarBackground = Color(0xff181c2f);
const Color primaryColor = Color(0xff2175F1);
const Color secondaryColor = Color(0xff6D42F4);
const Color whiteSmokeColor = Color(0xffF5F5F5);
const Color greenColor = Color(0xff35818f);
const Color errorColor = Color(0xFFB00020);
const Color whiteTextColor = Color(0xFFFFFFFF);

// Improved gradient definitions with explicit parameters
const LinearGradient gradient1 = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [primaryColor, secondaryColor],
  stops: [0.0, 1.0],
);

const LinearGradient containerGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xff1AD3A4), Color(0xff3082D9)],
  stops: [0.0, 1.0],
);

const LinearGradient gradient3 = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xffEF745F), Color(0xffF7BB6A)],
  stops: [0.0, 1.0],
);

const LinearGradient gradient4 = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xffFF6AB3), Color(0xffFC2DAC)],
  stops: [0.0, 1.0],
);