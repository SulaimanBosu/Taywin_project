class SizeMen {
  double sizeTH(double sizeheight) {
    double sizeTH = 45;
    if (sizeheight <= 28.6) {
      sizeTH = 45;
    } else if (sizeheight <= 28.3) {
      sizeTH = 44.5;
    } else if (sizeheight <= 27.9) {
      sizeTH = 44.0;
    } else if (sizeheight <= 27.3) {
      sizeTH = 43.5;
    } else if (sizeheight <= 27.0) {
      sizeTH = 43.0;
    } else if (sizeheight <= 26.7) {
      sizeTH = 42.5;
    } else if (sizeheight <= 26.0) {
      sizeTH = 42.0;
    } else if (sizeheight <= 25.7) {
      sizeTH = 41.5;
    } else if (sizeheight <= 25.4) {
      sizeTH = 41.0;
    } else if (sizeheight <= 24.8) {
      sizeTH = 40.5;
    } else if (sizeheight <= 24.4) {
      sizeTH = 40.0;
    } else if (sizeheight <= 24.1) {
      sizeTH = 39.5;
    } else if (sizeheight <= 23.5) {
      sizeTH = 39.0;
    }
    return sizeTH;
  }
}
