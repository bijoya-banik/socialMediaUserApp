import 'package:buddyscripts/controller/group/group_controller.dart';
import 'package:buddyscripts/controller/search/search_controlller.dart';
import 'package:buddyscripts/controller/search/state/search_state.dart';
import 'package:buddyscripts/views/global_components/k_content_unavailable_component.dart';
import 'package:buddyscripts/views/global_components/loading_indicators/k_pages_loading_inidcator.dart';
import 'package:flutter/material.dart';
import 'package:buddyscripts/views/screens/account/components/group_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GroupSearchTab extends ConsumerWidget {
   const GroupSearchTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(searchProvider);
    return searchState is SearchSuccessState
        ? searchState.response.length == 0
            ? const KContentUnvailableComponent(message: 'No match found!', isSearch: true)
            : SingleChildScrollView(
                physics:const BouncingScrollPhysics(),
                child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    child: Wrap(
                      runSpacing: 15,
                      spacing: 15,
                      alignment: WrapAlignment.center,
                      children: List.generate(searchState.response.length, (index) {
                        return GroupCard(searchState.response[index], GroupType.DISCOVER);
                      }),
                    )),
              )
        : const KPagesLoadingIndicator();
  }
}
