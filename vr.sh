#!/bin/bash
function usage() {
    cat <<EOF
使い方: コマンド [話者番号] [読ませる文章]
説明:
引数:
オプション:
-h|--help) ヘルプを表示
-l) 話者リスト
EOF
}
speaker=$1
text=$2
echo $speaker
echo $text
while [ -n "${1:-}" ]; do
    case "$1" in
        -h|--help)
            usage
            exit 0
            ;;
	-l)
            curl https://gist.githubusercontent.com/star114514-mit/e45a1fc4927f2b1e186c02053ee366c9/raw/2163b23d80a98d37ffa3970245d52ba97132e855/speaker
	    exit 0
	    ;;
        -*)
            echo -e 'Error: Invalid option. Please use "-h".'
            exit 1
            ;;
    esac
    shift
done

curl -o ~/.vrhz "https://cloud.ai-j.jp/demo/aitalk2webapi_nop.php?speaker_id="$speaker"&text="$text"&ext=mp3"
sed -i 's/callback//g' ~/.vrhz
sed -i 's/(//g' ~/.vrhz
sed -i 's/)//g' ~/.vrhz
sed -i 's/\\//g' ~/.vrhz
sed -i 's@//cloud.ai-j.jp@https://cloud.ai-j.jp@g' ~/.vrhz
wget -O /tmp/gomi.mp3 $(cat ~/.vrhz | jq -r '.url')
rm -rf "./"$text".mp3"
ffmpeg -i "/tmp/gomi.mp3" -ss 3.5 "./"$text".mp3"
nohup ffplay "./"$text".mp3" > /dev/null &
