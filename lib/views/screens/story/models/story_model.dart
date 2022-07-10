import 'package:buddyscripts/views/screens/story/models/story_user_model.dart';
import 'package:meta/meta.dart';

enum MediaType { image, video, text }

class Story {
  final dynamic storyId;
  final String? url;
  final MediaType? media;
  final Duration? duration;
  final StoryUser? user;
  final String? bgColor;
  final String? createTime;

  const Story({
    @required this.storyId,
    @required this.url,
    @required this.media,
    @required this.duration,
    @required this.user,
    @required this.bgColor,
    @required this.createTime,
  });
}
