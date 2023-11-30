import 'package:get/get.dart';
import 'package:mavunohub/logic/services/news_service.dart';
import 'package:mavunohub/models/news_model.dart';

class NewsController extends GetxController {
  final isLoading = true.obs;
  final newsModel = NewsModel(results: []).obs;

  @override
  void onInit() {
    super.onInit();
    loadNews();
  }

  loadNews() async {
    isLoading(true);
    final newsResponse = await NewsService().fetchNews();
    final news = NewsModel.fromJson(newsResponse);
    newsModel(news);
    isLoading(false);
  }
}

final newsController = Get.put(NewsController());

// In your widget, you can access the newsController as follows:
// NewsController controller = Get.find<NewsController>();
