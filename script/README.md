https://github.com/lucide-icons/lucide/releases/tag/${version}
download the lucide-font-${version}.zip & lucide-icons-${version}.zip files from the above link & extract them.
Update icons directory of script with the extracted lucide-icons-${version} directory(icons)
Update info.json of script with the extracted lucide-font-${version}/info.json file(info.json)

Run 'dart lib/script.dart' to generate the icons

replace content of flutter_lucide_updated.txt with flutter_lucide.dart in main package file
replace lucide. along with replace lucide.ttf file with new one, in main package file.
