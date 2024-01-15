import 'package:json_annotation/json_annotation.dart';
import 'package:rickmorty/fav_qs/model/quote_user_info.dart';

part 'quote_rm.g.dart';

@JsonSerializable(createToJson: false)
class QuoteRM {
  const QuoteRM({
    required this.id,
    required this.body,
    required this.favoritesCount,
    required this.upvotesCount,
    required this.downvotesCount,
    this.author,
    this.userInfo,
  });

  final int id;
  final String? body;
  final String? author;
  @JsonKey(name: 'user_details')
  final QuoteUserInfoRM? userInfo;
  @JsonKey(name: 'favorites_count', defaultValue: 0)
  final int favoritesCount;
  @JsonKey(name: 'upvotes_count', defaultValue: 0)
  final int upvotesCount;
  @JsonKey(name: 'downvotes_count', defaultValue: 0)
  final int downvotesCount;

  static const fromJson = _$QuoteRMFromJson;
}
