

class API {
  //static const DIVINE9 = 'https://api.divine9connections.com/app/'; // Live Production API URL
  //static const DIVINE9 = 'http://192.168.175.224:3333/app/'; // Live Production API URL
static const DIVINE9 = 'http://10.0.2.2:3333/app/'; // Live Production API URL

//php artisan serve --host 192.168.42.100 --port 8000
//php artisan serve --host 192.168.41.224 --port 3333
//final String _url = 'http://192.168.42.100:8000';
//192.168.41.224
  //static const DIVINE9Socket = 'https://connect.divine9connections.com'; // Live Production API URL
  //static const DIVINE9Socket = 'http://127.0.0.1:3333'; 
   static const DIVINE9Socket = 'http://192.168.175.224:3300'; // Live Production API URL

  static const SOCKET_BASE = DIVINE9Socket;
  static const BASE =  DIVINE9;

  // auth
  static const login = 'auth/login';
  static const register = 'auth/signup';
  static const getUser = 'auth/getUser';
  static const logout = 'auth/logout';
  static const sendPasswordResetToken = 'auth/sendResetToken';
  static const verifyCode = 'auth/verifyCode';
  static const verifyEmail = 'auth/verifyEmail';
  static const passwordReset = 'auth/passwordReset';
  static const changePassword = 'settings/changePassword';
  static const changeEmail = 'settings/emailUpdate';
  static const verifyUpdateEmail = 'settings/emailVerify';
  static const sendResetToken = 'auth/sendResetToken';
  static const deleteAccount = 'auth/deleteAccount';
  static const updateFriendReq = 'profile/resetFriend';
  static const profileSettingDefaultFeedUpdate = 'settings/profileSettingDefaultFeedUpdate';
  static const fetchOnline = 'profile/update_last_active_time';
  static const fetchSeen = 'chatting/updateSeen';

  // country list
  static const countryList = 'auth/getCountry';

  // feed
  static const createFeed = 'feed/createFeed';
  static const updateFeed = 'feed/updateFeed';
  static const deleteFeed = 'feed/deleteFeed';
  static const deleteStoryFeed = 'feed/deleteStoryFeed';
  static const hideFeed = 'feed/hidePost';
  static const worldFeed = 'feed/getFeed?feed_type=world';
  static const personalFeed = 'feed/getFeed?feed_type=friends';
  static const statusShare = 'feed/getFeed?feed_type=friends';

  static feedDetails(int id) => 'feed/getSingleFeed/$id';
  static const reportFeed = 'feed/createReport';
  static const saveFeed = 'feed/saveFeedforUser';
  static const unsaveFeed = 'feed/unsaveFeedforUser';
  static const getLinkPreview = 'feed/getLinkPreview';

  /// reactions
  static feedReactedUsers(feedId, {reactionType = 'all', lastId = ''}) => 'feed/getReactedPeople?id=$feedId&reaction=$reactionType&more=$lastId';
  static feedReactionTypes(feedId) => 'feed/getAllReactionType?id=$feedId';

  // feeling
  static const getFeelings = 'feed/getFellings';
  static const getActivities = 'feed/getActivities';
  static getSubActivities({dynamic id = ""}) => 'feed/getSubActivities?id=$id';
  static feelingActivitysearch({String type = "", String str = ""}) => 'feed/searchForFeelings?type=$type&str=$str';
  static feelingSubActivitysearch({String str = "", dynamic id = ""}) => 'feed/searchForSubActivities?str=$str&id=$id';

  //search
  static search(String str, {String tab = 'feed'}) => 'group/globalSearch?str=$str&tab=$tab';

  // like
  static const likeFeed = 'feed/createLike';

  /// poll
  static const addPollOption = 'polloption/addPollOption';
  static const deletePollOption = 'polloption/closeOption';
  static const addVoteOption = 'voteoption/addVoteOption';
  static pollOptionVoters({pollId, optionId, lastId = ''}) => 'voteoption/getVotedPeople?poll_id=$pollId&option_id=$optionId&more=$lastId';

  // feed comments/comment replies
  static feedComments(int id, {lastId}) => 'comment/getComment/$id?more=$lastId';

  static feedCommentReplies(int id, {int? lastId}) => 'comment/getReply/$id?more=$lastId';
  static const createComment = 'comment/createComment';
  static const updateComment = 'comment/editComment';
  static const deleteComment = 'comment/deleteComment';

  // comment react
  static const likeComment = 'comment/likeComment';
  static commentReactedUsers(commentId, {reactionType = "", lastId = ""}) =>
      'comment/getReactedPeople?id=$commentId&reaction=$reactionType&more=$lastId';
  static commentReactionTypes(commentId) => 'comment/getAllReactionType?id=$commentId';

  /// conversations
  static const conversations = 'chatting/getInbox';
  static const deleteConversation = 'chatting/deleteFullConvers';
  static const seenConversation = 'chatting/seenMsg';
  static const unseenConversation = 'chatting/unSeenMsg';
  static const chat = 'chatting/getChatLists?isApp=1';
  static const sendMessage = 'chatting/insertChat';
  static const deleteMessage = 'chatting/deleteSingleMsg';
  static const chatFriends = 'profile/getFriendListsForChat?limit=20';
  static const memberSearchForCreateGroupChat = 'profile/getFriendListsBySearch';
  static conversationSearch(str) => 'profile/getPeopleListBySearch?str=$str';
  static conversationGroupPeopleSearch(str) => 'chatting/getInboxGlobalSearch?str=$str';

  /// group Chat
  static const createGroupChat = 'chatting/createGroup';
  static const makeChatAdmin = 'chatting/makeAdmin';
  static const removeChatAdminRole = 'chatting/removeAdminRole';
  static const removeChatMember = 'chatting/removeMember';
  static const addNewChatMember = 'chatting/addNewChatMember';
  static const updateGroupChatInfo = 'chatting/updateGroupInfo';
  static const leaveChatGroup = 'chatting/leaveGroup';
  static const deleteChatGroup = 'chatting/deleteGroup';
  static const muteChat = 'chatting/muteNoti';
  static const unmuteChat = 'chatting/unmuteNoti';
  static getAllChatMembers(id) => 'chatting/getAllmember?inbox_id=$id';
  static getAllChatAdmins(id) => 'chatting/getAlladmin?inbox_id=$id';
  static searchForGroupMember({String str = "", int? id}) => 'chatting/searchForGroupMember?str=$str&id=$id';

  /// story
  static const getStory = 'feed/getStoryFeed';
  static const getAllStory = 'feed/getAllstoryWithDetails';

  /// notifications
  static const notifications = 'profile/getNotification';
  static const markNotificationSeen = 'profile/seenNoti';
  static const markNotificationUnSeen = 'profile/unSeenNoti';
  static const deleteNotification = 'profile/deleteNoti';

  // profile
  static profileDetails(String userName, {int? lastId, String tab = 'feed'}) => 'profile/getProfile?tab=$tab&user=$userName&more=$lastId';
  static const updateBasicProfile = 'profile/saveName';
  static const updateUserPic = 'profile/uploadUserPic';

  // page
  static pageDetails(String pageName, {int? lastId, String tab = 'feed'}) => 'page/getPageDetails?tab=$tab&user=$pageName&more=$lastId';
  static pages({String tab = "", int page = 1}) => 'page/getAllPage?tab=$tab&limit=20&page=$page';
  static const pageCategory = 'page/getCategory';
  static const createPage = 'page/addPage';
  static const editPage = 'page/editPage';
  static const deletePage = 'page/deletePage?';
  static const followUnfollowPage = 'page/followPage';
  static const updatePagePic = 'page/uploadPagePic';

  // group
  static groups({String tab = "", int page = 1}) => 'group/getGroupList?tab=$tab&limit=20&page=$page';
  static groupDetails(String groupName, {lastId, String tab = 'feed'}) => 'group/getSingleGroup?tab=$tab&slug=$groupName&more=$lastId';
  static groupPendingMember({dynamic grpId = ""}) => 'group/allRequest?group_id=$grpId';
  static const acceptMember = 'group/approveJoinRequest';
  static const deleteMember = 'group/cancelRequest';
  static const groupCategory = 'group/getCategory';
  static const createGroup = 'group/storeGroup';

  static const editGroup = 'group/updateGroup';
  static const deleteGroup = 'group/deleteGroup';
  static const joinGroup = 'group/joinGroup';
  static const leaveGroup = 'group/leaveGroup';
  static const cancelRequest = 'group/cancelRequest';
  static const updateGroupPic = 'group/uploadGroupPic';
  static const inviteMemberToGroup = 'group/addMember';
  static const removeMember = 'group/removeGroup';
  static const makeAdmin = 'group/makeAdmin';
  static const removeAdmin = 'group/removeAdminRole';
  static invitedMemberListGroup(int groupId) => 'group/getFriendNotGroupMember?group_id=$groupId';
  static searchMemberGroup(int groupId, String search) => 'group/getSearchFriend?str=$search&group_id=$groupId';

  /// event
  static const createEvent = 'event/createEvent';
  static const editEvent = 'event/editEvent';
  static eventDetails(String eventName, {lastId, String tab = 'feed'}) => 'event/getEventDetails?tab=$tab&event=$eventName&more=$lastId';
  static events({String tab = "", int page = 1}) => 'event/getAllEvent?tab=$tab&limit=20&page=$page';
  static const searchMember = 'event/searchInviteMember';
  static const addMember = 'event/addMember';
  static const updateEventPic = 'event/uploadEventPic';
  static const acceptInvite = 'event/goingInterested';
  static const deleteEvent = 'event/deleteEvent';

  // saved posts
  static savedPosts({int page = 1}) => 'group/getSavedPagebyLimit?page=$page';
  //static savedPosts({dynamic lastId=""}) => 'feed/getFeed?more=$lastId&feed_type=savePost';

  // friends
  static friendRequests({int page = 1}) => 'profile/getFriendRequests?page=$page';
  static allFriends({int page = 1}) => 'profile/getFriendListsForChat?page=$page';
  static friendSuggestions({int page = 1}) => 'profile/peopleList?page=$page';
  static const deleteFriendRequest = 'profile/deleteRequest';
  static const friendRequest = 'profile/friendRequest';

  /// block user
  static blockUser({int page = 1}) => 'profile/blockedPeopleList?page=$page';
  static const block = 'profile/blockUser';
  static const unblock = 'profile/unBlockUser';

  /// Upload MEDIA
  static const uploadImages = 'upload/uploadImages1';
  static const mediaUpload = 'multipleImageUpload';

  /// Courses
  static const allCourses = 'course/get/allCourseType';
  static const allCourseTypeCount = 'course/get/allCourseTypeCount';
  static course(id) => 'course/get/details/$id';
  static courseByCategory({categoryName, limit = 10}) => 'course/get/$categoryName?limit=$limit';

  /// Payment
  static const payment = 'course/payment/app';

  ///blog
  static const popularblog = 'blog/get/populer';
  static recentblog({int page = 1}) => 'blog/get/recent?page=$page';
}
