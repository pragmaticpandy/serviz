#!/usr/bin/env zsh

serviz() (
    if [[ "$1" == "--skeleton" ]]; then
        cat << EOM
graph G {
    edge[dir=forward];
    node[shape="box", style="filled,rounded", fillcolor=white];
    rankdir=LR; // left to right

    subgraph cluster_foo {
        style="filled,rounded";
        fillcolor="#dedede"; // R #e09d9d O #e0b99d Y #e0da9d G #bbe09d T #9de0c7 B #9dc6e0 P #ba9de0
        label="Start subgraphs IDs with\n\"cluster\" to make them visible.";

        {
           rank=same;
           h [label="Hello,"];
           e [label="!"];
        }

        w [label="world"];

        h -- w;
        w -- e;

    }
}
EOM
	return
	fi

    local dot_file=$1

    if [ -z "$dot_file" ]; then
        echo "You must specify the dot file path, or --skeleton to print skeleton dot code."
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

	fswatch -m poll_monitor -0 $dot_file | while read -d "" event ; do
		build
	done
)
