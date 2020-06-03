import '../color.dart';
import '../image.dart';

/// A kernel object to use with [separableConvolution] filtering.
class SeparableKernel {
  final List<num> coefficients;
  final int size;

  /// Create a separable convolution kernel for the given [radius].
  SeparableKernel(int radius)
      : coefficients = List<num>(2 * radius + 1),
        size = radius;

  /// Get the number of coefficients in the kernel.
  int get length => coefficients.length;

  /// Get a coefficient from the kernel.
  num operator [](int index) => coefficients[index];

  /// Set a coefficient in the kernel.
  void operator []=(int index, num c) {
    coefficients[index] = c;
  }

  /// Apply the kernel to the [src] image, storing the results in [dst],
  /// for a single dimension. If [horizontal is true, the filter will be
  /// applied to the horizontal axis, otherwise it will be appied to the
  /// vertical axis.
  void apply(Image src, Image dst, {bool horizontal = true, int x1 = 0, int y1 = 0, int x2 = 0, int y2 = 0}) {
    if (horizontal) {
      for (var y = y1; y < y2; ++y) {
        _applyCoeffsLine(src, dst, y, src.width, horizontal, x1: x1, x2: x2);
      }
    } else {
      for (var x = x1; x < x2; ++x) {
        _applyCoeffsLine(src, dst, x, src.height, horizontal, x1: y1, x2: y2);
      }
    }
  }

  /// Scale all of the coefficients by [s].
  void scaleCoefficients(num s) {
    for (var i = 0; i < coefficients.length; ++i) {
      coefficients[i] *= s;
    }
  }

  int _reflect(int max, int x) {
    if (x < 0) {
      return -x;
    }
    if (x >= max) {
      return max - (x - max) - 1;
    }
    return x;
  }

  void _applyCoeffsLine(
      Image src, Image dst, int y, int width, bool horizontal, {int x1 = 0, int x2 = 0}) {
    for (var x = x1; x < x2; x++) {
      num r = 0.0;
      num g = 0.0;
      num b = 0.0;
      num a = 0.0;

      for (var j = -size, j2 = 0; j <= size; ++j, ++j2) {
        var coeff = coefficients[j2];
        var gr = _reflect(width, x + j);

        var sc = (horizontal) ? src.getPixel(gr, y) : src.getPixel(y, gr);

        r += coeff * getRed(sc);
        g += coeff * getGreen(sc);
        b += coeff * getBlue(sc);
        a += coeff * getAlpha(sc);
      }

      var c = getColor(
          (r > 255.0 ? 255.0 : r).toInt(),
          (g > 255.0 ? 255.0 : g).toInt(),
          (b > 255.0 ? 255.0 : b).toInt(),
          (a > 255.0 ? 255.0 : a).toInt());

      if (horizontal) {
        dst.setPixel(x, y, c);
      } else {
        dst.setPixel(y, x, c);
      }
    }
  }
}
