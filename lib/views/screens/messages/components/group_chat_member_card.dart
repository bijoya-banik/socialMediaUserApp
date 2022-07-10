import 'package:buddyscripts/constants/shared_preference_constant.dart';
import 'package:buddyscripts/models/group_chat/group_chat_members_model.dart';
import 'package:buddyscripts/views/global_components/user_name.dart';
import 'package:buddyscripts/views/global_components/user_profile_picture.dart';
import 'package:buddyscripts/views/screens/messages/components/group_chat_members_options_model.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:nb_utils/nb_utils.dart';

class GroupChatMemberCard extends StatefulWidget {
  final GroupChatMemberModel? groupMember;
  final bool admin;
  const GroupChatMemberCard({Key? key, required this.groupMember, required this.admin}) : super(key: key);

  @override
  State<GroupChatMemberCard> createState() => _GroupChatMemberCardState();
}

class _GroupChatMemberCardState extends State<GroupChatMemberCard> {

@override
  void initState() {
    
    super.initState();

    print("adminnnnnnnnnnn");
    print(widget.admin);
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    UserProfilePicture(
                        avatarRadius: 16,
                        profileURL: widget.groupMember?.user?.profilePic,
                        onTapNavigate: false,
                        slug: widget.groupMember?.user?.username),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: KSize.getHeight(context, 10)),
                          Row(
                            children: [
                              Expanded( 
                                child: UserName(
                                  name: "${widget.groupMember?.user?.firstName} ${widget.groupMember?.user?.lastName}",
                                  onTapNavigate: true,
                                  type: 'profile',
                                  slug: widget.groupMember?.user?.username,
                                  userId: widget.groupMember?.user?.id,
                                  overflowVisible: true,
                                  backgroundColor: KColor.transparent!,
                                  textStyle: KTextStyle.subtitle1.copyWith(fontSize: 18, color: KColor.black87, fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: KSize.getHeight(context, 7)),
                          Text(widget.groupMember?.role=="SUPER ADMIN" || widget.groupMember?.role=="ADMIN"?"Admin":"General Member"
                          , style: KTextStyle.subtitle2.copyWith(color: KColor.black87, fontWeight: FontWeight.normal)),
                        ],
                      ),
                    ),
                  ],
                ), 
                SizedBox(height: KSize.getHeight(context, 12)),
              ],
            ),
          ),

           getIntAsync(USER_ID)==widget.groupMember?.userId?
          Text('You', style: KTextStyle.subtitle2.copyWith(color: KColor.black87)):
         !widget.admin?Container(): InkWell(
            onTap: () {
              _showOptionsModal(context,widget.groupMember);
            },
            child: Icon(
              Icons.more_horiz,
              color: KColor.black54,
            ),
          )
        ],
      ),
    );
  }

    void _showOptionsModal(context, member) {
    showPlatformModalSheet(
      context: context,
      material: MaterialModalSheetData(
        elevation: 5,
        isScrollControlled: true,
        useRootNavigator: true,
        isDismissible: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18)),
        ),
      ),
      builder: (_) => PlatformWidget(
        material: (_, __) => GroupChatMemberOptionsModal(member),
        cupertino: (_, __) => GroupChatMemberOptionsModal(member, isPlatformIos: true),
      ),
    );
   
  }
}
