import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class FileUploadWidget extends StatelessWidget {
  final String label;
  final String? fileName;
  final IconData icon;
  final String uploadText;
  final String subtitle;
  final ValueChanged<File> onFileSelected;

  const FileUploadWidget({
    super.key,
    required this.label,
    this.fileName,
    required this.icon,
    required this.uploadText,
    required this.subtitle,
    required this.onFileSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _pickFile(),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              border: Border.all(
                color: const Color(0xFFE5E7EB),
                style: BorderStyle.solid,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: fileName != null
                ? Column(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Color(0xFF10B981),
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        fileName!,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'File uploaded successfully',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF10B981),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Icon(icon, color: const Color(0xFF9CA3AF), size: 32),
                      const SizedBox(height: 8),
                      Text(
                        uploadText,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF9CA3AF),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'png'],
    );

    if (result != null && result.files.single.path != null) {
      File file = File(result.files.single.path!);
      onFileSelected(file);
    }
  }
}
