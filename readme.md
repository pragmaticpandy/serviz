## About
Inspired by [viz-js](http://viz-js.com), this is a tool that gives you live rendering as you edit graphviz
dot files—serviz, it serves graphviz. Unlike viz-js, this tool lets you use your own editor and makes live collaboration
possible. Yes, this was developed during the pandemic.

It is written in zsh, and gives you a function to start a server.

![Made with the help of serviz](https://raw.githubusercontent.com/pragmaticpandy/serviz/master/resources/examples/serviz-decision-tree.png)

## Install
Dependencies you need, and for each, if you are on MacOS, the simplest way to get them.

* graphviz
    * `brew install graphviz`
* browsersync
    1. `brew install node`
    1. `npm install -g browser-sync`
* fswatch
    * `brew install fswatch`

As for serviz itself, you can source this zsh however you'd like. I like antigen, where you can just
pop `antigen bundle https://github.com/pragmaticpandy/serviz.git` before `antigen apply` in your
`.zshrc` and that's it.

## Usage
`serviz DOT_FILE` then open the displayed URL. When you make edits to the dot file, they will be
reflected in the rendered webpage.

`serviz --skeleton` prints out some opinionated skeleton dot code for quickly starting new graphs.

## Tips

1. In vim You can enable automatic writing to disk as you type with the following command:
   ```
   autocmd TextChanged,TextChangedI <buffer> silent write
   ```
1. You can view syntax errors in the serviz terminal window. If nothing is updating in the browser,
   syntax is likely why.
1. Remember you installed graphviz itself already, so when you are done, it can be used directly to
   export the graph: `dot -T png -o OUTPUT_FILE DOT_FILE`
1. For collaborative editing in vim you can use [CoVim](https://github.com/FredKSchott/CoVim).
   However, CoVim needs vim compiled with Python 2 enabled, which most vim distributions do not. You
   can either:
    * Compile vim yourself with something like:
      ```
      sudo echo Installing vim...
      brew install python
      mkdir -p ~/installs
      (
          set -e
          cd ~/installs
          rm -rf vim
          git clone https://github.com/vim/vim.git
          cd vim
          make distclean
          ./configure --enable-pythoninterp --enable-python3interp
          make
          sudo make install
      )

      echo Done.
      ```
    * Or install CoVim with an [unmerged branch](https://github.com/makerforceio/CoVim) that
      migrated to python 3.
