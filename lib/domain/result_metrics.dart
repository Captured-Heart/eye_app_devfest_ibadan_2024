enum DiagnosisLevel {
  level0(
    '0',
    'No DR',
    'No abnormalities',
    '12 - 24 months',
  ),
  level1(
    '1',
    'Mild NPDR',
    'Microaneurysms only',
    '9 - 12 months',
  ),
  level2(
    '2',
    'Moderate NPDR',
    '''At least 1 haemorrhage/Microaneursyms and/or at least 1 of the following: \n-Retinal haemorrhage\n-Hard exudates\n-Cotton wool spots\n-Venous beading''',
    '6 months',
  ),
  level3(
    '3',
    'Severe NPDR',
    'Any of the following: \n1. More than 20 intraretinal haemorrhages in each of 4 quadrants\n2. Definite venous beading in 2 or more quadrants\n3. Prominent intraretinal microvascular abnormalities in 1 or more quadrants AND no signs of proliferative retinopathy',
    'refer to the Opthalmologist',
  ),
  level4(
    '4',
    'Proliferative DR',
    'One of the following: \n1.Neovascularisation\n2. Vitreous/preretinal haemorrhage',
    'Refer urgently to Opthalmologist',
  ),
  levelUNKNOWN('5', 'Unknown', 'Unknown', 'Unknown');

  const DiagnosisLevel(
    this.level,
    this.stage,
    this.descriptions,
    this.followUp,
  );
  final String level;
  final String stage;
  final String descriptions;
  final String followUp;

  String get toMap =>
      'level: $level, stage: $stage, description: $descriptions, followUp: $followUp';
  static DiagnosisLevel labeltext(String level) {
    return DiagnosisLevel.values.firstWhere(
      (element) => level == element.level,
      orElse: () => DiagnosisLevel.levelUNKNOWN,
    );
  }
}
