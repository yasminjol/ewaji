import 'dart:io';
import 'package:image/image.dart' as img;

/// Face blur service for protecting privacy in review images
/// Currently simplified due to google_mlkit_face_detection dependency conflicts
class FaceBlurService {
  /// Blur faces in the image to protect privacy
  /// Currently returns original image due to dependency conflicts
  /// TODO: Re-enable face detection when google_mlkit_face_detection dependency is resolved
  static Future<File> blurFacesInImage(File imageFile) async {
    try {
      // For now, just return the original image
      // TODO: Implement face detection and blurring when dependencies are resolved
      return imageFile;
    } catch (e) {
      // On error, return original image
      return imageFile;
    }
  }

  /// Check if face detection is available
  static bool get isFaceDetectionAvailable => false; // TODO: Change to true when enabled

  /// Dispose of resources
  static void dispose() {
    // TODO: Implement disposal when face detector is available
  }
}

/// Image compression service to ensure images are ≤3 MB
class ImageCompressionService {
  static const int maxSizeBytes = 3 * 1024 * 1024; // 3 MB
  static const int maxWidth = 1920;
  static const int maxHeight = 1080;

  static Future<File> compressImage(File imageFile) async {
    try {
      final imageBytes = await imageFile.readAsBytes();
      
      // If already under size limit, return as-is
      if (imageBytes.length <= maxSizeBytes) {
        return imageFile;
      }

      final originalImage = img.decodeImage(imageBytes);
      if (originalImage == null) {
        throw Exception('Failed to decode image');
      }

      // Calculate new dimensions while maintaining aspect ratio
      final aspectRatio = originalImage.width / originalImage.height;
      int newWidth = originalImage.width;
      int newHeight = originalImage.height;

      if (newWidth > maxWidth) {
        newWidth = maxWidth;
        newHeight = (newWidth / aspectRatio).round();
      }

      if (newHeight > maxHeight) {
        newHeight = maxHeight;
        newWidth = (newHeight * aspectRatio).round();
      }

      // Resize image
      final resizedImage = img.copyResize(
        originalImage,
        width: newWidth,
        height: newHeight,
        interpolation: img.Interpolation.linear,
      );

      // Start with high quality and reduce until under size limit
      int quality = 90;
      List<int> compressedBytes;
      
      do {
        compressedBytes = img.encodeJpg(resizedImage, quality: quality);
        quality -= 10;
      } while (compressedBytes.length > maxSizeBytes && quality > 10);

      // Save compressed image
      final originalPath = imageFile.path;
      final extension = originalPath.split('.').last;
      final nameWithoutExtension = originalPath.substring(0, originalPath.lastIndexOf('.'));
      final compressedPath = '${nameWithoutExtension}_compressed.$extension';
      
      final compressedFile = File(compressedPath);
      await compressedFile.writeAsBytes(compressedBytes);
      
      return compressedFile;
    } catch (e) {
      print('Image compression error: $e');
      return imageFile;
    }
  }

  /// Get the file size in MB
  static Future<double> getFileSizeMB(File file) async {
    final bytes = await file.length();
    return bytes / (1024 * 1024);
  }

  /// Check if image needs compression
  static Future<bool> needsCompression(File imageFile) async {
    final bytes = await imageFile.length();
    return bytes > maxSizeBytes;
  }
}
