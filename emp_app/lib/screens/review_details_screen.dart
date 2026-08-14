import 'flow_detail_screen.dart';

class ReviewDetailsScreen extends FlowDetailScreen {
  const ReviewDetailsScreen({super.key})
    : super(
        title: 'Performance Review',
        subtitle: 'H1 2026 review',
        sections: const [
          ('Overall rating', '4.8 / 5.0'),
          ('Strengths', 'Mobile-first architecture and collaboration'),
          ('Development focus', 'Expand field-user testing'),
        ],
      );
}
