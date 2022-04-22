part of quran;

/// Sole method class that's splits [Ayah] text into [List<TextSpan>].
class AyahTajweedSplitter {
  /// Splits the  [Ayah.text] and returns [List<TextSpan>] compined represents
  /// the respective ayah script, colored with the tajweed rules
  ///
  /// Coloring and identifying the tajweed rules comes for specific [Edition]
  /// and The rules are stored at [TajweedRule.id].
  ///
  /// Thus added as plane spans or colored spans will not modify any other
  /// property from the [TextStyle] besides the color
  ///
  /// throws [StateError] if it found an unsupported id
  ///
  /// source [Alquran Cloud: Tajweed Guide](https://alquran.cloud/tajweed-guide)
  static List<TextSpan> formatAyah(Ayah ayah) {
    // The spans list
    final List<TextSpan> spans = <TextSpan>[];
    // The ayah text to reduce access
    final String text = ayah.text;
    // Starts from zero the in the do while loop it progresses
    int index = 0;
    // The loop algorithem loops for each `[` in the string which is not
    // mentioned in the quran but are used to mark each letter (that needs)
    // with it's specific tajweed guide line
    do {
      // The new index stored a side to not conflict in the next splitting
      int newIndex = text.indexOf('[', index);
      // If there is nothing left (or nothing at all)
      if (newIndex == -1) {
        // New plane span
        spans.add(TextSpan(text: text.substring(index)));
      } else {
        // Add the preceduer as plane
        spans.add(TextSpan(text: text.substring(index, newIndex)));
        // Using try/catch cause the letter may be in bracket without a rule arrounde it
        //
        //
        // This exception by far happend only for one Ayah :
        // Edition = quran-tajweed
        // Surah : Al-Sajda
        // Ayah's number in surah = 3
        // Exracting the [TajweedRule] id
        final String id = text.substring(newIndex, newIndex + 2);
        final String letterToPatch = text.substring(
          text.indexOf('[', newIndex + 1) + 1,
          text.indexOf(']', newIndex),
        );

        try {
          // Respected tajweed rule from the id
          final TajweedRule rule = TajweedRule.rules
              .singleWhere((TajweedRule element) => element.id == id);
          // Adding the extracted letter with the [TajweedRule] color
          spans.add(
            TextSpan(
              text: letterToPatch,
              style: TextStyle(color: rule.color),
            ),
          );
        } catch (e) {
          // If the tajweed rule not found then just skip it and
          // add it as normal text
          spans.add(
            TextSpan(
              text: String.fromCharCode(
                // The letter index
                text.codeUnitAt(text.indexOf(']', newIndex) - 1),
              ),
            ),
          );
        }
        // start the new loop from the end of the patched letter
        newIndex = text.indexOf(']', newIndex);
      }
      // if the index pointing to the end do nothing else add 1 to
      // start from the next position
      index = newIndex + (newIndex == -1 ? 0 : 1);
    } while (index != -1);
    return spans;
  }
}
