import 'package:flutter_test/flutter_test.dart';
import 'package:parents_partnership/achats/chat_service.dart';

void main() {
  group('ChatMessagePayload Tests', () {
    test('parses plain text correctly', () {
      final payload = ChatMessagePayload.parse('Hello from the community!');
      expect(payload.text, equals('Hello from the community!'));
      expect(payload.hasImage, isFalse);
      expect(payload.hasAudio, isFalse);
      expect(payload.isReply, isFalse);
      expect(payload.previewSnippet, equals('Hello from the community!'));
    });

    test('serializes and parses image payload correctly', () {
      final original = ChatMessagePayload(
        text: 'Look at this park!',
        imageUrl: 'https://example.com/images/park.jpg',
        imageCaption: 'Look at this park!',
      );

      final encoded = original.toEncodedString();
      final parsed = ChatMessagePayload.parse(encoded);

      expect(parsed.hasImage, isTrue);
      expect(parsed.imageUrl, equals('https://example.com/images/park.jpg'));
      expect(parsed.imageCaption, equals('Look at this park!'));
      expect(parsed.previewSnippet, equals('📷 Look at this park!'));
    });

    test('serializes and parses audio note payload correctly', () {
      final original = ChatMessagePayload(
        text: '',
        audioUrl: 'https://example.com/audios/voice.mp3',
        audioDurationSeconds: 15,
      );

      final encoded = original.toEncodedString();
      final parsed = ChatMessagePayload.parse(encoded);

      expect(parsed.hasAudio, isTrue);
      expect(parsed.audioUrl, equals('https://example.com/audios/voice.mp3'));
      expect(parsed.audioDurationSeconds, equals(15));
      expect(parsed.previewSnippet, equals('🎤 Voice message'));
    });

    test('serializes and parses quoted reply payload correctly', () {
      final original = ChatMessagePayload(
        text: 'I can bring the snacks!',
        replyToId: 99,
        replyToSender: 'Jessica',
        replyToText: 'Who can help with the weekend picnic?',
      );

      final encoded = original.toEncodedString();
      final parsed = ChatMessagePayload.parse(encoded);

      expect(parsed.isReply, isTrue);
      expect(parsed.replyToId, equals(99));
      expect(parsed.replyToSender, equals('Jessica'));
      expect(parsed.replyToText, equals('Who can help with the weekend picnic?'));
      expect(parsed.text, equals('I can bring the snacks!'));
    });
  });

  group('ChatService Formatting Tests', () {
    test('formatInboxTimestamp formats today as time string', () {
      final now = DateTime.now();
      final formatted = ChatService.formatInboxTimestamp(now);
      expect(formatted.contains(':') || formatted.contains('AM') || formatted.contains('PM'), isTrue);
    });

    test('formatDateDivider formats today and yesterday properly', () {
      final today = DateTime.now();
      final yesterday = DateTime.now().subtract(const Duration(days: 1));

      expect(ChatService.formatDateDivider(today), equals('Today'));
      expect(ChatService.formatDateDivider(yesterday), equals('Yesterday'));
    });

    test('isDifferentDay detects calendar day changes', () {
      final morning = DateTime(2026, 10, 15, 9, 30);
      final afternoon = DateTime(2026, 10, 15, 16, 45);
      final nextDay = DateTime(2026, 10, 16, 8, 15);

      expect(ChatService.isDifferentDay(morning, afternoon), isFalse);
      expect(ChatService.isDifferentDay(morning, nextDay), isTrue);
    });
  });
}

