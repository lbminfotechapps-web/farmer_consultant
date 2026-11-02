import 'package:farmer_consultant/features/dashboard/data/home_model/success_story_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final key in [
    'crop_names',
    'fld_crop_names',
    'crop_name',
    'fld_crop_name',
  ]) {
    test('reads crop names from $key when canonical field is empty', () {
      final story = SuccessStoryItemModel.fromJson({
        'crop_names': '',
        key: 'Banana, Capsicum',
      });
      expect(story.cropNames, 'Banana, Capsicum');
      expect(
        SuccessStoryItemModel.fromJson(story.toJson()).cropNames,
        story.cropNames,
      );
    });
  }
  test('supports a list of names and missing crop data', () {
    expect(
      SuccessStoryItemModel.fromJson({
        'crop_names': ['Banana', 'Capsicum'],
      }).cropNames,
      'Banana, Capsicum',
    );
    expect(SuccessStoryItemModel.fromJson({}).cropNames, isEmpty);
  });
}
