import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../theme/app_theme.dart';
import '../widgets/subject_chip.dart';
import '../services/post_service.dart';
import '../services/storage_service.dart';

/// Screen for composing a new feed post: subject tag, text body, and
/// up to [_maxImages] images. Images are uploaded to the public `media`
/// bucket (see StorageService), then the post row is created with the
/// resulting URLs (see PostService.createPost).
class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  static const _maxImages = 4;

  final _postService = PostService();
  final _storageService = StorageService();
  final _picker = ImagePicker();
  final _bodyController = TextEditingController();

  // Same subject list as FeedScreen, minus the "બધા" (All) filter option.
  final _subjects = const ['GPSC', 'PSI', 'Talati', 'Clerk', 'Police'];
  int _subjectIndex = 0;

  final List<XFile> _pickedImages = [];
  bool _posting = false;

  @override
  void dispose() {
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    if (_pickedImages.length >= _maxImages) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('વધુમાં વધુ $_maxImages images ઉમેરી શકાય.')),
      );
      return;
    }
    final remaining = _maxImages - _pickedImages.length;
    final images = await _picker.pickMultiImage(imageQuality: 85);
    if (images.isEmpty) return;
    setState(() {
      _pickedImages.addAll(images.take(remaining));
    });
  }

  void _removeImage(int index) {
    setState(() => _pickedImages.removeAt(index));
  }

  bool get _canPost => _bodyController.text.trim().isNotEmpty && !_posting;

  Future<void> _submit() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post કરવા માટે login જરૂરી છે.')),
      );
      return;
    }
    final body = _bodyController.text.trim();
    if (body.isEmpty) return;

    setState(() => _posting = true);
    try {
      final imageUrls = <String>[];
      for (final image in _pickedImages) {
        final bytes = await image.readAsBytes();
        final ext = _extensionFor(image.name);
        final path = '$userId/${DateTime.now().microsecondsSinceEpoch}_${imageUrls.length}$ext';
        final url = await _storageService.uploadPublicMedia(
          path: path,
          bytes: bytes,
          contentType: _contentTypeFor(ext),
        );
        imageUrls.add(url);
      }

      await _postService.createPost(
        userId: userId,
        subject: _subjects[_subjectIndex],
        body: body,
        imageUrls: imageUrls,
      );

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Post કરવામાં ભૂલ આવી: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _posting = false);
    }
  }

  String _extensionFor(String filename) {
    final dot = filename.lastIndexOf('.');
    if (dot == -1) return '.jpg';
    return filename.substring(dot).toLowerCase();
  }

  String _contentTypeFor(String ext) {
    switch (ext) {
      case '.png':
        return 'image/png';
      case '.webp':
        return 'image/webp';
      case '.heic':
        return 'image/heic';
      default:
        return 'image/jpeg';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('નવો Post'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Center(
              child: TextButton(
                onPressed: _canPost ? _submit : null,
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  disabledForegroundColor: Colors.white54,
                ),
                child: _posting
                    ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Post', style: TextStyle(fontWeight: FontWeight.w700)),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Subject', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.slate)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 0,
              runSpacing: 8,
              children: List.generate(_subjects.length, (i) {
                return SubjectChip(
                  label: _subjects[i],
                  active: i == _subjectIndex,
                  onTap: () => setState(() => _subjectIndex = i),
                );
              }),
            ),
            const SizedBox(height: 20),
            const Text('શું share કરવું છે?', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.slate)),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.line),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _bodyController,
                maxLines: 8,
                minLines: 5,
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(
                  hintText: 'તમારો પ્રશ્ન, નોંધ કે update અહીં લખો...',
                  contentPadding: EdgeInsets.all(14),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text('Images', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.slate)),
                const SizedBox(width: 6),
                Text('(${_pickedImages.length}/$_maxImages)', style: const TextStyle(fontSize: 12, color: AppColors.slateLight)),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 90,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  ..._pickedImages.asMap().entries.map((entry) => _imageThumb(entry.key, entry.value)),
                  if (_pickedImages.length < _maxImages) _addImageButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imageThumb(int index, XFile file) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: FutureBuilder<Uint8List>(
              future: file.readAsBytes(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container(
                    width: 90,
                    height: 90,
                    color: const Color(0xFFF7F5EF),
                  );
                }
                return Image.memory(snapshot.data!, width: 90, height: 90, fit: BoxFit.cover);
              },
            ),
          ),
          Positioned(
            top: 2,
            right: 2,
            child: GestureDetector(
              onTap: () => _removeImage(index),
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                child: const Icon(Icons.close, size: 14, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _addImageButton() {
    return GestureDetector(
      onTap: _pickImages,
      child: Container(
        width: 90,
        height: 90,
        decoration: BoxDecoration(
          color: const Color(0xFFF7F5EF),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.line),
        ),
        child: const Icon(Icons.add_photo_alternate_outlined, color: AppColors.slate),
      ),
    );
  }
}
