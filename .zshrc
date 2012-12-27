#
# .zshrc
#

# screen を自動的に起動
#if [ ! $TERM = "screen" -a -z "$YROOT_NAME" ]; then; screen -R; fi
#if [ -n $YROOT_NAME ]; then; builtin cd $HOME; fi

#---------------------------------
# set options
#---------------------------------
setopt extended_history         # コマンドの開始時刻と経過時間を登録
setopt hist_ignore_dups         # 直前のコマンドと同一ならば登録しない
setopt hist_ignore_all_dups     # 登録済コマンド行は古い方を削除
setopt hist_reduce_blanks       # 余分な空白は詰めて登録(空白数違い登録を防ぐ)
setopt share_history            # ヒストリの共有
setopt hist_no_store            # historyコマンドは登録しない
setopt hist_ignore_space        # コマンド行先頭が空白の時登録しない(直後ならば呼べる)

setopt list_packed              # 補完候補リストを詰めて表示
setopt print_eight_bit          # 補完候補リストの日本語を適正表示
#setopt menu_complete           # 1回目のTABで補完候補を挿入
setopt auto_menu                # 2回目のTABで補完候補を挿入
#setopt auto_remove_slash       # 引数の最後のスラッシュを取り除いて実行する
setopt no_clobber               # 上書きリダイレクトの禁止
setopt no_unset                 # 未定義変数の使用の禁止
setopt no_hup                   # logout時にバックグラウンドジョブを kill しない
setopt no_beep                  # コマンド入力エラーでBEEPを鳴らさない

setopt extended_glob            # 拡張グロブ
setopt numeric_glob_sort        # 数字を数値と解釈して昇順ソートで出力
setopt auto_cd                  # 第1引数がディレクトリだと cd を実行
setopt autopushd                # cdしたら勝手にpushdする
setopt pushd_to_home            # 引数なしpushdで$HOMEに戻る(直前dirへは cd - で)
setopt pushd_ignore_dups        # ディレクトリスタックに重複する物は古い方を削除
#setopt pushd_silent            # pushd, popd の度にディレクトリスタックの中身を表示しない
setopt correct                  # スペルミス補完
setopt no_checkjobs             # exit 時にバックグラウンドジョブを確認しない
setopt notify                   # バックグラウンドジョブが終了したらすぐに知らせる
setopt ignore_eof              # C-dでlogoutしない(C-dを補完で使う人用)
setopt interactive_comments     # コマンド入力中のコメントを認める
#setopt rm_star_silent          # rm * で本当に良いか聞かずに実行
#setopt rm_star_wait            # rm * の時に 10秒間何もしない
#setopt chase_links             # リンク先のパスに変換してから実行。
setopt sh_word_split            # 変数内のスペースを単語の区切りとして解釈する
setopt cdable_vars              # 先頭に~が必要なディレクトリ名を~なしで展開
setopt auto_param_keys          # 変数名を補完
#setopt list_types              # ファイル種別を表す文字を末尾に表示(default)
#setopt always_last_prompt      # 補完候補リスト表示で無駄なスクロールをしない(dafault)

setopt promptcr                 # 改行のない出力をプロンプトで上書きする
setopt prompt_subst             # プロンプト内で変数を展開

limit   coredumpsize    0       # コアファイルを吐かないようにする


#---------------------------------
# devicemap & bindkey
#---------------------------------
stty    erase   '^H'
stty    erase   '^?'
stty    intr    '^C'
stty    susp    '^Z'
bindkey -e    # emacs mode キーバインド

# tcsh風先頭マッチのヒストリサーチ(カーソルが行末)
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

# 単語単位で前後移動
#bindkey '^F' forward-word
#bindkey '^B' backward-word

# 単語単位移動での単語に含める文字
export WORDCHARS='*?_.[]~=&;!#$%^(){}<>'

bindkey "^?" backward-delete-char

#---------------------------------
# history
#---------------------------------
HISTFILE="$HOME/.zhistory.$HOST" # 履歴ファイル
HISTSIZE=100000                   # メモリ上に保存される $HISTFILE の最大サイズ？
SAVEHIST=100000                   # 保存される最大履歴数


#---------------------------------
# completion
#---------------------------------
autoload -U compinit; compinit -u
autoload -U colors
colors

# ホスト名補完候補を ~/.ssh/known_hosts から自動的に取得する
if [ -e ~/.ssh/known_hosts ]; then
	_cache_hosts=(`perl -ne 'if (/^([a-zA-Z0-9.-]+)/) { print "$1\n";}' ~/.ssh/known_hosts`);
fi

#zstyle ':completion:*' use-compctl false # compctl形式を使用しない

# カレントディレクトリに候補がない場合のみ cdpath 上のディレクトリを候補
#zstyle ':completion:*:cd:*' tag-order local-directories path-directories
# cf. zstyle ':completion:*:path-directories' hidden true
# cf. cdpath 上のディレクトリは補完候補から外れる

# 補完時に大小文字を区別しない
#zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

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


#---------------------------------
# prompt
#---------------------------------

# 色の定義
DEFAULT=$"%{\e[0;0m%}"
RESET="%{${reset_color}%}"
GREEN="%{${fg[green]}%}"
BLUE="%{${fg[blue]}%}"
RED="%{${fg[red]}%}"
CYAN="%{${fg[cyan]}%}"
YELLOW="%{${fg[yellow]}%}"
MAGENTA="%{${fg[magenta]}%}"
WHITE="%{${fg[white]}%}"

#C00=$'%{\e[00m%}' # 初期状態
#CFK=$'%{\e[0;30m%}' # 文字色 - 黒
#CFR=$'%{\e[0;31m%}' # 文字色 - 赤
#CFG=$'%{\e[0;32m%}' # 文字色 - 緑
#CFY=$'%{\e[0;33m%}' # 文字色 - 黄
#CFB=$'%{\e[0;34m%}' # 文字色 - 青
#CFM=$'%{\e[0;35m%}' # 文字色 - 紫
#CFC=$'%{\e[0;36m%}' # 文字色 - 空
#CFW=$'%{\e[0;37m%}' # 文字色 - 白
#CBK=$'%{\e[40m%}' # 背景色 - 黒
#CBR=$'%{\e[41m%}' # 背景色 - 赤
#CBG=$'%{\e[42m%}' # 背景色 - 緑
#CBY=$'%{\e[43m%}' # 背景色 - 黄
#CBB=$'%{\e[44m%}' # 背景色 - 青
#CBM=$'%{\e[45m%}' # 背景色 - 紫
#CBC=$'%{\e[46m%}' # 背景色 - 空
#CBW=$'%{\e[47m%}' # 背景色 - 白
#CTB=$'%{\e[01m%}' # 装飾 - 太字
#CTU=$'%{\e[04m%}' # 装飾 - 下線
#CTL=$'%{\e[05m%}' # 装飾 - 点滅
#CTI=$'%{\e[07m%}' # 装飾 - 反転

# zshのプロンプト
#
#   PROMPT  : 通常のプロンプト
#   PROMPT2 : forやwhile文使用時の複数行入力プロンプト
#   RPROMPT : 右側に表示されるプロンプト, 入力が被ると自動的に消える
#   SPROMPT : 入力ミス時のコマンド訂正プロンプト
#
# コマンド訂正プロンプト
#   y: 訂正コマンドを実行
#   n: 入力したコマンドが実行
#   a: 実行を中断 abort
#   e: コマンドライン編集 edit
#
# プロンプト文字列
#   %% : %文字
#   %# : #文字(一般ユーザなら %，スーパユーザなら #)
#   %l : tty名
#   %M : ホスト名（全部）
#   %m : ホスト名（最初のドットまで）
#   %n : ユーザ名
#   %? : 直前のコマンドの終了値($?)
#   %/ : カレントディレクトリ(フルパス)
#   %~ : 同上,ただし~記号などで可能な限り短縮する
#   %1~ or %1/ : カレントディレクトリ(ベースネーム)
#   %B : 太字開始
#   %b : 太字解除
#   %(1j,(%j),) : 実行中のジョブ数が1つ以上ある場合ジョブ数を表示
#   %C :    base of current directory
#   %c :    base of current directory (print home directory as '~')
#   %h,%! : history number
#   %y :    year (2 digit)
#   %Y :    year (4 digit)
#   %w :    month (word)
#   %W :    month (number)
#   %d :    week day
#   %T :    time (24 HH:MM)
#   %t :    time (12 HH:MM)
#   %P :    time (24 HH:MM:SS)
#   %p :    time (12 HH:MM:SS)
#   %U,%u : under line (%U word %u)
#   %{,%} : escape sequence (%{ escape %})
###################################################
PROMPT="%F{yellow}[%m @%n] %f%# "
RPROMPT="%F{green}[%1(v|%F{yellow}%1v%F{green} |)%~]%f"
#RPROMPT="%(?..%F{red}-%?-)%F{green}[%1(v|%F{yellow}%1v%F{green} |)%~]%f"     _### 直前のコマンドのリターンコード表示

# 時刻更新 (時刻表時した際の更新用)
#TRAPALRM () { zle reset-prompt }
#TMOUT=30

## 右プロンプト
#RPS1=$'${CFW}[%(8~,%-2~/.../%5~,%~)]${C00}'
## 左プロンプト
#export TITLE="-"
#export PSHOST=`hostname|sed "s/mbga/${CFB}mbga${CFG}/"|sed "s/mixi/${CFY}mixi${CFG}/"`
#PS1=$'%{\e]2;%M: $TITLE\a'$'\e]1;%M: $TITLE\a%}'$'${CFG}${PSHOST}${CTB}[${WINDOW:+"${CFG}$WINDOW${CTB}:"}${CFG}%!${CTB}]%(?..[${CFR}%?${CFG}${CTB}])>${C00} '


#---------------------------------
# other autoloads
#---------------------------------

# build-in コマンドのヘルプ
[ -n "`alias run-help`" ] && unalias run-help
autoload run-help

# 高機能mv
autoload -U zmv
alias mmv='noglob zmv -W'


#---------------------------------
# alias
#---------------------------------

# for fileutils (required yinst-ports/fileutils)
alias ls="ls -CF --color=auto --show-control-char"
alias ll="ls -alF --color=auto --show-control-char"
alias rm 'rm -i'
alias del 'rm -rf *~ .*~'
alias cp='cp -iv'

# other command
alias help="run-help" # builtin command help
alias less="$PAGER"
alias more="$PAGER"
alias -g L="| $PAGER"
alias -g M="| $PAGER"
alias make="make -j1"
#alias make="make -j3"
alias rpmi="rpm -qilvv --changelog --scripts"           # RPM Packageの詳細表示(インストール済みのRPMを確認するとき用)
alias rpmip="rpm -qpilvv --changelog --scripts"         # RPM Packageの詳細表示(手元にあるRPMを確認するとき用)
alias psa='ps auxww'
alias bell="echo '\a'"
alias scr="screen -R"
alias tm="tmux a"
alias vi="vim"
alias view="vim -R"
alias svi="sudo vim"
alias dirs='dirs -p'
alias mcpan='sudo perl -MCPAN -e shell'
alias pd='pushd'
alias ppd='popd'
alias cvs='svn'
alias grep='grep --color=auto'
alias ssh='ssh -A'
alias sum="awk '{sum+=\$1} END {print sum}'"
#alias h='head'
#alias t='tail'
#alias g='grep'
#alias c='cat'
#alias j='jobs'
alias -g H='| head'
alias -g T='| tail'
alias -g G='| grep'
alias -g C='| cat -n'
alias -g W='| wc'
alias -g V='| view -'

# ls colors
if [ -x `which dircolors` ]; then
	eval `dircolors $HOME/.dircolors`
fi
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}


#---------------------------------
# time
#---------------------------------
REPORTTIME=8                    # CPUを8秒以上使った時は time を表示
TIMEFMT="\
    The name of this job.             :%J
    CPU seconds spent in user mode.   :%U
    CPU seconds spent in kernel mode. :%S
    Elapsed time in seconds.          :%E
    The  CPU percentage.              :%P"


#---------------------------------
# watch
#---------------------------------
#autoload -U colors; colors      # ${fg[red]}形式のカラー書式を有効化
watch=(notme) # (all:全員、notme:自分以外、ユーザ名,@ホスト名、%端末名
LOGCHECK=60   # チェック間隔[秒]
#WATCHFMT="%(a:${fg[blue]}Hello %n [%m] [%t]:${fg[red]}Bye %n [%m] [%t])"
WATCHFMT="%(a:[34mHello %n [%m] [%t]:[31mBye %n [%m] [%t])"


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
function cd() { builtin cd $@ && ls; }

# コマンド履歴を50件まで表示
#function h() { history $* | head -50 }

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


# 半角カナへ変換
function zh() {
	php -d open_basedir=/ -r 'array_shift($argv);foreach($argv as $f){$c=file_get_contents($f);$c=mb_convert_kana($c,"ak");file_put_contents($f,$c);}' $*
}

# exit (kill ssh-agent)
function exit() {
	if [ -n "$SSH_AGENT_PID" ]; then
		eval `ssh-agent -k`
	fi
	builtin exit
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


# ssh-agent実行
#ssha


export LANG=ja_JP.utf8

# Attache tmux
#env | grep -i TMUX > /dev/null 2>&1
#if [ $? -ne 0 ]; then
#  if $(tmux has-session); then
#    tmux attach
#  else
#    tmux
#  fi
#fi
