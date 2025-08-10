Go to <https://github.com/lucide-icons/lucide/releases/tag/${version}>
download both:

- `lucide-font-${version}.zip`
- `lucide-icons-${version}.zip`

Packages from the above link & extract them
Replace:

- From `lucide-icons-${version}` directory
  - `scripts/icons` directory with the extracted one
- From `lucide-font-${version}`
  - `scripts/info.json` file with the extracted one
  - `lib/fonts/lucide.ttf` with the one extracted one

Now navigate to the `script/` directory:
`dart lib/script.dart` to generate the icons
`mv flutter_lucide_update.txt ../lib/src/flutter_lucide.dart`
