import 'package:hive_flutter/hive_flutter.dart';
import '../models/member.dart';
import '../models/committee_member.dart';
import '../models/news_item.dart';
import '../models/event.dart';

class DataService {
  static const String membersBoxName = 'members';
  static const String committeeBoxName = 'committee';
  static const String newsBoxName = 'news';
  static const String eventsBoxName = 'events';

  static Future<void> initialize() async {
    await Hive.initFlutter();
    
    // Register adapters (will be generated)
    // Hive.registerAdapter(MemberAdapter());
    
    // Open boxes
    await Hive.openBox(membersBoxName);
    await Hive.openBox(committeeBoxName);
    await Hive.openBox(newsBoxName);
    await Hive.openBox(eventsBoxName);
    
    // Initialize sample data if boxes are empty
    await _initializeSampleData();
  }

  static Future<void> _initializeSampleData() async {
    final membersBox = Hive.box(membersBoxName);
    final committeeBox = Hive.box(committeeBoxName);
    final newsBox = Hive.box(newsBoxName);
    final eventsBox = Hive.box(eventsBoxName);

    // Sample Members
    if (membersBox.isEmpty) {
      final sampleMembers = [
        Member(
          id: '1',
          name: 'SHRI ABHAYKUMARJI PUKHRAJJI DUDHERIA',
          mobile: '9381162338',
          businessType: 'Textiles',
          businessProducts: 'Cotton Fabrics',
          officeAddress: 'T. Nagar, Chennai',
          gender: 'Male',
          age: 45,
          dateOfBirth: DateTime(1979, DateTime.november, 15),
          dateOfAnniversary: DateTime(2005, DateTime.november, 20),
        ),
        Member(
          id: '2',
          name: 'SHRI AJEETKUMARJI UGAMCHANDJI SANCHETI',
          mobile: '9381013151',
          secondaryMobile: '23463059',
          businessType: 'Jewelry',
          businessProducts: 'Gold Ornaments',
          officeAddress: 'George Town, Chennai',
          gender: 'Male',
          age: 38,
          dateOfBirth: DateTime(1986, DateTime.november, 8),
          dateOfAnniversary: DateTime(2010, DateTime.november, 25),
        ),
        Member(
          id: '3',
          name: 'SHRI AJEETKUMARJI UGAMCHANDJI JAIN',
          mobile: '9841025811',
          businessType: 'Trading',
          businessProducts: 'General Merchandise',
          officeAddress: 'Parry\'s Corner, Chennai',
          gender: 'Male',
          age: 42,
          dateOfBirth: DateTime(1982, DateTime.november, 28),
        ),
        Member(
          id: '4',
          name: 'SHRI AKSHATJI VIJAYRAJJI MURARKA',
          mobile: '9789091745',
          businessType: 'Finance',
          businessProducts: 'Financial Services',
          officeAddress: 'Anna Nagar, Chennai',
          gender: 'Male',
          age: 35,
          dateOfBirth: DateTime(1989, DateTime.november, 24),
          dateOfAnniversary: DateTime(2012, DateTime.november, 24),
        ),
        Member(
          id: '5',
          name: 'SHRI AMOLAKCHANDJI RANJEETMALJI SANCHETI',
          mobile: '9841021061',
          secondaryMobile: '25393688',
          businessType: 'Real Estate',
          businessProducts: 'Property Development',
          officeAddress: 'Nungambakkam, Chennai',
          gender: 'Male',
          age: 50,
          dateOfBirth: DateTime(1974, DateTime.november, 24),
        ),
        Member(
          id: '6',
          name: 'SHRI ANILJI HEERACHANDJI LUHARUKA',
          mobile: '9710290000',
          secondaryMobile: '23463944',
          businessType: 'Manufacturing',
          businessProducts: 'Industrial Equipment',
          officeAddress: 'Ambattur, Chennai',
          gender: 'Male',
          age: 47,
        ),
        Member(
          id: '7',
          name: 'SHRI ANILJI UGAMCHANDJI BHANDARI',
          mobile: '9444469446',
          businessType: 'Hospitality',
          businessProducts: 'Hotel Services',
          officeAddress: 'Egmore, Chennai',
          gender: 'Male',
          age: 52,
        ),
        Member(
          id: '8',
          name: 'SHRI ANILRAJJI BHANMALJI PATODI',
          mobile: '9962722256',
          secondaryMobile: '9962659004',
          businessType: 'Import/Export',
          businessProducts: 'International Trade',
          officeAddress: 'Sowcarpet, Chennai',
          gender: 'Male',
          age: 44,
        ),
        Member(
          id: '9',
          name: 'SHRI ANKITJI ARVINDSEEJIMODI',
          mobile: '9381356483',
          businessType: 'IT Services',
          businessProducts: 'Software Development',
          officeAddress: 'Velachery, Chennai',
          gender: 'Male',
          age: 32,
        ),
        Member(
          id: '10',
          name: 'SHRI ASHOKJI KANMALJI SANCHETI',
          mobile: '9841234567',
          businessType: 'Pharmaceuticals',
          businessProducts: 'Medical Supplies',
          officeAddress: 'Kilpauk, Chennai',
          gender: 'Male',
          age: 48,
        ),
      ];

      for (var member in sampleMembers) {
        await membersBox.put(member.id, member.toJson());
      }
    }

    // Sample Committee Members
    if (committeeBox.isEmpty) {
      final committeeMembers = [
        CommitteeMember(
          id: '1',
          name: 'Shri Rajkumarji Sancheti',
          position: 'President',
          mobile: '9876543210',
        ),
        CommitteeMember(
          id: '2',
          name: 'Shri Ganeshji Modi',
          position: 'Vice President',
          mobile: '9876543211',
        ),
        CommitteeMember(
          id: '3',
          name: 'Shri Anilji Bhandari',
          position: 'Secretary',
          mobile: '9876543212',
        ),
        CommitteeMember(
          id: '4',
          name: 'Shri Pramodji Dudheria',
          position: 'Joint Secretary',
          mobile: '9876543213',
        ),
        CommitteeMember(
          id: '5',
          name: 'Shri Rameshji Patodi',
          position: 'Treasurer',
          mobile: '9876543214',
        ),
      ];

      for (var member in committeeMembers) {
        await committeeBox.put(member.id, member.toJson());
      }
    }

    // Sample News
    if (newsBox.isEmpty) {
      final newsItems = [
        NewsItem(
          id: '1',
          title: 'Annual Gathering 2024',
          description: 'Join us for our annual community gathering with cultural programs and dinner.',
          imageUrl: 'https://via.placeholder.com/400x200/1A237E/FFFFFF?text=Annual+Gathering',
          publishDate: DateTime.now().subtract(const Duration(days: 2)),
          category: 'Community',
        ),
        NewsItem(
          id: '2',
          title: 'Business Networking Meet',
          description: 'Connect with fellow business owners and explore collaboration opportunities.',
          imageUrl: 'https://via.placeholder.com/400x200/1A237E/FFFFFF?text=Business+Meet',
          publishDate: DateTime.now().subtract(const Duration(days: 5)),
          category: 'Business',
        ),
        NewsItem(
          id: '3',
          title: 'Youth Development Program',
          description: 'Special workshop for youth on career guidance and skill development.',
          imageUrl: 'https://via.placeholder.com/400x200/1A237E/FFFFFF?text=Youth+Program',
          publishDate: DateTime.now().subtract(const Duration(days: 7)),
          category: 'Education',
        ),
      ];

      for (var item in newsItems) {
        await newsBox.put(item.id, item.toJson());
      }
    }

    // Sample Events
    if (eventsBox.isEmpty) {
      final events = [
        Event(
          id: '1',
          title: 'Diwali Celebration',
          description: 'Grand Diwali celebration with cultural programs, dinner, and fireworks.',
          eventDate: DateTime.now().add(const Duration(days: 15)),
          location: 'Community Hall, T. Nagar',
          imageUrl: 'https://via.placeholder.com/400x200/1A237E/FFFFFF?text=Diwali+Celebration',
          category: 'Festival',
        ),
        Event(
          id: '2',
          title: 'Health Check-up Camp',
          description: 'Free health check-up camp for all community members.',
          eventDate: DateTime.now().add(const Duration(days: 10)),
          location: 'Sirohi Bhawan, Chennai',
          imageUrl: 'https://via.placeholder.com/400x200/1A237E/FFFFFF?text=Health+Camp',
          category: 'Health',
        ),
        Event(
          id: '3',
          title: 'Educational Seminar',
          description: 'Seminar on higher education opportunities for students.',
          eventDate: DateTime.now().add(const Duration(days: 20)),
          location: 'Conference Room, Anna Nagar',
          imageUrl: 'https://via.placeholder.com/400x200/1A237E/FFFFFF?text=Education+Seminar',
          category: 'Education',
        ),
      ];

      for (var event in events) {
        await eventsBox.put(event.id, event.toJson());
      }
    }
  }

  // Member operations
  static Future<List<Member>> getAllMembers() async {
    final box = Hive.box(membersBoxName);
    return box.values
        .map((json) => Member.fromJson(Map<String, dynamic>.from(json as Map)))
        .toList();
  }

  static Future<List<Member>> searchMembers(String query) async {
    final members = await getAllMembers();
    final lowerQuery = query.toLowerCase();
    return members.where((member) {
      return member.name.toLowerCase().contains(lowerQuery) ||
          member.mobile.contains(query) ||
          (member.businessType?.toLowerCase().contains(lowerQuery) ?? false);
    }).toList();
  }

  static Future<void> saveMember(Member member) async {
    final box = Hive.box(membersBoxName);
    await box.put(member.id, member.toJson());
  }

  // Committee operations
  static Future<List<CommitteeMember>> getCommitteeMembers() async {
    final box = Hive.box(committeeBoxName);
    return box.values
        .map((json) => CommitteeMember.fromJson(Map<String, dynamic>.from(json as Map)))
        .toList();
  }

  // News operations
  static Future<List<NewsItem>> getNews() async {
    final box = Hive.box(newsBoxName);
    final items = box.values
        .map((json) => NewsItem.fromJson(Map<String, dynamic>.from(json as Map)))
        .toList();
    items.sort((a, b) => b.publishDate.compareTo(a.publishDate));
    return items;
  }

  // Event operations
  static Future<List<Event>> getEvents() async {
    final box = Hive.box(eventsBoxName);
    final events = box.values
        .map((json) => Event.fromJson(Map<String, dynamic>.from(json as Map)))
        .toList();
    events.sort((a, b) => a.eventDate.compareTo(b.eventDate));
    return events;
  }
}
