# workbench

A development environment.

## Starting the environment

### Building from source

`./scripts/workbenchBuild.sh`

### Running the container

`./scripts/workbenchRun.sh`

## Langages
- Dotnet 3.1
- GoLang 1.24.2
- NodeJS 14.4.0
- Python 2.8.18
- Python 3.8.2
- Ruby   2.7

## Installed CLI Tools
- autojump
- cowsay
- ctop
- curl
- fmt
- git
- highlight
- htop
- httpie
- jq
- less
- mtr
- ncdu
- neovim
- ranger
- ripgrep
- screenfetch
- ssh-client
- sudo
- tmux
- w3m
- wget
- zsh

## NeoVim Plugins
- [ale](https://github.com/dense-analysis/ale)
- [coc.nvim](https://github.com/neoclide/coc.nvim)
- [delimitMate](https://github.com/Raimondi/delimitMate)
- [fzf](https://github.com/junegunn/fzf.vim)
- [gruvbox-material](https://github.com/sainnhe/gruvbox-material)
- [gv](https://github.com/junegunn/gv.vim)
- [indentLine](https://github.com/Yggdroot/indentLine)
- [nerd-commenter](https://github.com/preservim/nerdcommenter)
- [nerdtree-git-plugin](https://github.com/Xuyuanp/nerdtree-git-plugin)
- [nerdtree](https://github.com/preservim/nerdtree)
- [tagbar](https://github.com/majutsushi/tagbar)
- [ultisnips](https://github.com/SirVer/ultisnips)
- [vim-airline-themes](https://github.com/vim-airline/vim-airline-themes)
- [vim-airline](https://github.com/vim-airline/vim-airline)
- [vim-easy-align](https://github.com/junegunn/vim-easy-align)
- [vim-easymotion](https://github.com/easymotion/vim-easymotion)
- [vim-fugitive](https://github.com/tpope/vim-fugitive)
- [vim-gitgutter](https://github.com/airblade/vim-gitgutter)
- [vim-go](https://github.com/fatih/vim-go)
- [vim-qf](https://github.com/romainl/vim-qf)
- [vim-snippets](https://github.com/honza/vim-snippets)
- [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator)

# ShortCuts

## FZF

| Command  | List              |
| ---      | ---               |
| `ctrl-t` | complete with fzf |
| `alt-c`  | fzf               |

## Tmux

| Command        | List                                             |
| ---            | ---                                              |
| `ctrl+b+w`     | list sessions and windows                        |
| `ctrl+b+q`     | list pane indexex                                |
| `ctrl+b+d`     | detach from session                              |
| `ctrl+b+space` | change pane orientation (horizontal -> vertical) |

## Vim

### Movement

| Command         | List                                                                |
| ---             | ---                                                                 |
| `^`             | Move to first non-blank character in line.                          |
| `f a`           | Move forward to next instance of the 'a' character                  |
| `F a`           | Move backward to previous instance of the 'a' character             |
| `;`             | Repeat previous `forward` command.                                  |
| `f space`       | Move to next whitespace                                             |
| `H M L`         | Move to the top/middle/bottom of the screen (i.e. High/Middle/Low). |
| `''`            | Jump back to previous position                                      |
| `ctrl+o ctrl+i` | Jump back / forward through previous positions                      |

### Edit

| Command | List |
| ---     | ---  |
| `dw`      | delete to the next word                            |
| `dt,`     | delete up until the next comma on the current line |
| `de`      | delete to the end of the current word              |
| `d2e`     | delete to the end of next word                     |
| `dj`      | delete down a line (current and one below)         |
| `dt)`     | delete up until next closing parenthesis           |
| `d/rails` | delete up until the first search match for “rails” |

### Easy Motion

| Command    | List           |
| ---        | ---            |
| `ss fo`    | jump to "fo"   |
| `leader-j` | line jump down |
| `leader-k` | line jump up   |

### Misc

| command                                     | list                                                    |
| ---                                         | ---                                                     |
| `:!mkdir -p %:h`                            | when not exists, create directory for file              |
| `gv`                                        | redo last visual mode selection                         |
| `k`                                         | help for item under cursor                              |
| `.`                                         | repeat last command                                     |
| `> <`                                       | indent / un-indent block                                |
| `*`                                         | search for word under cursor                            |
| `ctrl+x`                                    | select value from `ctrl+x ctrl+o` for word under cursor |
| `:set syntax=go`                            | set file syntax                                         |
| `:set filetype=go`                          | set file type .                                         |
| `:'<,'>:s/=.//gc`                           | delete everything after = character                     |
| `:%!python -m json.tool`                    | format json                                             |
| `:verbose set conceallevel? concealcursor?` | determine what modified a setting                       |


### Working with registers

| Command                | List                            |
| ---                    | ---                             |
| `"{a-z}y`              | Yank to register                |
| `"{A-Z}y`              | Append yank to register         |
| `"{a-z}p`              | Paste from register             |
| `:reg`                 | Show contents ofnamed registers |


### Macros

| Command                | List                            |
| ---                    | ---                             |
| `q<letter><commands>q` | Start recording macro           |
| `<number>@<letter>`    | Execute macro n number of times |
| `@@`                   | Repeat last macro               |

### Movement with Tags

| Command         | List                   |
| ---             | ---                    |
| `ctrl - [`         | Jump to definition. |
| `ctrl - T`         | Jump back.          |

### Marks

| Command   | List                            |
| ---       | ---                             |
| `m {a-z}` | Marks current position as {a-z} |
| `' {a-z}` | Move to position as {a-z}       |

### Buffers

| Command    | List                              |
| ---        | ---                               |
| `:%bd\|e#` | close all buffers and reopen last |

## Vim Plugins

### Vim EasyAlign

| Command      | List                          |
| ---          | ---                           |
| ```gaip=```  | align on equal sign character |
| ```gaip*=``` | align all = characters        |
| ```gaip*|``` | align all | characters        |

### Vim FZF

| Command           | List                                                                    |
| ---               | ---                                                                     |
| `Files [PATH]`    | Files (similar to `:FZF`)                                               |
| `GFiles [OPTS]`   | Git files (`git ls-files`)                                              |
| `GFiles?`         | Git files (`git status`)                                                |
| `Buffers`         | Open buffers                                                            |
| `Colors`          | Color schemes                                                           |
| `Ag [PATTERN]`    | [ag][ag] search result (`ALT-A` to select all, `ALT-D` to deselect all) |
| `Rg [PATTERN]`    | [rg][rg] search result (`ALT-A` to select all, `ALT-D` to deselect all) |
| `Lines [QUERY]`   | Lines in loaded buffers                                                 |
| `BLines [QUERY]`  | Lines in the current buffer                                             |
| `Tags [QUERY]`    | Tags in the project (`ctags -R`)                                        |
| `BTags [QUERY]`   | Tags in the current buffer                                              |
| `Marks`           | Marks                                                                   |
| `Windows`         | Windows                                                                 |
| `Locate PATTERN`  | `locate` command output                                                 |
| `History`         | `v:oldfiles` and open buffers                                           |
| `History:`        | Command history                                                         |
| `History/`        | Search history                                                          |
| `Snippets`        | Snippets ([UltiSnips][us])                                              |
| `Commits`         | Git commits (requires [fugitive.vim][f])                                |
| `BCommits`        | Git commits for the current buffer                                      |
| `Commands`        | Commands                                                                |
| `Maps`            | Normal mode mappings                                                    |
| `Helptags`        | Help tags <sup id="a1">[1](#helptags)</sup>                             |

### Vim Omnisharp

| Command           | List                         |
| ---               | ---                          |
| `gd`              | OmniSharpGotoDefinition      |
| `<Leader>fi`      | OmniSharpFindImplementations |
| `<Leader>fs`      | OmniSharpFindSymbol          |
| `<Leader>fu`      | OmniSharpFindUsages          |
| `<Leader>fm`      | OmniSharpFindMembers         |
| `<Leader>fx`      | OmniSharpFixUsings           |
| `<Leader>tt`      | OmniSharpTypeLookup          |
| `<Leader>dc`      | OmniSharpDocumentation       |
| `<C-\>`           | OmniSharpSignatureHelp       |
| `<C-\> <C-o>`     | OmniSharpSignatureHelp       |
| `<C-k>`           | OmniSharpNavigateUp          |
| `<C-j>`           | OmniSharpNavigateDown        |
| `<Leader>cc`      | OmniSharpGlobalCodeCheck     |
| `<Leader><Space>` | OmniSharpGetCodeActions      |
| `<Leader>nm`      | OmniSharpRename              |
| `<F2>`            | OmniSharpRename              |
| `<Leader>cf`      | OmniSharpCodeFormat          |
| `<Leader>ss`      | OmniSharpStartServer         |
| `<Leader>sp`      | OmniSharpStopServer          |

## Docker

### Resource Usage Table

`docker stats --format "table {{.Name}}\t{{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}"`
