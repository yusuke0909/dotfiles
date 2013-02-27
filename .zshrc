#
# .zshrc
#

#---------------------------------
# Environment variable configuration
#---------------------------------
# LANG
export LANG=ja_JP.UTF-8
export LESSCHARSET=utf-8
#PAGER
export PAGER="less -c -x4 -RM"
#EDITOR
export EDITOR=vim
#PATH,MANPATH
export PATH=$PATH:$HOME/local/bin:/usr/local/git/bin
export PATH=$PATH:$HOME/dotfiles/bin
export PATH=$PATH:/sbin:/usr/local/bin
export MANPATH=$MANPATH:/opt/local/man:/usr/local/share/man

# screen を自動的に起動
#if [ ! $TERM = "screen" -a -z "$YROOT_NAME" ]; then; screen -R; fi
#if [ -n $YROOT_NAME ]; then; builtin cd $HOME; fi

#---------------------------------
# Default shell configuration
# colors enables us to idenfity color by $fg[red].
#---------------------------------
autoload colors
colors

case ${UID} in
    0)
        PROMPT="%B%{${fg[red]}%}%/#%{${reset_color}%}%b "
        PROMPT2="%B%{${fg[red]}%}%_#%{${reset_color}%}%b "
        #SPROMPT="%B%{${fg[red]}%}%r is correct? [n,y,a,e]:%{${reset_color}%}%b "
        SPROMPT="%B%{${fg[red]}%}Did you mean %{${fg[white]}%}%R %{${fg[red]}%}to %{${fg[white]}%}『 %{${fg[yellow]}%}%r %{${fg[white]}%}』%{${reset_color}%}?  ( [N]o , [Y]es , [E]dit , [A]bort ) :%{${reset_color}%}%b "
        [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] &&
            PROMPT="%{${fg[cyan]}%}$(echo ${HOST%%.*} | tr '[a-z]' '[A-Z]') ${PROMPT}"
        ;;
    *)
## 256色生成用便利関数
### red: 0-5
### green: 0-5
### blue: 0-5
color256()
{
    local red=$1; shift
    local green=$2; shift
    local blue=$3; shift

	#色の定義
	#local DEFAULT=$'%{^[[m%]]}'$
	#local RED=$'%{^[[1;31m%]]}'$
	#local GREEN=$'%{^[[1;32m%]]}'$
	#local YELLOW=$'%{^[[1;33m%]]}'$
	#local BLUE=$'%{^[[1;34m%]]}'$
	#local PURPLE=$'%{^[[1;35m%]]}'$
	#local LIGHT_BLUE=$'%{^[[1;36m%]]}'$
	#local WHITE=$'%{^[[1;37m%]]}'$

    echo -n $[$red * 36 + $green * 6 + $blue + 16]
}

fg256()
{
    echo -n $'\e[38;5;'$(color256 "$@")"m"
}

bg256()
{
    echo -n $'\e[48;5;'$(color256 "$@")"m"
}

## プロンプトの作成
### ↓ のようにする
###   -(user@debian)-(0)-<2011/09/01 00:54>------------------------------[/home/user]-
###   -[84](0)%                                                                   [~]

## バージョン管理システムの情報も表示する
autoload -Uz vcs_info
zstyle ':vcs_info:*' formats \
    '(%{%F{white}%K{green}%}%s%{%f%k%})-[%{%F{white}%K{blue}%}%b%{%f%k%}]'
zstyle ':vcs_info:*' actionformats \
    '(%{%F{white}%K{green}%}%s%{%f%k%})-[%{%F{white}%K{blue}%}%b%{%f%k%}|%{%F{white}%K{red}%}%a%{%f%k%}]'

### プロンプトバーの左側
###   %{%B%}...%{%b%}: 「...」を太字にする
###   %{%F{cyan}%}...%{%f%}: 「...」をシアン色の文字にする
###   %n: ユーザ名
###   %m: ホスト名（完全なホスト名ではなくて短いホスト名）
###   %{%k%}: 背景色を元に戻す
###   %{%f%}: 文字の色を元に戻す
###   %{%b%}: 太字を元に戻す
###   %D{%Y/%m/%d %H:%M}: 日付「年/月/日 時:分」というフォーマット
prompt_bar_left_self="(%{%B%}%F{yellow}%n%{%b%}%{%F{red}%}@%{%f%}%{%B%}%F{yellow}%m%{%b%})"
###prompt_bar_left_status="(%{%B%F{white}%(?.%K{green}.%K{red})%}%?%{%k%f%b%})"
prompt_bar_left_date="<%{%B%}%F{yellow}%D{%Y/%m/%d %H:%M}%{%b%}>"
prompt_bar_left="-${prompt_bar_left_self}-${prompt_bar_left_date}-"
#prompt_bar_left="-${prompt_bar_left_self}-${promp_bar_left_status}-${prompt_bar_left_date}-"
### プロンプトバーの右側
###   %{%B%K{magenta}%F{white}%}...%{%f%k%b%}:
###       「...」を太字のマゼンタ背景の白文字にする。
###   %d: カレントディレクトリのフルパス（省略しない）
prompt_bar_right="-[%{%B%K{magenta}%F{white}%}%d%{%f%k%b%}]-"

### 2行目左にでるプロンプト
###   %{%B%F{white}%(?.%K{green}.%K{red})%}%?%{%f%k%b%}:
###                           最後に実行したコマンドが正常終了していれば
###                           太字で白文字で緑背景にして異常終了していれば
###                           太字で白文字で赤背景にする
###   %{%F{white}%}: 白文字にする
###     %(x.true-text.false-text): xが真のときはtrue-textになり
###                                偽のときはfalse-textになる
###       ?: 最後に実行したコマンドの終了ステータスが0のときに真になる
###       %K{green}: 緑景色にする
###       %K{red}: 赤景色を赤にする
###   %?: 最後に実行したコマンドの終了ステータス
###   %h: ヒストリ数
###   %(1j,(%j),): 実行中のジョブ数が1つ以上ある場合だけ「(%j)」を表示
###     %j: 実行中のジョブ数
###   %{%B%}...%{%b%}: 「...」を太字にする
###   %#: 一般ユーザなら「%」、rootユーザなら「#」になる
prompt_left="(%{%B%F{white}%(?.%K{green}.%K{red})%}%?%{%k%f%b%})-[%h]%(1j,(%j),)%{%B%}%F{yellow}%#%{%b%} "

## プロンプトフォーマットを展開した後の文字数を返す
## 日本語未対応。
count_prompt_characters()
{
    # print:
    #   -P: プロンプトフォーマットを展開する
    #   -n: 改行をつけない
    # sed:
    #   -e $'s/\e\[[0-9;]*m//g': ANSIエスケープシーケンスを削除
    # wc:
    #   -c: 文字数を出力する
    # sed:
    #   -e 's/ //g': *BSDやMac OS Xのwcは数字の前に空白を出力するので削除する
    print -n -P -- "$1" | sed -e $'s/\e\[[0-9;]*m//g' | wc -m | sed -e 's/ //g'
}

## プロンプトを更新する
update_prompt()
{
    # プロンプトバーの左側の文字数を数える
    # 左側では最後に実行したコマンドの終了ステータスを使って
    # いるのでこれは一番最初に実行しなければいけない。そうし
    # ないと、最後に実行したコマンドの終了ステータスが消えて
    # しまう
    local bar_left_length=$(count_prompt_characters "$prompt_bar_left")
    # プロンプトバーに使える残り文字を計算する
    # $COLUMNSにはターミナルの横幅が入っている
    local bar_rest_length=$[COLUMNS - bar_left_length]

    local bar_left="$prompt_bar_left"
    # パスに展開される「%d」を削除
    local bar_right_without_path="${prompt_bar_right:s/%d//}"
    # 「%d」を抜いた文字数を計算する
    local bar_right_without_path_length=$(count_prompt_characters "$bar_right_without_path")
    # パスの最大長を計算する
    #   $[...]: 「...」を算術演算した結果で展開する
    local max_path_length=$[bar_rest_length - bar_right_without_path_length]
    # パスに展開される「%d」に最大文字数制限をつける
    #   %d -> %(C,%${max_path_length}<...<%d%<<,)
    #     %(x,true-text,false-text):
    #         xが真のときはtrue-textになり偽のときはfalse-textになる
    #         ここでは、「%N<...<%d%<<」の効果をこの範囲だけに限定させる
    #         ために用いているだけなので、xは必ず真になる条件を指定
    #       C: 現在の絶対パスが/以下にあると真、なので必ず真になる
    #       %${max_path_length}<...<%d%<<:
    #          「%d」が「${max_path_length}」カラムより長かったら、
    #          長い分を削除して「...」にする。最終的に「...」も含めて
    #          「${max_path_length}」カラムより長くなることはない
    bar_right=${prompt_bar_right:s/%d/%(C,%${max_path_length}<...<%d%<<,)/}
    # 「${bar_rest_length}」文字分の「-」を作っている
    # どうせ後で切り詰めるので十分に長い文字列を作っているだけ
    # 文字数はざっくり
    local separator="${(l:${bar_rest_length}::-:)}"
    # プロンプトバー全体を「${bar_rest_length}」カラム分にする
    #   %${bar_rest_length}<<...%<<:
    #     「...」を最大で「${bar_rest_length}」カラムにする
    bar_right="%${bar_rest_length}<<${separator}${bar_right}%<<"

    # プロンプトバーと左プロンプトを設定
    #   "${bar_left}${bar_right}": プロンプトバー
    #   $'\n': 改行
    #   "${prompt_left}": 2行目左のプロンプト
    PROMPT="${bar_left}${bar_right}"$'\n'"${prompt_left}"
    # 右プロンプト
    #   %{%B%F{white}%K{green}}...%{%k%f%b%}:
    #       「...」を太字で緑背景の白文字にする
    #   %~: カレントディレクトリのフルパス（可能なら「~」で省略する）
    RPROMPT="[%{%B%F{white}%K{magenta}%}%~%{%k%f%b%}]"
    case "$TERM_PROGRAM" in
	Apple_Terminal)
	    # Mac OS Xのターミナルでは$COLUMNSに右余白が含まれていないので
	    # 右プロンプトに「-」を追加して調整
	    ## 2011-09-05
	    RPROMPT="${RPROMPT}-"
	    ;;
    esac

    # コマンド打ち間違い時の「もしかして」プロンプト
        #SPROMPT="%B%{${fg[red]}%}%r is correct? [n,y,a,e]:%{${reset_color}%}%b "
        SPROMPT="%B%{${fg[red]}%}Did you mean %{${fg[white]}%}%R %{${fg[red]}%}to %{${fg[white]}%}『 %{${fg[yellow]}%}%r %{${fg[white]}%}』%{${reset_color}%}?  ( [N]o , [Y]es , [E]dit , [A]bort ) :%{${reset_color}%}%b "


    # バージョン管理システムの情報を取得する
    LANG=C vcs_info >&/dev/null
    # バージョン管理システムの情報があったら右プロンプトに表示する
    if [ -n "$vcs_info_msg_0_" ]; then
	RPROMPT="${vcs_info_msg_0_}-${RPROMPT}"
    fi
}

## コマンド実行前に呼び出されるフック
precmd_functions=($precmd_functions update_prompt)




#        #
#        # Color
#        #
#        DEFAULT=$'%{\e[1;0m%}'
#        RESET="%{${reset_color}%}"
#        GREEN="%{${fg[green]}%}"
#        BLUE="%{${fg[blue]}%}"
#        RED="%{${fg[red]}%}"
#        CYAN="%{${fg[cyan]}%}"
#        WHITE="%{${fg[white]}%}"
#        #POH="( ꒪⌓꒪) $"
#        POH="$"
#
#        #
#        # Prompt
#        #
#        PROMPT='%{$fg_bold[blue]%}${USER}@%m ${RESET}${WHITE}${POH} ${RESET}'
#        RPROMPT='${RESET}${WHITE}[${BLUE}%(5~,%-2~/.../%2~,%~)% ${WHITE}]${RESET}'
#
#        #
#        # Vi入力モードでPROMPTの色を変える
#        # http://memo.officebrook.net/20090226.html
#        function zle-line-init zle-keymap-select {
#        case $KEYMAP in
#            vicmd)
#                PROMPT="%{$fg_bold[cyan]%}${USER}@%m ${RESET}${WHITE}${POH} ${RESET}"
#                ;;
#            main|viins)
#                PROMPT="%{$fg_bold[blue]%}${USER}@%m ${RESET}${WHITE}${POH} ${RESET}"
#                ;;
#        esac
#        zle reset-prompt
#    }
#    zle -N zle-line-init
#    zle -N zle-keymap-select

    # Show git branch when you are in git repository
    # http://d.hatena.ne.jp/mollifier/20100906/p1

#    autoload -Uz add-zsh-hook
#    autoload -Uz vcs_info
#
#    zstyle ':vcs_info:*' enable git svn hg bzr
#    zstyle ':vcs_info:*' formats '(%s)-[%b]'
#    zstyle ':vcs_info:*' actionformats '(%s)-[%b|%a]'
#    zstyle ':vcs_info:(svn|bzr):*' branchformat '%b:r%r'
#    zstyle ':vcs_info:bzr:*' use-simple true
#
#    autoload -Uz is-at-least
#    if is-at-least 4.3.10; then
#        # この check-for-changes が今回の設定するところ
#        zstyle ':vcs_info:git:*' check-for-changes true
#        zstyle ':vcs_info:git:*' stagedstr "+"    # 適当な文字列に変更する
#        zstyle ':vcs_info:git:*' unstagedstr "-"  # 適当の文字列に変更する
#        zstyle ':vcs_info:git:*' formats '(%s)-[%c%u%b]'
#        zstyle ':vcs_info:git:*' actionformats '(%s)-[%c%u%b|%a]'
#    fi
#
#    function _update_vcs_info_msg() {
#    psvar=()
#    LANG=en_US.UTF-8 vcs_info
#    psvar[2]=$(_git_not_pushed)
#    [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
#}
#add-zsh-hook precmd _update_vcs_info_msg
#
## show status of git pushed to HEAD in prompt
#function _git_not_pushed()
#{
#    if [ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" = "true" ]; then
#        head="$(git rev-parse HEAD)"
#        for x in $(git rev-parse --remotes)
#        do
#            if [ "$head" = "$x" ]; then
#                return 0
#            fi
#        done
#        echo "|?"
#    fi
#    return 0
#}

# git のブランチ名 *と作業状態* を zsh の右プロンプトに表示＋ status に応じて色もつけてみた - Yarukidenized:ヤルキデナイズド :
# http://d.hatena.ne.jp/uasi/20091025/1256458798
autoload -Uz VCS_INFO_get_data_git; VCS_INFO_get_data_git 2> /dev/null

function rprompt-git-current-branch {
local name st color gitdir action pushed
if [[ "$PWD" =~ '/\.git(/.*)?$' ]]; then
    return
fi

name=`git rev-parse --abbrev-ref=loose HEAD 2> /dev/null`
if [[ -z $name ]]; then
    return
fi

gitdir=`git rev-parse --git-dir 2> /dev/null`
action=`VCS_INFO_git_getaction "$gitdir"` && action="|$action"
pushed="`_git_not_pushed`"

st=`git status 2> /dev/null`
if [[ "$st" =~ "(?m)^nothing to" ]]; then
    color=%F{green}
elif [[ "$st" =~ "(?m)^nothing added" ]]; then
    color=%F{yellow}
elif [[ "$st" =~ "(?m)^# Untracked" ]]; then
    color=%B%F{red}
else
    color=%F{red}
fi

echo "[$color$name$action$pushed%f%b]"
    }

    # PCRE 互換の正規表現を使う
    setopt re_match_pcre

#    RPROMPT='`rprompt-git-current-branch`${RESET}${WHITE}[${BLUE}%(5~,%-2~/.../%2~,%~)${WHITE}]${RESET}'

    ;;
esac


#---------------------------------
# set options
#---------------------------------
setopt extended_history         # コマンドの開始時刻と経過時間を登録
setopt hist_ignore_dups         # pushdで同じディレクトリを重複してpushしない
setopt hist_ignore_all_dups     # 登録済コマンド行は古い方を削除
setopt hist_ignore_space        # コマンド行先頭が空白の時登録しない(直後ならば呼べる)
setopt hist_reduce_blanks       # 余分な空白は詰めて登録(空白数違い登録を防ぐ)
setopt share_history            # historyの共有
setopt hist_no_store            # historyコマンドは登録しない
setopt hist_verify              # history展開で、直接コマンドを実行せずに編集可能な状態にする
setopt inc_append_history       # add history when command executed.
#setopt auto_resume             # サスペンド中のプロセスと同じコマンド名を実行した場合はリジュームする
#setopt equals                  # =command を command のパス名に展開する
#setopt NO_flow_control         # Ctrl+S/Ctrl+Q によるフロー制御を使わないようにする
#setopt hash_cmds               # 各コマンドが実行されるときにパスをハッシュに入れる

setopt auto_list                # 補完候補が複数ある時に、一覧表示する
setopt list_types               # auto_list の補完候補一覧で、ls -F のようにファイルの種別をマーク表示
setopt list_packed              # 補完候補リストを詰めて表示
setopt print_eight_bit          # 補完候補リストの日本語を適正表示
#setopt menu_complete           # 1回目のTABで補完候補を挿入
setopt auto_menu                # 補完キー（Tab,  Ctrl+I) を連打するだけで順に補完候補を自動で補完する
setopt complete_in_word         # カーソル位置で補完する
setopt glob_complete            # globを展開しないで候補の一覧から補完する
setopt dotglob                  # ワイルドカード「*」で「.」から始まるファイル/ディレクトリにヒットする
setopt complete_aliases         # aliasでも補完できるようにする
setopt hist_expand              # 補完時にヒストリを自動的に展開する
setopt auto_remove_slash        # 引数の最後のスラッシュを取り除いて実行する
#setopt noautoremoveslash       # 最後がディレクトリ名で終わっている場合末尾の / を自動的に取り除かない
setopt no_clobber               # 上書きリダイレクトの禁止
#setopt no_unset                # 未定義変数の使用の禁止
setopt no_hup                   # logout時にバックグラウンドジョブを kill -HUP しない
setopt no_beep                  # コマンド入力エラーでBEEPを鳴らさない
#setopt nolistbeep              # beepを鳴らさないようにする

setopt extended_glob            # 拡張globを有効にする(glob中で「(#...)」という書式で指定する)
setopt auto_cd                  # 第1引数がディレクトリだと cd を実行
setopt auto_pushd               # cd でTabを押すとdir list を表示
setopt pushd_minus              # cd -[tab]とcd +[tab]の役割を逆にする  -:古いのが上、+:新しいのが上
setopt pushd_to_home            # 引数なしpushdで$HOMEに戻る(直前dirへは cd - で)
setopt pushd_ignore_dups        # ディレクトリスタックに重複する物は古い方を削除
#setopt pushd_silent            # pushd, popd の度にディレクトリスタックの中身を表示しない
setopt correct                  # スペルミス補完
#setopt correct_all             # コマンドライン全てのスペルチェックをする
setopt no_checkjobs             # exit 時にバックグラウンドジョブを確認しない
setopt notify                   # バックグラウンドジョブが終了したらすぐに知らせる
setopt ignore_eof               # C-dでlogoutしない(C-dを補完で使う人用)
setopt interactive_comments     # コマンド入力中のコメントを認める
#setopt rm_star_silent          # rm * などの際、本当に全てのファイルを消して良いかの確認しないようになる
#setopt rm_star_wait            # rm_star_silent の逆で、10 秒間反応しなくなり、頭を冷ます時間が与えられる
setopt sh_word_split            # 変数内のスペースを単語の区切りとして解釈する
setopt cdable_vars              # 先頭に~が必要なディレクトリ名を~なしで展開
setopt auto_param_keys          # 変数名を補完
setopt auto_param_slash         # ディレクトリ名の補完で末尾の / を自動的に付加し、次の補完に備える
setopt brace_ccl                # {a-c} を a b c に展開する機能を使えるようにする
#setopt chase_links             # シンボリックリンクは実体を追うようになる
setopt multios                  # 複数のリダイレクトやパイプなど、必要に応じて tee や cat の機能が使われる
setopt magic_equal_subst        # --prefix=~/localというように「=」の後でも「~」や「=コマンド」などのファイル名展開を行う
setopt long_list_jobs           # jobsでプロセスIDも出力する

#setopt interactive_comments    # コマンドラインでも # 以降をコメントと見なす
#setopt mail_warning            # メールスプール $MAIL が読まれていたらワーニングを表示する
setopt mark_dirs                # ファイル名の展開でディレクトリにマッチした場合末尾に / を付加する
setopt path_dirs                # コマンド名に / が含まれているとき PATH 中のサブディレクトリを探す
setopt numeric_glob_sort        # ファイル名の展開で、辞書順ではなく数値的にソートされるようになる
#setopt print_exit_value        # 戻り値が 0 以外の場合終了コードを表示する
#setopt pushd_to_home           # pushd を引数なしで実行した場合 pushd $HOME と見なされる
#setopt short_loops             # for, repeat, select, if, function などで簡略文法が使えるようになる
#setopt single_line_zle         # デフォルトの複数行コマンドライン編集ではなく、１行編集モードになる
#setopt xtrace                  # コマンドラインがどのように展開され実行されたかを表示するようになる

setopt always_last_prompt       # 補完候補リスト表示で無駄なスクロールをしない(dafault)
setopt promptcr                 # 改行のない出力をプロンプトで上書きする
setopt prompt_subst             # プロンプト内で変数を展開
setopt prompt_percent           # PROMPT内で「%」文字から始まる置換機能を有効にする
setopt transient_rprompt        # コピペしやすいようにコマンド実行後は右プロンプトを消す
limit  coredumpsize    0        # コアファイルを吐かないようにする
DIRSTACKSIZE=10                 # 保存するディレクトリスタックの数


#---------------------------------
# Devicemap & Bindkey
#---------------------------------
stty    erase   '^H'
stty    erase   '^?'
stty    intr    '^C'
stty    susp    '^Z'
bindkey -e    # emacs mode キーバインド
bindkey "^?" backward-delete-char   # Backspace key

# tcsh風先頭マッチのヒストリサーチ(カーソルが行末)
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end
bindkey "\\ep" history-beginning-search-backward-end
bindkey "\\en" history-beginning-search-forward-end

# ctrl-f, ctrl-bキーで単語移動
bindkey '^F' forward-word
bindkey '^B' backward-word
 

# 単語単位移動での単語に含める文字
export WORDCHARS='*?_.[]~=&;!#$%^(){}<>'

# glob(*)によるインクリメンタルサーチ
bindkey '^R' history-incremental-pattern-search-backward
bindkey '^S' history-incremental-pattern-search-forward

## Command history configuration
HISTFILE=~/.zsh_history
#HISTFILE="$HOME/.zhistory.$HOST" # 履歴ファイル
HISTSIZE=100000
SAVEHIST=100000
export HISTTIMEFORMAT='%y/%m/%d %H:%M:%S '

# ^でcd ..する
function cdup() {
echo
cd ..
zle reset-prompt
}
zle -N cdup
# bindkey '\^' cdup

# 展開する前に補完候補を出させる(Ctrl-iで補完するようにする)
# bindkey "^I" menu-complete   

# back-wordでの単語境界の設定
autoload -Uz select-word-style
select-word-style default
zstyle ':zle:*' word-chars " _-./;@"
zstyle ':zle:*' word-style unspecified

# URLをコピペしたときに自動でエスケープ
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic


#---------------------------------
# Completion configuration
#---------------------------------
#Additional completion definitions for Zsh. 以下git clone
#git clone git://github.com/zsh-users/zsh-completions.git ~/.zsh/completions
fpath=(~/.zsh/completions/src ${fpath})

autoload -U compinit; compinit -u   # 初期化
autoload -U colors                  # ${fg[red]}形式のカラー書式を有効化
colors

# zsh editor
autoload zed

# 色付きで補完する
zstyle ':completion:*' list-colors di=34 fi=0
#zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# セパレータを設定する
zstyle ':completion:*' list-separator '-->'
zstyle ':completion:*:manuals' separate-sections true

# ホスト名補完候補を ~/.ssh/known_hosts から自動的に取得する
if [ -e ~/.ssh/known_hosts ]; then
	_cache_hosts=(`perl -ne 'if (/^([a-zA-Z0-9.-]+)/) { print "$1\n";}' ~/.ssh/known_hosts`);
fi

# sudoも補完の対象
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin

# 補完方法毎にグループ化する
# 補完方法の表示方法
#   %B...%b: 「...」を太字にする
#   %d: 補完方法のラベル
zstyle ':completion:*' format '%B%d%b'
zstyle ':completion:*' group-name ''

# 補完侯補をメニューから選択
# select=2: 補完候補を一覧から選択する
#           ただし、補完候補が2つ以上なければすぐに補完する
zstyle ':completion:*:default' menu select=2

# 補完候補に色を付ける。
# "": 空文字列はデフォルト値を使うという意味
#zstyle ':completion:*:default' list-colors ""

# 補完候補がなければより曖昧に候補を探す
# m:{a-z}={A-Z}: 小文字を大文字に変えたものでも補完
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# 補完方法の設定。指定した順番に実行
# _oldlist 前回の補完結果を再利用する
# _complete: 補完する
# _match: globを展開しないで候補の一覧から補完する
# _ignored: 補完候補にださないと指定したものも補完候補とする
# _approximate: 似ている補完候補も補完候補とする
# _prefix: カーソル以降を無視してカーソル位置までで補完する
zstyle ':completion:*' completer \
    _oldlist _complete _match _ignored _approximate _prefix

# 補完候補をキャッシュする
zstyle ':completion:*' use-cache yes

# 詳細な情報を使う
zstyle ':completion:*' verbose yes

# 
zstyle ':completion:*:options' description 'yes'

# オブジェクトファイルとか中間ファイルとかはfileとして補完させない
zstyle ':completion:*:*files' ignored-patterns '*?.o' '*?~' '*\#'

#
#zstyle ':completion:*:messages' format $YELLOW'%d'$DEFAULT
#zstyle ':completion:*:warnings' format $RED'No matches for:'$YELLOW' %d'$DEFAULT
#zstyle ':completion:*:descriptions' format $YELLOW'completing %B%d%b'$DEFAULT
#zstyle ':completion:*:corrections' format $YELLOW'%B%d '$RED'(errors: %e)%b'$DEFAULT
#zstyle ':completion:*' use-compctl false # compctl形式を使用しない

# カレントディレクトリに候補がない場合のみ cdpath 上のディレクトリを候補
#zstyle ':completion:*:cd:*' tag-order local-directories path-directories
# cf. zstyle ':completion:*:path-directories' hidden true
# cf. cdpath 上のディレクトリは補完候補から外れる

# コマンドの予測入力(ヒストリ→一般補完) ## コマンド別に有効にできないか
#autoload -U predict-on
#zle -N predict-on
#zle -N predict-off
#bindkey '^Xp' predict-on    # [C-x p] で有効化
#bindkey '^X^p' predict-off  # [C-x C-p] で無効化
#predict-on

# 端末に表示されている文字列で補完
HARDCOPYFILE=$HOME/.screen-hardcopy
touch $HARDCOPYFILE
chmod 600 $HARDCOPYFILE
dabbrev-complete () {
	local reply lines=80 # 80行分
	screen -X eval "hardcopy -h $HARDCOPYFILE"
	reply=($(sed '/^$/d' $HARDCOPYFILE | sed '$ d' | tail -$lines))
	compadd - "${reply[@]%[*/=@|]}"
}
zle -C dabbrev-complete menu-complete dabbrev-complete
#bindkey '^o' dabbrev-complete
#bindkey '^o^_' reverse-menu-complete

# エラーメッセージ本文出力に色付け
e_normal=`echo -e "¥033[0;30m"`
e_RED=`echo -e "¥033[1;31m"`
e_BLUE=`echo -e "¥033[1;36m"`

#function make() {
#LANG=C command make "$@" 2>&1 | sed -e "s@[Ee]rror:.*@$e_RED&$e_normal@g" -e "s@cannot¥sfind.*@$e_RED&$e_normal@g" -e "s@[Ww]arning:.*@$e_BLUE&$e_normal@g"
#}
#function cwaf() {
#LANG=C command ./waf "$@" 2>&1 | sed -e "s@[Ee]rror:.*@$e_RED&$e_normal@g" -e "s@cannot¥sfind.*@$e_RED&$e_normal@g" -e "s@[Ww]arning:.*@$e_BLUE&$e_normal@g"
#}

# Command Line Stack [Esc]-[q]
bindkey -a 'q' push-line

# build-in コマンドのヘルプ
[ -n "`alias run-help`" ] && unalias run-help
autoload run-help

# 高機能mv
autoload -U zmv
alias mmv='noglob zmv -W'


#---------------------------------
# Alias configuration
#
# expand aliases before completing
#---------------------------------
setopt complete_aliases     # aliased ls needs if file/dir completions work

alias where="command -v"

case "${OSTYPE}" in
    freebsd*|darwin*)
        alias ls="ls -alG"
        zle -N expand-to-home-or-insert
        bindkey "@"  expand-to-home-or-insert
        ;;
    linux*)
        alias la="ls -al"
        ;;
esac


case "${OSTYPE}" in
    # MacOSX
    darwin*)
    export PATH=$PATH:/opt/local/bin:/opt/local/sbin/
    export PATH=$PATH:/System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources/
    ;;
freebsd*)
    case ${UID} in
        0)
            updateports()
            {
                if [ -f /usr/ports/.portsnap.INDEX ]
                then
                    portsnap fetch update
                else
                    portsnap fetch extract update
                fi
                (cd /usr/ports/; make index)

                portversion -v -l \<
            }
            alias appsupgrade='pkgdb -F && BATCH=YES NO_CHECKSUM=YES portupgrade -a'
            ;;
    esac
    ;;
esac


#---------------------------------
# Terminal configuration
#---------------------------------
# http://journal.mycom.co.jp/column/zsh/009/index.html
unset LSCOLORS

case "${TERM}" in
    xterm)
        export TERM=xterm-color

        ;;
    kterm)
        export TERM=kterm-color
        # set BackSpace control character

        stty erase
        ;;

    cons25)
        unset LANG
        export LSCOLORS=ExFxCxdxBxegedabagacad

        export LS_COLORS='di=01;32:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30'
        zstyle ':completion:*' list-colors \
            'di=;36;1' 'ln=;35;1' 'so=;32;1' 'ex=31;1' 'bd=46;34' 'cd=43;34'
        ;;

    kterm*|xterm*)
        # Terminal.app
        #    precmd() {
        #        echo -ne "\033]0;${USER}@${HOST%%.*}:${PWD}\007"
        #    }
        # export LSCOLORS=exfxcxdxbxegedabagacad
        # export LSCOLORS=gxfxcxdxbxegedabagacad
        # export LS_COLORS='di=1;34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30'

        export CLICOLOR=1
        export LSCOLORS=ExFxCxDxBxegedabagacad

        zstyle ':completion:*' list-colors \
            'di=36' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'
        ;;

    dumb)
        echo "Welcome Emacs Shell"
        ;;
esac

## ウィンドウタイトル
## 実行中のコマンドとユーザ名とホスト名とカレントディレクトリを表示
update_title() {
    local command_line=
    typeset -a command_line
    command_line=${(z)2}
    local command=
    if [ ${(t)command_line} = "array-local" ]; then
	command="$command_line[1]"
    else
	command="$2"
    fi
    print -n -P "\e]2;"
    echo -n "(${command})"
    print -n -P " %n@%m:%~\a"
}
## X環境上でだけウィンドウタイトルを変える
if [ -n "$DISPLAY" ]; then
    preexec_functions=($preexec_functions update_title)
fi


expand-to-home-or-insert () {
    if [ "$LBUFFER" = "" -o "$LBUFFER[-1]" = " " ]; then
        LBUFFER+="~/"
    else
        zle self-insert
    fi
}


#---------------------------------
# Other configuration
#---------------------------------
# C-M-h でチートシートを表示する
#cheat-sheet () { zle -M "`cat ~/dotfiles/.zsh/cheat-sheet`" }
#zle -N cheat-sheet
# bindkey "^[^h" cheat-sheet
cheat-sheet () { zle -M "`cat ~/bin/cheat-sheet`" }
zle -N cheat-sheet
bindkey "^[^h" cheat-sheet
git-cheat () { zle -M "`cat ~/bin/git-cheat-sheet`" }
zle -N git-cheat
bindkey "^[^g" git-cheat

# zsh の exntended_glob と HEAD^^^ を共存させる
# http://subtech.g.hatena.ne.jp/cho45/20080617/1213629154
typeset -A abbreviations
abbreviations=(
"L"    "| $PAGER"
"G"    "| grep"

"HEAD^"     "HEAD\\^"
"HEAD^^"    "HEAD\\^\\^"
"HEAD^^^"   "HEAD\\^\\^\\^"
"HEAD^^^^"  "HEAD\\^\\^\\^\\^\\^"
"HEAD^^^^^" "HEAD\\^\\^\\^\\^\\^"
)

magic-abbrev-expand () {
    local MATCH
    LBUFFER=${LBUFFER%%(#m)[-_a-zA-Z0-9^]#}
    LBUFFER+=${abbreviations[$MATCH]:-$MATCH}
}

magic-abbrev-expand-and-insert () {
    magic-abbrev-expand
    zle self-insert
}

magic-abbrev-expand-and-accept () {
    magic-abbrev-expand
    zle accept-line
}

no-magic-abbrev-expand () {
    LBUFFER+=' '
}

zle -N magic-abbrev-expand
zle -N magic-abbrev-expand-and-insert
zle -N magic-abbrev-expand-and-accept
zle -N no-magic-abbrev-expand
bindkey "\r"  magic-abbrev-expand-and-accept # M-x RET はできなくなる
bindkey "^J"  accept-line # no magic
bindkey " "   magic-abbrev-expand-and-insert
bindkey "."   magic-abbrev-expand-and-insert
bindkey "^x " no-magic-abbrev-expand

# Incremental completion on zsh
# http://mimosa-pudica.net/src/incr-0.2.zsh
# やっぱりauto_menu使いたいのでoff
# source ~/.zsh/incr*.zsh

# auto-fuの設定。^PとかのHistory検索と相性が悪いのでひとまず無効
# http://d.hatena.ne.jp/tarao/20100531/1275322620
# incremental completion
# if is-at-least 4.3.10; then
# function () { # precompile
# local A
# A=~/.zsh/auto-fu.zsh/auto-fu.zsh
# [[ -e "${A:r}.zwc" ]] && [[ "$A" -ot "${A:r}.zwc" ]] ||
    # zsh -c "source $A; auto-fu-zcompile $A ${A:h}" >/dev/null 2>&1
# }
# source ~/.zsh/auto-fu.zsh/auto-fu; auto-fu-install
# function zle-line-init () { auto-fu-init }
# zle -N zle-line-init
# zstyle ':auto-fu:highlight' input bold
# zstyle ':auto-fu:highlight' completion fg=white
# zstyle ':auto-fu:var' postdisplay ''
# function afu+cancel () {
# afu-clearing-maybe
# ((afu_in_p == 1)) && { afu_in_p=0; BUFFER="$buffer_cur"; }
# }
# function bindkey-advice-before () {
# local key="$1"
# local advice="$2"
# local widget="$3"
# [[ -z "$widget" ]] && {
# local -a bind
# bind=(`bindkey -M main "$key"`)
# widget=$bind[2]
# }
# local fun="$advice"
# if [[ "$widget" != "undefined-key" ]]; then
# local code=${"$(<=(cat <<"EOT"
# function $advice-$widget () {
# zle $advice
# zle $widget
# }
# fun="$advice-$widget"
# EOT
# ))"}
# eval "${${${code//\$widget/$widget}//\$key/$key}//\$advice/$advice}"
# fi
# zle -N "$fun"
# bindkey -M afu "$key" "$fun"
# }
# bindkey-advice-before "^G" afu+cancel
# bindkey-advice-before "^[" afu+cancel
# bindkey-advice-before "^J" afu+cancel afu+accept-line

# # delete unambiguous prefix when accepting line
# function afu+delete-unambiguous-prefix () {
# afu-clearing-maybe
# local buf; buf="$BUFFER"
# local bufc; bufc="$buffer_cur"
# [[ -z "$cursor_new" ]] && cursor_new=-1
# [[ "$buf[$cursor_new]" == ' ' ]] && return
# [[ "$buf[$cursor_new]" == '/' ]] && return
# ((afu_in_p == 1)) && [[ "$buf" != "$bufc" ]] && {
# # there are more than one completion candidates
# zle afu+complete-word
# [[ "$buf" == "$BUFFER" ]] && {
# # the completion suffix was an unambiguous prefix
# afu_in_p=0; buf="$bufc"
# }
# BUFFER="$buf"
# buffer_cur="$bufc"
# }
# }
# zle -N afu+delete-unambiguous-prefix
# function afu-ad-delete-unambiguous-prefix () {
# local afufun="$1"
# local code; code=$functions[$afufun]
# eval "function $afufun () { zle afu+delete-unambiguous-prefix; $code }"
# }
# afu-ad-delete-unambiguous-prefix afu+accept-line
# afu-ad-delete-unambiguous-prefix afu+accept-line-and-down-history
# afu-ad-delete-unambiguous-prefix afu+accept-and-hold
# fi

## 履歴JUMP
#_Z_CMD=j
#source ~/bin/z.sh
#precmd() {
#  _z --add "$(pwd -P)"
#}

function rmf(){
for file in $*
do
    __rm_single_file $file
done
}

function __rm_single_file(){
if ! [ -d ~/.Trash/ ]
then
    command /bin/mkdir ~/.Trash
fi

if ! [ $# -eq 1 ]
then
    echo "__rm_single_file: 1 argument required but $# passed."
    exit
fi

if [ -e $1 ]
then
    BASENAME=`basename $1`
    NAME=$BASENAME
    COUNT=0
    while [ -e ~/.Trash/$NAME ]
    do
        COUNT=$(($COUNT+1))
        NAME="$BASENAME.$COUNT"
    done

    command /bin/mv $1 ~/.Trash/$NAME
else
    echo "No such file or directory: $file"
fi
}


# OSごとのalias設定読み込み
[ -f ~/.zshrc.alias ] && source ~/.zshrc.alias
#[ -f ~/dotfiles/.zshrc.alias ] && source ~/dotfiles/.zshrc.alias

case "${OSTYPE}" in
    # Mac(Unix)
    darwin*)
    # ここに設定
    [ -f ~/.zshrc.osx ] && source ~/.zshrc.osx
    #[ -f ~/dotfiles/.zshrc.osx ] && source ~/dotfiles/.zshrc.osx
    ;;
    # Linux
    linux*)
    # ここに設定
    [ -f ~/.zshrc.linux ] && source ~/.zshrc.linux
    #[ -f ~/dotfiles/.zshrc.linux ] && source ~/dotfiles/.zshrc.linux
    ;;
esac

## local固有設定
[ -f ~/.zshrc.local ] && source ~/.zshrc.local


#---------------------------------
# time
#---------------------------------
# 実行したプロセスの消費時間が10秒以上かかったら
# 自動的に消費時間の統計情報を表示する
REPORTTIME=10                    # CPUを10秒以上使った時は time を表示(FormatはTIMEFMTで指定)
TIMEFMT="\
    The name of this job.             :%J
    CPU seconds spent in user mode.   :%U
    CPU seconds spent in kernel mode. :%S
    Elapsed time in seconds.          :%E
    The  CPU percentage.              :%P"


#---------------------------------
# watch
#---------------------------------
watch=(notme) # (all:全員、notme:自分以外、ユーザ名,@ホスト名、%端末名
LOGCHECK=60   # チェック間隔[秒]
WATCHFMT="%(a:[34mHello %n [%m] [%t]:[31mBye %n [%m] [%t])"
log           # ログイン時にはすぐに表示


#---------------------------------
# functions 
#---------------------------------
# CPU 使用率の高いプロセス10個
function psc() {
  ps auxww | head -n 1
  ps auxww | sort -r -n -k3,3 | grep -v "ps auxww" | grep -v grep | head
}

# メモリ占有率の高いプロセス10個
function psm() {
  ps auxww | head -n 1
  ps auxww | sort -r -n -k4,4 | grep -v "ps auxww" | grep -v grep | head
}

# プロセスをgrepする
function psg() {
  ps auxww | head -n 1
  ps auxww | grep $* | grep -v "ps auxww" | grep -v grep
}

# ls結果をlessでみる
function lsl() { ls $* | $PAGER }
function lll() { ll $* | $PAGER }

# awk '{print $n}'
function awp() {
	col=$1
	shift 1
	files=$*
	if [ "$files" = "" ]; then
		awk "{print \$$col}"
	else
		cat $files | awk "{print \$$col}"
	fi
}

# cdしたらlsしないと気がすまない人用
#function cd() { builtin cd $@ && ls; }

# コマンド履歴を最新の45件表示
function h() { history $* | tail -45 }
# コマンド履歴から引数で指定されたものをを検索
function hg() { history $* | grep -i "$@" }

# h: 直前の履歴 50件を表示 (引数がある場合は過去のすべてを検索)
#function h() {
#if [ "$1" ]; then history $* | grep -i "$@"; else history $* | head -50; fi
#}

# pushd-dirsを表示して番号を入力するとcdする
function gd() {
	builtin dirs -v
	builtin echo -n "select number: "
	builtin read newdir
	builtin cd +"$newdir"
}

# jobsを表示して番号を入力するとfgする
function gj() {
	builtin jobs
	builtin echo -n "select number: "
	builtin read newjob
	builtin fg %"$newjob"
}

# リモートサーバ上のファイルとdiff
function rdiff() {
	local arg1 arg2 tmp1 tmp2
	arg1=$1
	arg2=$2
	if [ "" != "$(echo $arg1 | grep ":")" ]; then
		tmp1=`mktemp "/tmp/rdiffXXXXXXX"`
		scp $arg1 $tmp1
		arg1=$tmp1
	fi
	if [ "" != "$(echo $arg2 | grep ":")" ]; then
		tmp2=`mktemp "/tmp/rdiffXXXXXXX"`
		scp $arg2 $tmp2
		arg2=$tmp2
	fi
	diff $arg1 $arg2 | $PAGER
	if [ -n "$tmp1" ]; then
		rm -f $tmp1;
	fi
	if [ -n "$tmp2" ]; then
		rm -f $tmp2;
	fi
}

# cvs-add
function cvsadd() {
	cvs up | grep -E '^\?' | sed 's/^..//' | grep -E '\.(gif|jpg|png|swf)$' | xargs cvs add -kb
	cvs up | grep -E '^\?' | sed 's/^..//' | xargs cvs add
}

# 半角カナへ変換
function zh() {
	php -d open_basedir=/ -r 'array_shift($argv);foreach($argv as $f){$c=file_get_contents($f);$c=mb_convert_kana($c,"ak");file_put_contents($f,$c);}' $*
}

# グーグル検索 (要w3m)
function google() {
  local str opt 
  if [ $# != 0 ]; then # 引数が存在すれば
    for i in $*; do
      str="$str+$i"
    done    
    str=`echo $str | sed 's/^\+//'` #先頭の「+」を削除
    opt='search?num=50&hl=ja&ie=euc-jp&oe=euc-jp&lr=lang_ja'
    opt="${opt}&q=${str}"
  fi
  w3m http://www.google.co.jp/$opt #引数がなければ $opt は空になる
  # mozilla -remote openURL\(http::/www.google.co.jp/$opt\) # 未テスト
}
alias ggl=google

# exit (kill ssh-agent)
#function exit() {
#	if [ -n "$SSH_AGENT_PID" ]; then
#		eval `ssh-agent -k`
#	fi
#	builtin exit
#}

# ssh-agent
function ssha() {
	eval `ssh-agent`;
	ssh-add;
}

# SSHのForwardAgentを有効にした際にログイン先でscreen/tmuxを使用後detacheするとSSH_AUTH_SOCKの値は更新されない→都度設定するのが手間
# SSH_AUTH_SOCKが直接UNIXドメインソケットを指し示すのではなく、UNIXドメインソケットを指し示すシンボリックリンクを作成しておいて、
# SSH_AUTH_SOCKにはこのシンボリックリンクのパス名を設定する
agent="$HOME/tmp/ssh-agent-$USER"
if [ -S "$SSH_AUTH_SOCK" ]; then
    case $SSH_AUTH_SOCK in
        /tmp/*/agent.[0-9]*)
            ln -snf "$SSH_AUTH_SOCK" $agent && export SSH_AUTH_SOCK=$agent
    esac
elif [ -S $agent ]; then
    export SSH_AUTH_SOCK=$agent
else
    echo "no ssh-agent"
fi

# ssh-agent実行
#ssha

# Attache tmux
#env | grep -i TMUX > /dev/null 2>&1
#if [ $? -ne 0 ]; then
#  if $(tmux has-session); then
#    tmux attach
#  else
#    tmux
#  fi
#fi


#---------------------------------
# zsh-syntax-highlighting
#---------------------------------
# https://github.com/zsh-users/zsh-syntax-highlighting
source ~/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

