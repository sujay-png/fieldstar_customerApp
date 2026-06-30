import 'dart:io';
import 'dart:typed_data';

import 'package:field_star_customer_app/pages/Raisecomplaint/shedule_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path/path.dart' as Path;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DescribeProblemPage extends StatefulWidget {
  final String tickedID;
  final String categoryName;
  final String equipmentName;
  final String problemDescription;
  const DescribeProblemPage({
    super.key,
    required this.tickedID,
    required this.categoryName,
    required this.equipmentName,
    required this.problemDescription,
  });

  @override
  State<DescribeProblemPage> createState() => _DescribeProblemPageState();
}

class _DescribeProblemPageState extends State<DescribeProblemPage> {
  final AudioRecorder audioRecorder = AudioRecorder();
  bool isrecoding = false;
  bool playing = false;
  final AudioPlayer audioPlayer = AudioPlayer();
  String? recordingPath;
  final problemCtrl = TextEditingController();
  String priority = 'Medium';
  Uint8List? _imageBytes;
  XFile? _pickedImage;

  @override
  void dispose() {
    problemCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canContinue = problemCtrl.text.trim().isNotEmpty;

    return Scaffold(
      backgroundColor: const Color(0xffF8FAFC),
      //===========Appbar==============================
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: .5,
        leading: const BackButton(color: Colors.black),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Raise Complaint',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Step 3 of 4',
              style: TextStyle(color: Colors.blueGrey, fontSize: 11),
            ),
          ],
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(3),
          child: Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: 267,
              height: 3,
              child: ColoredBox(color: Colors.deepOrange),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Describe the Problem',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Help us understand the issue better',
                style: TextStyle(fontSize: 12, color: Colors.blueGrey),
              ),
              const SizedBox(height: 22),

              const Text('Problem Description', style: TextStyle(fontSize: 12)),
              const SizedBox(height: 8),
              //==========================Problem description textbox=====================
              TextField(
                controller: problemCtrl,
                maxLines: 5,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),

              const SizedBox(height: 16),
              //===================voice and photo button=======================
              Row(
                children: [
                  Expanded(
                    child: actionButton(
                      isrecoding ? Icons.stop : Icons.mic_none,
                      'Voice Note',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: actionButtonImage(
                      Icons.camera_alt_outlined,
                      'Add Photos',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),
              builtUI(context),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _imageBytes != null
                      ? Image.memory(
                          _imageBytes!,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        )
                      : const Text('No Image selected'),
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () {
                        uploadImage(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        disabledBackgroundColor: const Color(0xffFDBA74),
                        foregroundColor: Colors.white,
                        disabledForegroundColor: Colors.white,
                        elevation: 0,
                      ),
                      child: const Text('Continue'),
                    ),
                  ),
                ],
              ),
              //============================Priority level======================================
              const Text('Priority Level', style: TextStyle(fontSize: 12)),
              const SizedBox(height: 8),

              Row(
                children: ['Low', 'Medium', 'High'].map((p) {
                  final selected = priority == p;

                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => priority = p),
                      child: Container(
                        height: 32,
                        margin: const EdgeInsets.only(right: 6),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: selected
                              ? const Color(0xfffff3cd)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: selected
                                ? Colors.amber
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: Text(
                          p,
                          style: TextStyle(
                            fontSize: 12,
                            color: selected
                                ? Colors.deepOrange
                                : Colors.blueGrey,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 280),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Back'),
                    ),
                  ),
                  //=====================continue button=====================================
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: canContinue
                          ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ScheduleServicePage(
                                    tickedID: widget.tickedID,
                                    categoryName: widget.categoryName,
                                    equipmentName: widget.equipmentName,
                                    problemDescription: problemCtrl.text.trim(),
                                    priorityStatus: priority,
                                    imageBytes: _imageBytes,
                                  ),
                                ),
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        disabledBackgroundColor: const Color(0xffFDBA74),
                        foregroundColor: Colors.white,
                        disabledForegroundColor: Colors.white,
                        elevation: 0,
                      ),
                      child: const Text('Continue'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  //=========To listen audio =====================
  Widget builtUI(BuildContext context) {
    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (recordingPath != null)
            MaterialButton(
              onPressed: () async {
                if (audioPlayer.playing) {
                  audioPlayer.stop();
                  setState(() {
                    playing = false;
                  });
                } else {
                  await audioPlayer.setFilePath(recordingPath!);
                  audioPlayer.play();
                  setState(() {
                    playing = true;
                  });
                }
              },
              color: Theme.of(context).colorScheme.primary,
              child: Text(
                playing ? "Stop playing Recording" : "Start playing Recording",
              ),
            ),
          if (recordingPath == null) const Text("No Recording Found !"),
        ],
      ),
    );
  }

  Widget actionButton(IconData icon, String text) {
    return OutlinedButton.icon(
      onPressed: () async {
        if (isrecoding) {
          String? filepath = await audioRecorder.stop();
          if (filepath != null) {
            setState(() {
              isrecoding = false;
              recordingPath = filepath;
            });
          }
        } else {
          if (await audioRecorder.hasPermission()) {
            final Directory appDocumentsDir =
                await getApplicationDocumentsDirectory();
            final String filepath = Path.join(
              appDocumentsDir.path,
              "Recording.wav",
            );
            await audioRecorder.start(const RecordConfig(), path: filepath);
            setState(() {
              isrecoding = true;
              recordingPath = null;
            });
          }
        }
      },
      icon: Icon(icon, size: 16, color: Colors.black87),
      label: Text(text, style: const TextStyle(color: Colors.black87)),
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
      ),
    );
  }

  Widget actionButtonImage(IconData icon, String text) {
    return OutlinedButton.icon(
      onPressed: () async {
        pickImage();
      },
      icon: Icon(icon, size: 16, color: Colors.black87),
      label: Text(text, style: const TextStyle(color: Colors.black87)),
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
      ),
    );
  }

  //================Pick image method=========================
  Future pickImage() async {
    final ImagePicker picker = ImagePicker();

    //Pick from the gallery

    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    //Upload Image Preview
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _pickedImage = image;
        _imageBytes = bytes;
      });
    }
  }

  //====================Upload========================
  Future uploadImage(BuildContext context) async {
    if (_imageBytes == null) return;
    final fileName = DateTime.now().microsecondsSinceEpoch.toString();
    final path = 'uploads/$fileName';

    await Supabase.instance.client.storage
        .from('images')
        .uploadBinary(path, _imageBytes!)
        .then(
          (value) => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Image Uploaded successfully')),
          ),
        );
  }
}

//===============================Checkbox widget =======================================
class CheckboxExample extends StatefulWidget {
  const CheckboxExample({super.key});

  @override
  State<CheckboxExample> createState() => _CheckboxExampleState();
}

class _CheckboxExampleState extends State<CheckboxExample> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<WidgetState> states) {
      const Set<WidgetState> interactiveStates = <WidgetState>{
        WidgetState.pressed,
        WidgetState.hovered,
        WidgetState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.red;
    }

    return Checkbox(
      checkColor: Colors.white,
      fillColor: WidgetStateProperty.resolveWith(getColor),
      value: isChecked,
      onChanged: (bool? value) {
        setState(() {
          isChecked = value!;
        });
      },
    );
  }
}
