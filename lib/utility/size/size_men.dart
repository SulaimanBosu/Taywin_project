class Size {
  double sizeman(double sizeheight) {
    double sizeTH = 0;
    if (sizeheight >= 28.6) {
      sizeTH = 45;
    } else if (sizeheight >= 28.3) {
      sizeTH = 44.5;
    } else if (sizeheight >= 27.9) {
      sizeTH = 44.0;
    } else if (sizeheight >= 27.3) {
      sizeTH = 43.5;
    } else if (sizeheight >= 27.0) {
      sizeTH = 43.0;
    } else if (sizeheight >= 26.7) {
      sizeTH = 42.5;
    } else if (sizeheight >= 26.0) {
      sizeTH = 42.0;
    } else if (sizeheight >= 25.7) {
      sizeTH = 41.5;
    } else if (sizeheight >= 25.4) {
      sizeTH = 41.0;
    } else if (sizeheight >= 24.8) {
      sizeTH = 40.5;
    } else if (sizeheight >= 24.4) {
      sizeTH = 40.0;
    } else if (sizeheight >= 24.1) {
      sizeTH = 39.5;
    } else if (sizeheight <= 23.5) {
      sizeTH = 39.0;
    }
    return sizeTH;
  }

  double sizewoman(double sizeheight) {
    double sizeTH = 0;
    if (sizeheight >= 26.2) {
      sizeTH = 41;
    } else if (sizeheight >= 25.9) {
      sizeTH = 40.5;
    } else if (sizeheight >= 25.4) {
      sizeTH = 40.0;
    } else if (sizeheight >= 25.1) {
      sizeTH = 39.5;
    } else if (sizeheight >= 24.6) {
      sizeTH = 39.0;
    } else if (sizeheight >= 24.1) {
      sizeTH = 38.5;
    } else if (sizeheight >= 23.8) {
      sizeTH = 38.0;
    } else if (sizeheight >= 23.5) {
      sizeTH = 37.5;
    } else if (sizeheight >= 23.0) {
      sizeTH = 37.0;
    } else if (sizeheight >= 22.5) {
      sizeTH = 36.5;
    } else if (sizeheight >= 22.2) {
      sizeTH = 36.0;
    } else if (sizeheight >= 21.6) {
      sizeTH = 35.5;
    } else if (sizeheight <= 21.3) {
      sizeTH = 35.0;
    }
    return sizeTH;
  }

  Size();
}
