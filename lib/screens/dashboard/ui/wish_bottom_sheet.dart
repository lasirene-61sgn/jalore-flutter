import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

void showWishBottomSheet(BuildContext context, {required String phone, required bool isBirthday, required String name}) {
  final List<String> staticWishes = isBirthday ? [
    "Wishing you a very Happy Birthday! 🎂🎉",
    "Hope all your birthday wishes come true! 🥳🎈",
    "Have a wonderful birthday filled with love and joy! ❤️✨",
    "Wishing you another year of great adventures! 🚀",
    "Happy Birthday! May your day be as special as you are! 🎁",
  ] : [
    "Happy Anniversary! Wishing you many more years of love! ❤️🥂",
    "May your love continue to grow stronger each year. Happy Anniversary! 💕",
    "Wishing a perfect pair a perfectly happy day! 🎉",
    "Cheers to another year of wonderful moments together! 🥂",
    "Happy Anniversary! Here's to a love that lasts a lifetime. ✨",
  ];

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: _WishBottomSheetContent(
          staticWishes: staticWishes,
          phone: phone,
          name: name,
        ),
      );
    },
  );
}

class _WishBottomSheetContent extends StatefulWidget {
  final List<String> staticWishes;
  final String phone;
  final String name;

  const _WishBottomSheetContent({
    required this.staticWishes,
    required this.phone,
    required this.name,
  });

  @override
  State<_WishBottomSheetContent> createState() => _WishBottomSheetContentState();
}

class _WishBottomSheetContentState extends State<_WishBottomSheetContent> {
  String? _selectedWish;
  final TextEditingController _customWishController = TextEditingController();

  void _sendWish(String text) {
    if (text.isEmpty) return;
    
    // Replace placeholder if needed, though right now the templates are generic.
    // If we want to prepend name, we can do it here. But for now just send text.
    final finalMessage = "Dear ${widget.name},\n$text";
    launchUrl(Uri.parse('https://wa.me/${widget.phone}?text=${Uri.encodeComponent(finalMessage)}'), mode: LaunchMode.externalApplication);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Send a Wish to ${widget.name}",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),
          const SizedBox(height: 16),
          const Text("Select a quick wish:", style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          ...widget.staticWishes.map((wish) {
            return RadioListTile<String>(
              title: Text(wish, style: const TextStyle(fontSize: 14)),
              value: wish,
              groupValue: _selectedWish,
              contentPadding: EdgeInsets.zero,
              onChanged: (val) {
                setState(() {
                  _selectedWish = val;
                  _customWishController.clear();
                });
              },
            );
          }).toList(),
          const SizedBox(height: 16),
          const Text("Or type your own wish:", style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          TextField(
            controller: _customWishController,
            decoration: const InputDecoration(
              hintText: "Type your custom wish here...",
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
            maxLines: 2,
            onChanged: (val) {
              if (val.isNotEmpty && _selectedWish != null) {
                setState(() {
                  _selectedWish = null;
                });
              }
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF25D366),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            icon: const FaIcon(FontAwesomeIcons.whatsapp),
            label: const Text("Send via WhatsApp", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            onPressed: () {
              final text = _customWishController.text.isNotEmpty 
                  ? _customWishController.text 
                  : _selectedWish;
              if (text != null) {
                _sendWish(text);
              }
            },
          )
        ],
      ),
    );
  }
}
