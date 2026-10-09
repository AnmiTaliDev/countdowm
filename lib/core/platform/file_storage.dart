// SPDX-License-Identifier: GPL-3.0-or-later

import 'dart:convert';

import 'package:file_picker/file_picker.dart';

class PickedTextFile {
  const PickedTextFile({required this.name, required this.content});

  final String name;
  final String content;
}

class FileStorage {
  Future<bool> saveText({
    required String fileName,
    required String content,
    required String mimeType,
  }) async {
    final location = await FilePicker.saveFile(
      fileName: fileName,
      bytes: utf8.encode(content),
      mimeType: mimeType,
    );
    return location != null;
  }

  Future<PickedTextFile?> pickText(List<String> extensions) async {
    final file = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: extensions,
    );
    if (file == null) {
      return null;
    }
    final bytes = await file.readAsBytes();
    return PickedTextFile(
      name: file.name,
      content: utf8.decode(bytes, allowMalformed: true),
    );
  }
}
