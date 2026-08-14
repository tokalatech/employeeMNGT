enum PerformanceReviewStatus {
  completed,
  pendingReview,
}

class PerformanceReview {
  final String id;
  final String period;
  final double overallRating;
  final PerformanceReviewStatus status;
  final List<String> strengths;
  final List<String> areasForImprovement;
  final String managerFeedback;
  final String? employeeComments;
  final String reviewDate;

  PerformanceReview({
    required this.id,
    required this.period,
    required this.overallRating,
    required this.status,
    required this.strengths,
    required this.areasForImprovement,
    required this.managerFeedback,
    this.employeeComments,
    required this.reviewDate,
  });

  factory PerformanceReview.fromMap(Map<String, dynamic> map) {
    return PerformanceReview(
      id: map['id'] ?? '',
      period: map['period'] ?? '',
      overallRating: (map['overallRating'] ?? 0).toDouble(),
      status: map['status'] == 'Completed'
          ? PerformanceReviewStatus.completed
          : PerformanceReviewStatus.pendingReview,
      strengths: List<String>.from(map['strengths'] ?? []),
      areasForImprovement:
      List<String>.from(map['areasForImprovement'] ?? []),
      managerFeedback: map['managerFeedback'] ?? '',
      employeeComments: map['employeeComments'],
      reviewDate: map['reviewDate'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'period': period,
      'overallRating': overallRating,
      'status': status == PerformanceReviewStatus.completed
          ? 'Completed'
          : 'Pending Review',
      'strengths': strengths,
      'areasForImprovement': areasForImprovement,
      'managerFeedback': managerFeedback,
      'employeeComments': employeeComments,
      'reviewDate': reviewDate,
    };
  }
}