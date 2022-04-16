part of quran;

class TajweedRules {
  const TajweedRules._();
  static const List<TajweedRule> ids = [
    TajweedRule._('[h', Color(0xffAAAAAA), 'hamza_wasl'),
    TajweedRule._('[s', Color(0xffAAAAAA), 'silent'),
    TajweedRule._('[l', Color(0xffAAAAAA), 'laam_shamsiyah'),
    TajweedRule._('[n', Color(0xff537FFF), 'madda_normal'),
    TajweedRule._('[p', Color(0xff4050FF), 'madda_permissible'),
    TajweedRule._('[m', Color(0xff000EBC), 'madda_necessary'),
    TajweedRule._('[q', Color(0xffDD0008), 'qalaqah'),
    TajweedRule._('[o', Color(0xffDD0008), 'madda_obligatory'),
    TajweedRule._('[c', Color(0xffD500B7), 'ikhafa_shafawi'),
    TajweedRule._('[f', Color(0xff9400A8), 'ikhafa'),
    TajweedRule._('[w', Color(0xff58B800), 'idgham_shafawi'),
    TajweedRule._('[i', Color(0xff26BFFD), 'iqlab'),
    TajweedRule._('[a', Color(0xff169777), 'idgham_with_ghunnah'),
    TajweedRule._('[u', Color(0xff169200), 'idgham_without_ghunnah'),
    TajweedRule._('[d', Color(0xffA1A1A1), 'idgham_mutajanisayn'),
    TajweedRule._('[b', Color(0xffA1A1A1), 'idgham_mutaqaribayn'),
    TajweedRule._('[g', Color(0xffFF7E1E), 'ghunnah'),
  ];
}

class TajweedRule {
  final String id;
  final Color color;
  final String nameIdentifier;

  const TajweedRule._(this.id, this.color, this.nameIdentifier);
}
