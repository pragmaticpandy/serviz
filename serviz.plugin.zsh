#!/usr/bin/env zsh

serviz() (
    local dot_file=$1

    if [ -z "$dot_file" ]; then
        echo "You must pass in the dot file."
        exit 1
    fi

    if [ ! -f "$dot_file" ]; then
		echo File $dot_file not found.
		exit 1
	fi

    plugin_dir="$(dirname "${(%):-%x}")"
    local site_dir="$plugin_dir"/build/site
    local resources_dir="$plugin_dir"/resources
    build() {
        mkdir -p $site_dir
        cp -r "$resources_dir"/static/* $site_dir
        local svg_out="$plugin_dir"/build/out.svg
        local html_out=$site_dir/index.html
        dot -T svg -o $svg_out $dot_file
        cat $resources_dir/pre-svg.html $svg_out $resources_dir/post-svg.html > $html_out
    }

    build
    echo "Initial build complete. Listening for changes..."

    (browser-sync start --server $site_dir --files $site_dir --no-notify --no-open)&

	fswatch -0 $dot_file | while read -d "" event ; do
		build
	done
)
