import 'package:buddyscripts/constants/shared_preference_constant.dart';
import 'package:buddyscripts/controller/page/discover_pages_controller.dart';
import 'package:buddyscripts/controller/page/followed_pages_controller.dart';
import 'package:buddyscripts/controller/page/my_pages_controller.dart';
import 'package:buddyscripts/controller/page/page_feed_controller.dart';
import 'package:buddyscripts/controller/page/state/page_state.dart';
import 'package:buddyscripts/models/feed/feed_model.dart';
import 'package:buddyscripts/models/page/page_feed_model.dart';
import 'package:buddyscripts/models/page/pages_model.dart';
import 'package:buddyscripts/network/api.dart';
import 'package:buddyscripts/network/network_utils.dart';
import 'package:buddyscripts/services/navigation_service.dart';
import 'package:buddyscripts/views/global_components/dialogs/k_dialog.dart';
import 'package:buddyscripts/views/global_components/dialogs/processing_dialog_content.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';

final pageProvider = StateNotifierProvider<PageController,PageState>(
  (ref) => PageController(ref: ref),
);

class PageController extends StateNotifier<PageState> {
  final Ref? ref;
  PageController({this.ref}) : super(const PageInitialState());

  Future createPage({pageName, categoryName, description, website, phone, email}) async {
    String websitePattern =
        r'^((?:.|\n)*?)((http:\/\/www\.|https:\/\/www\.|)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?)';
    RegExp regExpWebsite = RegExp(websitePattern);
    String emailPattern = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regExpEmail = RegExp(emailPattern);

    if (categoryName == "" || categoryName == "Select Category") {
      toast("Please select category", bgColor: KColor.red);
    } else if (!(regExpEmail.hasMatch(email)) && email.isNotEmpty) {
      toast("Please enter valid email", bgColor: KColor.red);
    } else if (!(regExpWebsite.hasMatch(website)) && website.isNotEmpty) {
      toast("Please enter valid url", bgColor: KColor.red);
    } else {
      state = const PageLoadingState();

      dynamic responseBody;
      var requestBody = {
        'page_name': pageName,
        'category_name': categoryName,
        'website': website,
        'phone': phone,
        'email': email,
        'about': description,
        'user_id': getIntAsync(USER_ID),
      };

      try {
        responseBody = await Network.handleResponse(await Network.postRequest(API.createPage, requestBody, requireToken: true));

        if (responseBody != null) {
          state = const CreatePageSuccessState();
          PageDatum pageModelInstance = PageDatum.fromJson(responseBody);
          PagesModel pageList = ref!.read(myPagesProvider.notifier).myPagesModel!;
          pageList.data!.insert(0, pageModelInstance);
          ref!.read(myPagesProvider.notifier).updateSuccessState(pageList);
          toast("Page created succussfully", bgColor: KColor.green);
          NavigationService.popNavigate();
        } else {
          state = const CreatePageErrorState();
        }
      } catch (error, stackTrace) {
        print(error);
        print(stackTrace);
        state = const CreatePageErrorState();
      }
    }
  }

  Future uploadPagePicture({image, type = 'profile_pic', pageId}) async {
    dynamic responseBody;

    Map<String, String> requestBody = {'uploadType': type, 'page_id': pageId.toString()};
    try {
      KDialog.kShowDialog(
        NavigationService.navigatorKey.currentContext,
        const ProcessingDialogContent("Uploading..."),
        barrierDismissible: false,
      );
      responseBody = await Network.handleResponse(
        await Network.multiPartRequest(API.updatePagePic, 'POST', body: requestBody, files: image, filedName: 'file'),
      );
      if (responseBody != null) {
        BasicOverView basicOverViewInstance = ref!.read(pageFeedProvider.notifier).pageFeedList!.basicOverView!;
        if (type == 'profile_pic') {
          basicOverViewInstance.profilePic = responseBody['picture'];
        } else {
          basicOverViewInstance.cover = responseBody['picture'];
        }

        ref!.read(pageFeedProvider.notifier).updatePageDetails(basicOverViewInstance);
        NavigationService.popNavigate();
      } else {
        state = const PageErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const PageErrorState();
    }
  }

  Future editPage({pageData, pageName, categoryName, shortDescription, about, website, phone, email, country, city, address}) async {
    String websitePattern =
        r'^((?:.|\n)*?)((http:\/\/www\.|https:\/\/www\.|)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?)';
    RegExp regExpWebsite = RegExp(websitePattern);
    String emailPattern = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regExpEmail = RegExp(emailPattern);
    if (categoryName == "" || categoryName == "Select Category") {
      toast("Please select category", bgColor: KColor.red);
    } else if (!(regExpEmail.hasMatch(email)) && email.isNotEmpty) {
      toast("Plesae enter valid email", bgColor: KColor.red);
    } else if (!(regExpWebsite.hasMatch(website)) && website.isNotEmpty) {
      toast("Plesae enter valid url", bgColor: KColor.red);
    } else {
      state = const PageLoadingState();

      dynamic responseBody;
      var requestBody = {
        'id': pageData.id,
        'page_name': pageName,
        'category_name': categoryName,
        'about': about,
        'user_id': getIntAsync(USER_ID),
        'website': website,
        'phone': phone,
        'email': email,
        // 'country': country,
        // 'city': city,
        // 'page_title':shortDescription,
        'address': address,
      };

      try {
        responseBody = await Network.handleResponse(await Network.postRequest(API.editPage, requestBody, requireToken: true));

        if (responseBody != null) {
          state = const EditPageSuccessState();

          BasicOverView pageOverview = ref!.read(pageFeedProvider.notifier).pageFeedList!.basicOverView!;
          var response = BasicOverView.fromJson(responseBody);
          pageOverview.pageName = pageName;
          pageOverview.slug = response.slug;
          pageOverview.about = about;
          //  pageOverview.pageTitle = shortDescription;
          pageOverview.categoryName = categoryName;
          pageOverview.website = website;
          pageOverview.phone = phone;
          pageOverview.email = email;
          // pageOverview.country = country;
          // pageOverview.city = city;
          pageOverview.address = address;
          ref!.read(pageFeedProvider.notifier).updatePageDetails(pageOverview);

          final List<FeedModel> pageFeedList = ref!.read(pageFeedProvider.notifier).pageFeedList!.feedData!;
          for (var element in pageFeedList) {
            element.name = response.pageName;
          }
          ref!.read(pageFeedProvider.notifier).updateSuccessState(pageFeedList);

          PagesModel? pageList = ref!.read(myPagesProvider.notifier).myPagesModel;
          pageList!.data![pageList.data!.indexWhere((element) => element.id == pageData.id)].pageName = pageName;
          pageList.data![pageList.data!.indexWhere((element) => element.id == pageData.id)].slug = response.slug;
          ref!.read(myPagesProvider.notifier).updateSuccessState(pageList);
          toast("Page updated succussfully", bgColor: KColor.green);
          NavigationService.popNavigate();
        } else {
          state = const EditPageErrorState();
        }
      } catch (error, stackTrace) {
        print(error);
        print(stackTrace);
        state = const EditPageErrorState();
      }
    }
  }

  Future followPage(pageId) async {
    state = const PageLoadingState();
    dynamic responseBody;

    var requestBody = {'page_id': pageId, 'user_id': getIntAsync(USER_ID), 'follow': true};

    try {
      responseBody = await Network.handleResponse(await Network.postRequest(API.followUnfollowPage, requestBody));

      if (responseBody != null) {
        state = const FollowPageSuccessState();

        PagesModel? discoverPagesModel = ref!.read(discoverPagesProvider.notifier).discoverPagesModel;
        if (discoverPagesModel != null) discoverPagesModel.data!.removeWhere((element) => element.id == pageId);

        ref!.read(discoverPagesProvider.notifier).updateSuccessState(discoverPagesModel!);

        PagesModel? followedPagesModel = ref!.read(followedPagesProvider.notifier).followedPagesModel;
        PageDatum pageModelInstance = PageDatum.fromJson(responseBody);
        if (followedPagesModel != null) followedPagesModel.data!.insert(0, pageModelInstance);
        ref!.read(followedPagesProvider.notifier).updateSuccessState(followedPagesModel!);

        BasicOverView pageBasicOverview = BasicOverView.fromJson(responseBody);
        ref!.read(pageFeedProvider.notifier).updatePageDetails(pageBasicOverview);
      } else {
        state = const FollowPageErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const FollowPageErrorState();
    }
  }

  Future unfollowPage(pageId) async {
    state = const PageLoadingState();
    dynamic responseBody;

    var requestBody = {'page_id': pageId, 'user_id': getIntAsync(USER_ID), 'follow': false};

    try {
      responseBody = await Network.handleResponse(await Network.postRequest(API.followUnfollowPage, requestBody));

      if (responseBody != null) {
        state = const UnfollowPageSuccessState();
        PagesModel? followedPagesModel = ref!.read(followedPagesProvider.notifier).followedPagesModel;
        if (followedPagesModel != null) followedPagesModel.data!.removeWhere((element) => element.id == pageId);
        ref!.read(followedPagesProvider.notifier).updateSuccessState(followedPagesModel!);

        PagesModel? discoverPagesModel = ref!.read(discoverPagesProvider.notifier).discoverPagesModel;
        PageDatum pageModelInstance = PageDatum.fromJson(responseBody);
        if (discoverPagesModel != null) discoverPagesModel.data!.insert(0, pageModelInstance);
        ref!.read(discoverPagesProvider.notifier).updateSuccessState(discoverPagesModel!);
        BasicOverView pageBasicOverview = BasicOverView.fromJson(responseBody);
        ref!.read(pageFeedProvider.notifier).updatePageDetails(pageBasicOverview);
      } else {
        state = const UnfollowPageErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const UnfollowPageErrorState();
    }
  }

  Future deletePage(int pageId) async {
    dynamic responseBody;

    var requestBody = {'page_id': pageId};

    try {
      responseBody = await Network.handleResponse(await Network.postRequest(API.deletePage, requestBody));

      if (responseBody != null) {
        PagesModel pageList = ref!.read(myPagesProvider.notifier).myPagesModel!;
        pageList.data!.removeWhere((element) => element.id == pageId);
        NavigationService.popNavigate();

        ref!.read(myPagesProvider.notifier).updateSuccessState(pageList);
      } else {
        state = const DeletePageErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const DeletePageErrorState();
    }
  }
}
