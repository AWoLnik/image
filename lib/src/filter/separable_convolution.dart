import '../image.dart';
import 'separable_kernel.dart';

/// Apply a generic separable convolution filter the [src] image, using the
/// given [kernel].
///
/// [gaussianBlur] is an example of such a filter.
Image separableConvolution(Image src, SeparableKernel kernel, {int x1 = 0, int y1 = 0, int x2 = 0, int y2 = 0}) {
  // Apply the filter horizontally
  var tmp = Image.from(src);
  kernel.apply(src, tmp, horizontal: true, x1: x1, y1: y1, x2: x2, y2: y2);

  // Apply the filter vertically, applying back to the original image.
  kernel.apply(tmp, src, horizontal: false, x1: x1, y1: y1, x2: x2, y2: y2);

  return src;
}
