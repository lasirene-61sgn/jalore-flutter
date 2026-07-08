import 'package:flutter/material.dart';
import 'package:flutter_app/screens/events/notifier/event_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../config/theme.dart';
import 'package:flutter_app/screens/events/model/event_model.dart';

class EventsScreen extends ConsumerStatefulWidget {
  const EventsScreen({super.key});

  @override
  ConsumerState<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends ConsumerState<EventsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(eventsNotifierProvider.notifier).loadEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    final eventsState = ref.watch(eventsNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Events'),backgroundColor: AppTheme.backgroundWhite,),
      body: SafeArea(
        child: eventsState.isLoading  && eventsState.eventsList.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : eventsState.eventsList.isEmpty
            ? const Center(child: Text('No events available'))
            : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: eventsState.eventsList.length,
          itemBuilder: (context, index) {
            return _buildEventCard(eventsState.eventsList[index]);
          },
        ),
      ),
    );
  }

  Widget _buildEventCard(Event event) {
    final hasImage = event.imagePaths.isNotEmpty;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// IMAGE
          if (hasImage)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
              child: Image.network(
                event.imagePaths.first,
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _fallbackImage(),
                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                  // 1. If loading is finished, return the actual image (child)
                  if (loadingProgress == null) return child;

                  // 2. While loading, show the progress indicator centered within the image area
                  return Container(
                    height: 160, // Match the image height to prevent layout jumps
                    color: AppTheme.backgroundGrey, // Optional: light grey placeholder color
                    child: Center(
                      child: SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

          /// DETAILS
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.name,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                Row(
                  children: [
                    const Icon(Icons.calendar_today,
                        size: 16, color: AppTheme.primaryBlue),
                    const SizedBox(width: 8),
                    Text(
                      DateFormat('dd MMM yyyy')
                          .format(event.postedDate),
                        style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(
                        color: AppTheme.primaryBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                Text(
                  event.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                event.srcfStatus.isEmpty?
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildRSVPButton(
                      label: 'Accept',
                      icon: Icons.check_circle_outline,
                      color: Colors.green,
                      onPressed: () => _showRSVPDialog(
                        eventId: event.id.toString(),
                        status: 'accepted',
                        themeColor: Colors.green,
                      ),
                    ),
                    _buildRSVPButton(
                      label: 'Maybe',
                      icon: Icons.help_outline,
                      color: Colors.orange,
                      onPressed: () => _showRSVPDialog(
                        eventId: event.id.toString(),
                        status: 'maybe',
                        themeColor: Colors.orange,
                      ),
                    ),
                    _buildRSVPButton(
                      label: 'Decline',
                      icon: Icons.cancel_outlined,
                      color: Colors.red,
                      onPressed: () => _showRSVPDialog(
                        eventId: event.id.toString(),
                        status: 'declined',
                        themeColor: Colors.red,
                      ),
                    ),
                  ],
                ):
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade400, width: 0.5),
                    ),
                    child: Text(
                      event.srcfStatus.isNotEmpty
                          ? '${event.srcfStatus[0].toUpperCase()}${event.srcfStatus.substring(1).toLowerCase()}'
                          : '',
                      style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                )

              ],
            ),
          ),
        ],
      ),
    );
  }
  Future<void> _showRSVPDialog({
    required String eventId,
    required String status,
    required Color themeColor,
  }) async {
    String note = "";
    int adultsCount = 1;
    int childrenCount = 0;
    final state = ref.watch(eventsNotifierProvider);

    // Logic to check if we should show counters
    final bool isAccepting = status == 'accepted';

    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('RSVP: ${status.toUpperCase()}'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Always show Note field
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Note (Optional)',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                      onChanged: (value) => note = value,
                    ),

                    // Only show counters if the status is 'accepted'
                    if (isAccepting) ...[
                      const SizedBox(height: 20),
                      const Divider(),
                      const Text("Number of Guests",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),

                      _buildCounterRow(
                        label: "Adults",
                        value: adultsCount,
                        onChanged: (val) => setDialogState(() => adultsCount = val!),
                      ),
                      _buildCounterRow(
                        label: "Children",
                        value: childrenCount,
                        onChanged: (val) => setDialogState(() => childrenCount = val!),
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: themeColor),
                  onPressed:state.isSaving? null: () {
                    final Map<String, dynamic> data = {
                      "status": status,
                      "note": note,
                    };

                    // Only add counts to the payload if accepting
                    if (isAccepting) {
                      data["adults_count"] = adultsCount;
                      data["children_count"] = childrenCount;
                    }

                    ref.read(eventsNotifierProvider.notifier).updateRSVP(eventId, data);
                    Navigator.pop(context);
                  },
                  child:state.isSaving?
                      const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2)):
                  const Text('Submit', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

// Helper widget for the dropdown rows
  Widget _buildCounterRow({
    required String label,
    required int value,
    required ValueChanged<int?> onChanged
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: DropdownButton<int>(
              value: value,
              underline: const SizedBox(), // Remove default underline
              items: List.generate(11, (i) => i) // Allows 0 to 10
                  .map((e) => DropdownMenuItem(value: e, child: Text("$e")))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildRSVPButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18, color: color),
      label: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8),
      ),
    );
  }
  Widget _fallbackImage() {
    return Container(
      height: 160,
      color: AppTheme.secondaryBlue,
      child: const Center(
        child: Icon(Icons.event, size: 64, color: Colors.white),
      ),
    );
  }
}

