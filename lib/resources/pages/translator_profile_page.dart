import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/services/auth_service.dart';
import 'package:flutter_app/app/services/location_service.dart';
import 'package:flutter_app/resources/extensions/dynamic_size_extension.dart';
import 'package:flutter_app/resources/extensions/padding_extension.dart';
import 'package:flutter_app/resources/widgets/safearea_widget.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/models/languages.dart';
import '../themes/styles/light_theme_colors.dart';
import '../widgets/atoms/custom_selectable_tile.dart';
import '../widgets/molecules/main_scaffold.dart';
import '../widgets/molecules/contact_us_card.dart';

class TranslatorProfilePage extends NyStatefulWidget {
  static final String path = "/translator-profile";
  TranslatorProfilePage({super.key});

  @override
  State<TranslatorProfilePage> createState() => _TranslatorProfilePageState();
}

class _TranslatorProfilePageState extends NyState<TranslatorProfilePage> {
  @override
  init() async {
    if (kIsWeb) {
      await LocationService().updateLocation();
    }
  }

  @override
  Widget build(BuildContext context) {
    final translator = AuthService().currentTranslator;

    return MainScaffold(
      selectedTabIndex: 1,
      body: SafeAreaWidget(
        child: ListView(
          physics: BouncingScrollPhysics(),
          padding: context.veryLowSymPadding,
          children: [
            Text(
              "yourProfile".tr(),
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .displayMedium!
                  .copyWith(color: LightThemeColors().title),
            ),
            getSpacer,
            Linkify(
              onOpen: (link) => routeTo("/translator-list"),
              textAlign: TextAlign.center,
              text: "yourProfileDescription".tr(),
              linkStyle: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.none,
              ),
            ),
            getSpacer,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "nameSurname".tr(),
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                SizedBox(height: 8),
                Text(
                  translator.name,
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            getSpacer,
            Text(
              "supportChannels".tr(),
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            CustomSelectableTile(
              isSelected: translator.capabilities?.translatorInPerson ?? false,
              onSelectStateChanged: (value) {},
              titleText: "onsiteSupport".tr(),
            ),
            CustomSelectableTile(
              isSelected: translator.capabilities?.translatorVirtual ?? false,
              onSelectStateChanged: (value) {},
              titleText: "onlineSupport".tr(),
            ),
            getSpacer,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "availableSupport".tr(),
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                SizedBox(height: 8),
                Text(
                  translator.languages
                      .map((l) => Languages.usableLanguages
                          .firstWhere((e) => e.key == l)
                          .value)
                      .join(", "),
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            getSpacer,
            _socialMediaItem(
              icon: MdiIcons.facebook,
              title: "facebook".tr(),
              link: translator.contact?.facebook,
            ),
            getSpacer,
            _socialMediaItem(
              icon: MdiIcons.instagram,
              title: "instagram".tr(),
              link: translator.contact?.instagram,
            ),
            getSpacer,
            _socialMediaItem(
              icon: MdiIcons.twitter,
              title: "twitter".tr(),
              link: translator.contact?.twitter,
            ),
            getSpacer,
            _socialMediaItem(
              icon: MdiIcons.linkedin,
              title: "linkedin".tr(),
              link: translator.contact?.linkedin,
            ),
            getSpacer,
            ContactUsCard(
              title: "cantFind".tr(),
              description: "reachSupport".tr(),
              buttonText: "contactUsButton".tr(),
              onPressed: () => {},
            )
          ],
        ),
      ),
    );
  }

  Widget _socialMediaItem(
      {required String title, required IconData icon, String? link}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 24),
            getSpacer,
            Text(title, style: TextStyle(fontWeight: FontWeight.w800)),
          ],
        ),
        SizedBox(height: 4),
        link == null
            ? Text("-")
            : Linkify(
                text: link,
                linkStyle: TextStyle(color: Colors.grey),
                options: LinkifyOptions(humanize: false),
                onOpen: (link) async {
                  var uri = Uri.parse(link.url);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                  }
                },
              ),
      ],
    );
  }

  Widget get getSpacer => SizedBox(height: context.veryLowHeight);
}
