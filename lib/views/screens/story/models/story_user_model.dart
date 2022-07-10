import 'package:buddyscripts/views/screens/story/models/story_model.dart';
import 'package:meta/meta.dart';

class StoryUser {
  final String? name;
  final String? profileImageUrl;
  final String? username;

  const StoryUser({
    @required this.name,
    @required this.profileImageUrl,
    @required this.username,
  });
}

class UserWithStory {
  final dynamic userId;
  final String? name;
  final String? username;
  final String? profileImageUrl;
  final String? createdAt;
  final List<Story>? story;

  const UserWithStory({
    @required this.userId,
    @required this.name,
    @required this.username,
    @required this.profileImageUrl,
    @required this.createdAt,
    @required this.story,
  });
}
