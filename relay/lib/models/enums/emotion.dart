import 'package:relay/models/exceptions/enums.dart';

enum Emotion {
  happy,
  sad,
  angry,
  surprised,
  disgusted,
  scared,
  neutral;

  static Emotion fromString(String value) {
    switch (value) {
      case 'happy':
        return Emotion.happy;
      case 'sad':
        return Emotion.sad;
      case 'angry':
        return Emotion.angry;
      case 'surprised':
        return Emotion.surprised;
      case 'disgusted':
        return Emotion.disgusted;
      case 'scared':
        return Emotion.scared;
      case 'neutral':
        return Emotion.neutral;
      default:
        throw InvalidSerializedEnumException(enumType: 'Emotion', value: value);
    }
  }
}

extension EmotionExtension on Emotion {
  String get name {
    switch (this) {
      case Emotion.happy:
        return 'happy';
      case Emotion.sad:
        return 'sad';
      case Emotion.angry:
        return 'angry';
      case Emotion.surprised:
        return 'surprised';
      case Emotion.disgusted:
        return 'disgusted';
      case Emotion.scared:
        return 'scared';
      case Emotion.neutral:
        return 'neutral';
      default:
        throw InvalidSerializedEnumException(
            enumType: 'Emotion', value: toString());
    }
  }
}
