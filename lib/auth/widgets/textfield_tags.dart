import 'package:flutter/material.dart';
import 'package:textfield_tags/textfield_tags.dart';

class TextfieldTags extends StatefulWidget {
  const TextfieldTags({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<TextfieldTags> createState() => _TextfieldTagsState();
}

TextfieldTagsController _controller = TextfieldTagsController();

class _TextfieldTagsState extends State<TextfieldTags> {
  double? _distanceToField;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _distanceToField = MediaQuery.of(context).size.width;
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = TextfieldTagsController();
  }

  static const List<String> _pickLanguage = <String>[
    'c',
    'c++',
    'java',
    'python',
    'javascript',
    'php',
    'sql',
    'yaml',
    'gradle',
    'xml',
    'html',
    'flutter',
    'css',
    'dockerfile'
  ];
  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsViewBuilder: (context, onSelected, options) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
          child: Align(
            alignment: Alignment.topCenter,
            child: Material(
              elevation: 4.0,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 200),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: options.length,
                  itemBuilder: (BuildContext context, int index) {
                    final dynamic option = options.elementAt(index);
                    return TextButton(
                      onPressed: () {
                        onSelected(option);
                      },
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: Text(
                            '$option',
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              color: Color.fromARGB(255, 74, 137, 92),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') {
          return const Iterable<String>.empty();
        }
        return _pickLanguage.where((String option) {
          return option.contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: (String selectedTag) {
        _controller.addTag = selectedTag;
      },
      fieldViewBuilder: (context, ttec, tfn, onFieldSubmitted) {
        return TextFieldTags(
          textEditingController: ttec,
          focusNode: tfn,
          textfieldTagsController: _controller,
          initialTags: const [
            'Work Experience',
            'Niche',
            'Target',
            'Education',
            'Products',
          ],
          textSeparators: const [' ', ','],
          letterCase: LetterCase.normal,
          validator: (String tag) {
            if (tag.length < 2) {
              return 'Please enter something';
            } else if (_controller.getTags!.contains(tag)) {
              return 'you already entered $tag';
            }
            return null;
          },
          inputfieldBuilder: (context, tec, fn, error, onChanged, onSubmitted) {
            return ((context, sc, tags, onTagDelete) {
              return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(widget.title),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                  child: TextFormField(
                    maxLines: 5,
                    minLines: 1,
                    controller: tec,
                    focusNode: fn,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Color(0xff007AFF),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Color(0xff007AFF),
                        ),
                      ),
                      hintText: _controller.hasTags ? '' : "Enter tag...",
                      errorText: error,
                      prefixIconConstraints: BoxConstraints(maxWidth: _distanceToField! * 0.74),
                      prefixIcon: tags.isNotEmpty
                          ? SingleChildScrollView(
                              controller: sc,
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                  children: tags.map((String tag) {
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(10.0),
                                    ),
                                    color: const Color(0xff007AFF).withOpacity(0.2),
                                  ),
                                  margin: const EdgeInsets.only(right: 10.0),
                                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        child: Text(
                                          tag,
                                          style: const TextStyle(color: Color(0xff007AFF)),
                                        ),
                                        onTap: () {
                                          print(tag);
                                        },
                                      ),
                                      const SizedBox(width: 4.0),
                                      InkWell(
                                        child: const Icon(
                                          Icons.cancel,
                                          size: 14.0,
                                          color: Color(0xff007AFF),
                                        ),
                                        onTap: () {
                                          onTagDelete(tag);
                                        },
                                      )
                                    ],
                                  ),
                                );
                              }).toList()),
                            )
                          : null,
                    ),
                    onChanged: onChanged,
                    onFieldSubmitted: onSubmitted,
                  ),
                ),
              ]);
            });
          },
        );
      },
    );
  }
}
