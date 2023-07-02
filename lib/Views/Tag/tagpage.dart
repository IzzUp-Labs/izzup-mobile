import 'dart:async';

import 'package:flutter/material.dart';

import '../../Models/tag.dart';
import '../../Models/wave.dart';
import '../../Services/api.dart';

class TagsScreen extends StatefulWidget {
  const TagsScreen({super.key});

  @override
  State<StatefulWidget> createState() => _TagsScreenState();
}

class _TagsScreenState extends State<TagsScreen> {
  bool _isLoading = true;
  List<Tag> _tagItems = [];
  List<Tag> _selectedTagItems = [];

  @override
  void initState() {
    super.initState();
    _getTags();
    Timer(const Duration(milliseconds: 5 * 1000), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void _getTags() async {
    _tagItems = await Api.getTags();
  }

  void _addTags() async {
    await Api.addTags(_selectedTagItems);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Column(
                  children: [
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            const Spacer(),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: const Image(
                                image: AssetImage('assets/logo.png'),
                                width: 70,
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(right: 5),
                                      child: Text(
                                        'Skip',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Color(0xFFA5A5A5),
                                        ),
                                      ),
                                    ),
                                    Image(
                                      image: AssetImage("assets/arrow_right.png"),
                                      height: 15,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Text(
                      "Add Tags",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: MediaQuery.of(context).size.height / 30),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 40, right: 40),
                      child: Text(
                        "Complete your profile with tags that reflect your skills",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFA5A5A5)),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 10,
                          runSpacing: 10,
                          children: _tagItems
                              .map((tagItem) => TextButton(
                                    onPressed: () => onPressed(tagItem),
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                        _selectedTagItems.contains(tagItem)
                                            ? const Color(0xFF00B096)
                                            : const Color(0xFFA5A5A5),
                                      ),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(6.0),
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      tagItem.name,
                                      style: const TextStyle(
                                        color: Color(0xFFEDF0EB),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                          onPressed: () {
                            _addTags();
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.black.withOpacity(0.9),
                            ),
                          ),
                          child: const Text(
                            "Save",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Wave(),
        ],
      ),
    );
  }

  void onPressed(Tag tagItem) {
    setState(() {
      if (_selectedTagItems.contains(tagItem)) {
        _selectedTagItems.remove(tagItem);
      } else {
        _selectedTagItems.add(tagItem);
      }
    });
  }
}
