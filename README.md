[![style: very good analysis](https://img.shields.io/badge/style-very_good_analysis-B22C89.svg)](https://pub.dev/packages/very_good_analysis)
![Discord](https://img.shields.io/discord/969791294035611740?label=chat&logo=discord&logoColor=white)
![Maintainer](https://img.shields.io/badge/maintainer-Yousuf.M.Hammad-blue)
[![made-for-VSCode](https://img.shields.io/badge/Made%20with-VSCode-1f425f.svg)](https://code.visualstudio.com/)
[![GitHub license](https://img.shields.io/github/license/Naereen/StrapDown.js.svg)](https://github.com/spark-gazzers/islamy/blob/master/LICENSE)
[![Github all releases](https://img.shields.io/github/downloads/spark-gazzers/islamy/total.svg)](https://github.com/spark-gazzers/islamy/releases/)


# **iSlamy**

    وَمَا رَمَيْتَ إِذْ رَمَيْتَ وَلَٰكِنَّ اللَّهَ رَمَىٰ


iSlamy is a new islamic project that aims to provide the holy Quran in every language and any other resources muslims world wide would need.
# Table of contents
- [**iSlamy**](#--islamy--)
- [Table of contents](#table-of-contents)
- [Getting Started](#getting-started)
  * [Building](#building)
- [Community](#community)
- [Design](#design)
- [Architecture & Layout](#architecture---layout)
  * [**Project files layout**](#--project-files-layout--)
    + [**Services**](#--services--)
    + [**UI**](#--ui--)
      - [**`Common` Directory**](#---common--directory--)
    + [**Localizations**](#--localizations--)
    + [**Generated Files**](#--generated-files--)
    + [**Utils**](#--utils--)
    + [`Routes.dart`](#-routesdart-)
    + [`Helper.dart`](#-helperdart-)
  * [**Device Caches**](#--device-caches--)
- [Contribution & Donations](#contribution---donations)
  * [Contribution](#contribution)
  * [Donations](#donations)
- [Credits](#credits)
- [License](#license)

<small><i><a href='http://ecotrust-canada.github.io/markdown-toc/'>Table of contents generated with markdown-toc</a></i></small>

# Getting Started

## Building
This project require having flutter, [flutter installation guide.](https://docs.flutter.dev/get-started/install)

This project uses `source_gen` and `build_runner` through `hive_generator` and `int_utils`, so in order to run this project after cloning the repo you need to :

- `flutter pub get`


- `flutter pub run intl_utils:generate` or to automate building the localization you can install the [Flutter Intl VS-Code Extension](https://marketplace.visualstudio.com/items?itemName=localizely.flutter-intl) or the appropriate delegate of your IDE.


- `flutter pub run build_runner build` or to automate building the hive `TypeAdapter` you can install the [Build Runner Extension](https://marketplace.visualstudio.com/items?itemName=GaetSchwartz.build-runner) or the appropriate delegate of your IDE.

-   Finally run the project using `flutter run` on any of the supported platform.

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# Community

We are currently on the proccess of creating this community where anyone can help or creticize the project.

Though this readme is written in english the community should support any language.

Any kind of discussion about the project goes in the [iSlamy server.](https://discord.gg/G9RzbGtf4D)

# Design

An XD project was started that started the intiative done By **Omar Yassir** [here](https://xd.adobe.com/view/da13a2ab-147b-4852-8f44-3b923240addd-8f40/grid) but due to rapid changes in the idea the project adapted the theme but the results may vary mildly from the design.

Since The design is outdated I'd really appreciate designers collaboration and criticism on the result l&f. 
# Architecture & Layout

## **Project files layout**

### **Services**
The project main services/engines each have a top level directory which should be modular since the next step of this project development is to seperate each library into it's own Dart/Flutter project.

For example: `quran` which is a Dart language `library` has it's own logic layer and caching strategy which can be found at `lib/quran/`.

The Quran library is responsible of communicating with [alquran cloud server](https://alquran.cloud/), caching repeated requests load, downloading and proccessing ayahs adui files and formatting the quran for tajweed.

### **UI**

All of the UI related files can be found under `lib/view` where evey section in the app will have it's own directory. Inside the screen directory you may find another directory called `screens` or `widgets` depending on the file itself.

-   The `screens` directory should contain the screens related to this section (if any) but the routing management goes to [`Rotes` class.](#-routesdart-)

- The `widgets`  directory should contain the commonly used widgets related to this section (if any) but not commonly used cross-sections, those used alot in more than a section goes to [`lib/view/common/` Directory.](#---common--directory--)

#### **`Common` Directory**

The common directory contains files of widgets that is basically widgets from the [design](#Design) thats been used a lot and there is no way to adjust the main theme for them from the `ThemeData` in the [`theme.dart`](https://github.com/spark-gazzers/islamy/blob/master/lib/theme.dart) file.

### **Localizations**

The project uses `intl_utils` which harnesses Google `.arb` (Application Resource Bundle) files and these resources can be found at `l10n` directory.

PS.

Currently only english (en_US) is supported and will be the only one untill we hit the first release target then shortly the first locale to be supported should be Arabic (ar_SA).

### **Generated Files**

Currently there are two as [mentioned here](#building) :

-   `lib/generated/adapters`
This is where Hive DB adapters goto.

-   `lib/generated/l10n`
This is where `intl_utils` generated `S` localization goto.

### **Utils**

This top level directory is mainly for two utils which are:

-   ### `Routes.dart`
The `Routes` class is the sole responsible for managing screens, the app does not push any routes through the `Navigator` manually; all the pushing is used through names registered here.

Though this class has map for registered builders it's only used through `onGenerateRoute` only to manage route building it self in future development.

-   ### `Helper.dart`

Which contains many subhelpers each with it's own class and file in the `helpers/` subdirectory.

PS.

`Helper` class has no actual useful methods instead it's a Dart lang `library` that acts as a portal for other subhelpers like `Helper.formatters.formatLengthDuration`.

## **Device Caches**

-   `logo.png`. Which is the app logo (can be access through `QuranManager.artWork`) copied to the cached storage to let the `audio_service` use it as an image for the native audio player `artWork` (album image).

-   `HiveDB/`. Where hive boxes and file locks lies.

-   `quran/`, Where all of the downloaded ayahs `.mp3` files from [alquran cloud server](https://alquran.cloud/) lies.

The `quran/` directory architecture is maintained to seperate each `Surah` from each `Edition`.

For example let's take surah Al-Fatiha from `ar.abdullahbasfar` and surah Al-Nas from `ar.abdurrahmaansudais` editions,the files layout will be like:
```
quran/
|
└─── ar.abdullahbasfar/
│            │   
│            │   
│            └─── 1/
│                  │    1.mp3
│                  │    2.mp3
│                  │    ...
│                  │    7.mp3
│                  │    durations.json
│                  └─── .nomedia
│            
│            
│            
└─── ar.abdurrahmaansudais/
             │   
             │   
             └─── 114/
                   │    1.mp3
                   │    2.mp3
                   │    ...
                   │    6.mp3
                   │    durations.json
                   └─── .nomedia
```

Where:

-   `{edition}/{surah_number}/{number.mp3}` is an ayah audio file.
-   `{edition}/{surah_number}/{merged.mp3}` is all of the ayahs audio files merged in one file.
-   `{edition}/{surah_number}/{durations.json}` is json that holds the duration of all of the ayahs audio files.


PS.

These paths are all descendants of `path_provider`'s `getApplicationDocumentsDirectory()` value.
# Contribution & Donations

## Contribution
All kind of contributions are welcome, and there is [channels in the discord server](https://discord.gg/G9RzbGtf4D) for non-coding contributions, such as design and smoke-testing, product management etc...

Code contributions can also be derived from the discord server channels, though there is miltiple `TODO` in the app for `psyonixFX`, feel free to take any of them without permission.

The only exception is bug reporting, bugs should be reported by [opening an issue here.](https://github.com/spark-gazzers/islamy/issues/new)

## Donations

There is no donations channels opened yet but you can [reach us through email.](mailto:yousuf.m.hammad@icloud.com)


# Credits

iSlamy is built, first and foremost, upon the blessing of Allah ﷻ - so our thanks go first to Him and to His beloved Prophet Muhammad ﷺ.

Huge thanks for [Islamic Network](https://islamic.network/) for giving us permission to use the [Al Quran Cloud](https://alquran.cloud) apis which where we get all the quran and it's services from and the beautiful quran recitations.   🤍

| ![ image ]( https://islamic.network/assets/images/logo.jpg ) |   |
|---------------------------------------------------------------------------------|---|

Huge thanks for [HadeethEnc (Encyclopedia of Translated Prophetic Hadiths)](https://hadeethenc.com/) for the huge and neat hadeeth api.   🤍

| ![ image ]( https://hadeethenc.com/assets/images/new_logo_ltr.png ) | ![image](https://hadeethenc.com/assets/images/jameiah.png) | ![image](https://hadeethenc.com/assets/images/rabwah.png) |
|---------------------------------------------------------------------|------------------------------------------------------------|-----------------------------------------------------------|

    Many thanks to every muslim helped another muslim in any manner. 🤍
# License
This project is licensed under [BSD-3 Style](https://github.com/spark-gazzers/islamy/blob/master/LICENSE), you are free to use this source code to do whatever you want. 

Kindly, if you want to use it for another islamic app please let us know to add it as feature instead of creating another app as it would be agains the concept of everything in one place.