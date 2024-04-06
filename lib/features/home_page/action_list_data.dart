class ActionListData {
  ActionListData({
    this.imagePath = '',
    this.titleTxt = '',
    this.startColor = '',
    this.endColor = '',
    this.actions,
  });

  String imagePath;
  String titleTxt;
  String startColor;
  String endColor;
  List<String>? actions;

  static List<ActionListData> tabIconsList = <ActionListData>[
    ActionListData(
      imagePath: 'assets/fitness_app/recycle.png',
      titleTxt: 'Recycle',
      actions: <String>['Products,', 'RetuRO'],
      startColor: '#94A885',
      endColor: '#72B794',
    ),
    ActionListData(
      imagePath: 'assets/fitness_app/lunch.png',
      titleTxt: 'Lunch',
      actions: <String>['Salmon,', 'Veggies,', 'Avocado'],
      startColor: '#738AE6',
      endColor: '#5C5EDD',
    ),
    ActionListData(
      imagePath: 'assets/fitness_app/snack.png',
      titleTxt: 'Snack',
      actions: <String>['Recommend:', '800 kcal'],
      startColor: '#FE95B6',
      endColor: '#FF5287',
    ),
    ActionListData(
      imagePath: 'assets/fitness_app/dinner.png',
      titleTxt: 'Dinner',
      actions: <String>['Recommend:', '703 kcal'],
      startColor: '#6F72CA',
      endColor: '#1E1466',
    ),
  ];
}
