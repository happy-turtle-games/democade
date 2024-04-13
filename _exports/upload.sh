#!/bin/bash


tag=$(sed -n -e 's/^\s*config\/version\s*=\s*//p' ../project.godot | tr -d '"')

echo "Current Tag: $tag"


echo -e "\033[0;33mPlease publish release a release. Opening browser...\033[0m"
xdg-open 'https://github.com/happy-turtle-games/democade/releases/new'


echo "Removing old files"
rm democade-*.*.*.x86_64.tar.xz
rm democade-*.*.*.exe.zip


echo "Compressing democade-$tag.x86_64.tar.xz"
tar --transform="flags=r;s|democade.x86_64|democade-$tag.x86_64|" -cJf "democade-$tag.x86_64.tar.xz" "democade.x86_64"

echo "Compressing democade.exe"
zip -r9 democade-$tag.exe.zip democade.exe
printf "@ democade.exe\n@=democade-$tag.exe\n" | zipnote -w "democade-$tag.exe.zip"


echo "Waiting for release $tag to be published on github..."

while true; do
	lastest_gh_tag=$(gh release list --json tagName --jq '.[0].tagName')
	
	if [ $lastest_gh_tag = $tag ]; then
		echo "Release found!"
		break
	fi
	
	sleep 5
done


echo "Uploading x86_64"
gh release upload $tag democade-$tag.x86_64.tar.xz#democade-$tag.x86_64 --clobber

echo "Uploading exe"
gh release upload $tag democade-$tag.exe.zip#democade-$tag.exe --clobber
