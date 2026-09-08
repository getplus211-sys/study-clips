/// Cloudflare R2 is S3-compatible, so any S3 client SDK works.
/// For Flutter, the simplest approach is:
///   1. Client asks a Supabase Edge Function for a presigned PUT URL.
///   2. Client uploads the file directly to that URL (bypasses your server).
///   3. Client saves the resulting object key in premium_content.r2_key.
///
/// This keeps R2 credentials off the device entirely.
class StorageService {
  final String edgeFunctionUrl; // e.g. https://<project>.supabase.co/functions/v1/r2-presign

  StorageService({required this.edgeFunctionUrl});

  Future<String> requestPresignedUploadUrl({required String fileName, required String contentType}) async {
    // TODO: POST { fileName, contentType } to edgeFunctionUrl, return the presigned URL.
    throw UnimplementedError('Implement the Edge Function call for R2 presigned uploads.');
  }

  Future<String> requestPresignedDownloadUrl({required String objectKey}) async {
    // TODO: POST { objectKey } to edgeFunctionUrl, return a short-lived signed GET URL.
    throw UnimplementedError('Implement the Edge Function call for R2 presigned downloads.');
  }
}
