import 'package:auto_route/auto_route_annotations.dart';
import 'package:webblen_web_app/ui/views/auth/auth_view.dart';
import 'package:webblen_web_app/ui/views/root/root_view.dart';

///RUN "flutter pub run build_runner build --delete-conflicting-outputs" in Project Terminal to Generate Routes

@MaterialAutoRouter(
  routes: <AutoRoute>[
    // initial route is named "/"
    MaterialRoute(page: RootView, initial: true, name: "RootViewRoute", path: "/"),

    //AUTHENTICATION
    MaterialRoute(page: AuthView, name: "AuthViewRoute", path: "/auth"),

    //ONBOARDING
    // MaterialRoute(page: OnboardingView, name: "OnboardingViewRoute"),

    //POST
    //MaterialRoute(page: PostView, name: "PostViewRoute"),
    //MaterialRoute(page: CreatePostView, name: "CreatePostViewRoute"),
    //SEARCH
    //MaterialRoute(page: SearchView, name: "SearchViewRoute"),
    //MaterialRoute(page: AllSearchResultsView, name: "AllSearchResultsViewRoute"),

    //NOTIFICATIONS
    //MaterialRoute(page: NotificationsView, name: "NotificationsViewRoute"),

    //SETTINGS
    // MaterialRoute(page: SettingsView, name: "SettingsViewRoute"),
  ],
)
class $WebblenRouter {}
