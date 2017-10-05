" Path: パス設定 ====================================================== {{{1

" Windowsでも.vimをRumtimeディレクトリにする
set runtimepath+=$HOME/.vim
"ヘルプファイルをパスを指定する
"helptags $HOME/.vim/doc/

" }}}1
" Encodings: 文字コード設定 =========================================== {{{1

" from ずんWiki http://www.kawaz.jp/pukiwiki/?vim#content_1_7
if &encoding !=# 'utf-8'
	set encoding=japan
endif

"set fileencoding=japan
if has('iconv')
	let s:enc_euc = 'euc-jp'
	let s:enc_jis = 'iso-2022-jp'
	" iconvがJISX0213に対応しているかをチェック
	if iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
		let s:enc_euc = 'euc-jisx0213'
		let s:enc_jis = 'iso-2022-jp-3'
	endif
	" fileencodingsを構築
	if &encoding ==# 'utf-8'
		let s:fileencodings_default = &fileencodings
		let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
		let &fileencodings = &fileencodings .','. s:fileencodings_default
		unlet s:fileencodings_default
	else
		let &fileencodings = &fileencodings .','. s:enc_jis
		set fileencodings+=utf-8,ucs-2le,ucs-2
		if &encoding =~# '^euc-\%(jp\|jisx0213\)$'
			set fileencodings+=cp932
			set fileencodings-=euc-jp
			set fileencodings-=euc-jisx0213
			let &encoding = s:enc_euc
		else
			let &fileencodings = &fileencodings .','. s:enc_euc
		endif
	endif
	" 定数を処分
	unlet s:enc_euc
	unlet s:enc_jis
endif

" □ とか○ の文字があってもカーソル位置がずれないようにする
if exists('&ambiwidth')
	set ambiwidth=double
endif
" }}}1
" Mouse: マウス設定 =================================================== {{{1
" どのモードでもマウスを使えるようにする
set mouse=a
" マウスの移動でフォーカスを自動的に切替えない (mousefocus:切替る)
set nomousefocus
" 入力時にマウスポインタを隠す (nomousehide:隠さない)
set mousehide
" ビジュアル選択(D&D他)を自動的にクリップボードへ (:help guioptions_a)
set guioptions+=a
"set guioptions-=T                       " ツールバーを表示しない
set ttymouse=xterm2

" OSのクリップボードを使用する
" set clipboard+=unnamed

" }}}1
" Command: コマンド設定  ============================================== {{{1

"best_of_tipsを開く
command! Btips1 :silent e $HOME/.vim/doc/best_tips1.txt
command! Btips2 :silent e $HOME/.vim/doc/best_tips2.txt

" listcharsを切り替える
"command! ListCharsDispFull set listchars=tab:^-,eol:$,trail:_,nbsp:% list
"command! ListCharsDispTab set listchars=tab:^- list
"command! ListCharsDispEol set listchars=eol:$ list

" カレントディレクトリに移動
command! -bar CD execute 'lcd' expand('%:p:h')
" .gitのあるディレクトリに移動
command! -bar CDGit call CdDotGitDir()

" Ev/Rvでvimrcの編集と反映
command! Ev edit $MYVIMRC
command! Rv source $MYVIMRC

" }}}1
" Autocmd: autocmd設定 ================================================ {{{1
if has("autocmd")
	filetype plugin on
	"ファイルタイプにあわせたインデントを利用する
	filetype indent on
	" これらのftではインデントを無効に
	autocmd FileType html :setlocal indentexpr=
	autocmd FileType xhtml :setlocal indentexpr=
	
	" autocomplpop.vim --------------------------------------------------------
	"コマンドラインウインドウの中はAutoComplPopを停止する
	autocmd CmdwinEnter * AutoComplPopDisable
	autocmd CmdwinLeave * AutoComplPopEnable
	
	" rubycomplete.vim --------------------------------------------------------
	autocmd FileType ruby,eruby setlocal omnifunc=rubycomplete#Complete
	autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
	autocmd FileType ruby,eruby let g:rubycomplete_rails = 1
	autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
	
	" PHPの辞書補完とomni補完 -----------------------------------------------------------
	autocmd FileType php setlocal omnifunc=phpcomplete#CompletePHP
	autocmd FileType php :setlocal dictionary+=~/.vim/dict/php5_functions.dict
	
	" cvsの時は文字コードをeuc-jpに設定 -------------------------------
	autocmd FileType cvs :set fileencoding=euc-jp
	
	" svnの時は文字コードをutf8設定 -----------------------------------
	autocmd FileType svn :setlocal fileencoding=utf-8
	
	" changelog ---------------------------------------------------------------
	autocmd BufNewFile,BufRead *.changelog setf changelog
	
	" rails -------------------------------------------------------------------
	autocmd BufNewFile,BufRead app/**/*.rhtml set fenc=utf-8
	autocmd BufNewFile,BufRead app/**/*.rb set fenc=utf-8
	autocmd FileType ruby :source $HOME/.vim/bundle/ruby-matchit/plugin/ruby-matchit.vim
	
	" freemaker(Javaテンプレートエンジン) -------------------------------------
	autocmd BufNewFile,BufRead *.ftl setf ftl
	
	" git.vim コミット後ログを表示する ----------------------------------------
	"autocmd BufWritePost COMMIT_EDITMSG exe ":bd" | exe ":Cd" | exe ":GitLog"
	
	" markdown
	autocmd BufRead,BufNewFile *.mkd  setf markdown
	autocmd BufRead,BufNewFile *.md  setf markdown
	
	" 前回終了したカーソル行に移動 --------------------------------------------
	autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif
	
	" 設定の保存と復元(カーソル位置や折畳みの状態など)
	"autocmd BufWinLeave ?* silent mkview
	"autocmd BufWinEnter ?* silent loadview
	
	" autoreadで再読み込みする頻度があがる
	augroup vimrc-checktime
		autocmd!
		autocmd WinEnter * checktime
	augroup END
endif

" }}}1
" Options: オプション設定 ============================================= {{{1

syntax on                                " ハイライト on
"set nocompatible                        " vi互換にしない
set ffs=unix,dos,mac                     " 改行文字
"set ffs=unix                            " 改行コードをLFにする(default: unix,dos)
"set encoding=utf-8                      " デフォルトエンコーディング
set ambiwidth=double                     " UTF-8で文字幅表示を２文字分使う
set completeopt=menuone,preview          " 入力モードでの補完についてのオプションのコンマ区切りのリスト(詳細は :help cot)
set complete+=k                          " 辞書ファイルからの単語補間
set nrformats=""                         " 8進数はインクリメントしない
set autoindent                           " オートインデント
set noundofile                           " undoファイルの無効化
set noerrorbells                         " エラー時にベルを鳴らさない
"set novisualbell                        " ヴィジュアルベルを使わない
"set vb t_vb=                            " ビープをならさない
set nolinebreak                          " ホワイト・スペースで折り返さない
"set scrolloff=5                         " スクロール時の余白確保
"set expandtab                           " Insertモードで <Tab> を挿入するとき、代わりに適切な数の空白を使用(onのときにtabを挿入するときはCTRL-V<Tab>)
set tabstop=4                            " 画面上でタブ文字が占める幅
set softtabstop=4                        " <Tab> や <BS> を打ち込んだときにカーソルが動く幅
set shiftwidth=4                         " インデント幅
set smartindent                          " インデントはスマートインデント
set ignorecase                           " 検索文字列が小文字の場合は大文字小文字を区別なく検索する
set smartcase                            " 検索文字列に大文字が含まれている場合は区別して検索する
set wrapscan                             " 検索時に最後まで行ったら最初に戻る
set shortmess=t                          " 'Press RETURN or enter command to continue' を表示しない
set noincsearch                          " 検索文字列入力時に順次対象文字列にヒットさせない
set showcmd                              " 入力中のコマンドをステータスに表示する
set showmatch                            " 括弧入力時の対応する括弧を表示
set showmode                             " 現在のモードを表示
set hlsearch                             " 検索結果文字列をハイライト
set number                               " 行番号を表示する
set nobackup                             " バックアップファイルは作らない
set noswapfile                           " スワップファイル作らない
set wildmenu                             " コマンドライン補完するときに強化されたものを使う
set wildmode=list:longest                " コマンドライン補間をシェルっぽく
set hidden                               " バッファが編集中でもその他のファイルを開けるように
set autoread                             " 外部のエディタで編集中のファイルが変更されたら自動で読み直す
set wrap                                 " 自動折り返し
set laststatus=2                         " 常にステータスラインを表示 (詳細は:he laststatus)
set cmdheight=2                          " コマンドラインの高さ (Windows用gvim使用時はgvimrcを編集すること)
set title                                " タイトルを表示
set lazyredraw                           " マクロなど実行中は描画を中断
set ttyfast                              " 高速ターミナル接続を行う
set foldmethod=marker                    " 折畳み
set cursorline                           " カーソル行を強調表示
set display=uhex                         " 印字不可能文字を16進数で表示
set list                                 " 表示できない文字は '^'を付けて表示し、行末に $ を置く
set listchars=eol:¬,tab:▸\ ,extends:<,trail:.    " タブや改行などの代替文字設定 (ex. tab:>-,extends:<,trail:-,eol:< )
set keywordprg=man\ -a                   " キーワードヘルプコマンドの設定 (default: man or man\ -s)
set viminfo='50,<1000,s100,\"50          " viminfoの上限数など
set backspace=indent,eol,start           " バックスペースを強化する設定
set formatoptions=lmoq                   " テキスト整形オプション，マルチバイト系を追加
set textwidth=0                          " Don't wrap words by default
set history=1000                         " コマンド履歴数
set ruler                                " カーソルが何行目の何列目に置かれているかを表示する
"set paste                               " pasteモードに入る
"set nopaste                             " pasteモードから抜ける
set pastetoggle=<F1>                     " pasteモードの切替え(set paste or set nopaste でも可)
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc
if has('migemo')
    set migemo                           " Migemo用検索
endif

" prg設定
set grepprg="grep"
" }}}1
" StatusLine & Apperance: ステータスライン&表示設定 =================== {{{1
set t_Co=256
set guifont=Ricty_for_Powerline:h12
"set guifont=Inconsolata_for_Powerline:h12:cANSI
set guifontwide=Ricty:h12

" vim-powerlineでフォントにパッチを当てたものを使うようにする設定
let g:Powerline_symbols = 'fancy'
" シンボルを上書きする
let g:Powerline_symbols_override = {
\ 'LINE': 'Caret'
\ }

" vim-powerlineで使用するカラースキーム
" let g:Powerline_theme       = 'solarized256'
" let g:Powerline_colorscheme = 'solarized256'
 
" モード名を上書きする
let g:Powerline_mode_n = 'Normal'
let g:Powerline_mode_i = 'Insert'
let g:Powerline_mode_R = 'Replace'
let g:Powerline_mode_v = 'Visual'
let g:Powerline_mode_V = 'Visual-Line'
let g:Powerline_mode_cv = 'Visual-Block'
let g:Powerline_mode_s = 'Select'
let g:Powerline_mode_S = 'Select-Line'
let g:Powerline_mode_cs = 'Select-Block'

" ファイルへの相対パスを表示する
let g:Powerline_stl_path_style = 'relative'

"ステータスラインに文字コードと改行文字を表示する
" if winwidth(0) >= 120
"  set statusline=%<[%n]%m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}%y\ %{g:HahHah()}\ %F%=[%{GetB()}]\ %{fugitive#statusline()}\ %l,%c%V%8P
" else
"  set statusline=%<[%n]%m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}%y\ %{g:HahHah()}\ %f%=[%{GetB()}]\ %{fugitive#statusline()}\ %l,%c%V%8P
" endif
"ステータスラインに文字コードと改行文字を表示する（ウインドウ幅によって表示項目を調整）
if winwidth(0) >= 120
	set statusline=%<[%n]%m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}%y\ %(%{GitBranch()}\ %)\ %F%=[%{GetB()}]\ %l,%c%V%8P
else
	set statusline=%<[%n]%m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}%y\ %(%{GitBranch()}\ %)\ %F%=[%{GetB()}]\ %l,%c%V%8P
endif

"入力モード時、ステータスラインのカラーを変更
 augroup InsertHook
 autocmd!
 autocmd InsertEnter * highlight StatusLine guifg=#ccdc90 guibg=#2E4340 ctermfg=cyan
 autocmd InsertLeave * highlight StatusLine guifg=#2E4340 guibg=#ccdc90 ctermfg=white
 augroup END

"自動的に QuickFix リストを表示する
autocmd QuickfixCmdPost make,grep,grepadd,vimgrep,vimgrepadd cwin
autocmd QuickfixCmdPost lmake,lgrep,lgrepadd,lvimgrep,lvimgrepadd lwin

function! GetB()
	let c = matchstr(getline('.'), '.', col('.') - 1)
	let c = iconv(c, &enc, &fenc)
	return String2Hex(c)
endfunction
" help eval-examples
" The function Nr2Hex() returns the Hex string of a number.
func! Nr2Hex(nr)
    dfadfads
  let n = a:nr
  let r = ""
  while n
    let r = '0123456789ABCDEF'[n % 16] . r
    let n = n / 16
  endwhile
  return r
endfunc
" The function String2Hex() converts each character in a string to a two
" character Hex string.
func! String2Hex(str)
  let out = ''
  let ix = 0
  while ix < strlen(a:str)
    let out = out . Nr2Hex(char2nr(a:str[ix]))
    let ix = ix + 1
  endwhile
  return out
endfunc

" カレントウィンドウにのみ罫線を引く
augroup cch
	autocmd! cch
	autocmd WinLeave * set nocursorline
	autocmd WinEnter,BufRead * set cursorline
augroup END

" NormalモードとInsertモードでカーソルの形状を変える(iTerm2)->tmuxでvim使うときは駄目。。
let &t_SI = "\e]50;CursorShape=1\x7"
let &t_EI = "\e]50;CursorShape=0\x7"

" }}}1
" Mapping: マッピング設定 ============================================= {{{1

" Macの場合にLeader設定
if has('mac') && has('gui_running')
	let mapleader = "\\"
endif


if has('clipboard')
	noremap <silent> <space>tv :set clipboard=<CR>
	noremap <silent> <space>tc :set clipboard=unnamed<CR>
endif

" <c-[>のタイプがずれた時対策
inoremap <C-@> <C-[>

"noremap <C-Space> <Esc>
"cnoremap <C-Space> <Esc>
"inoremap <C-Space> <Esc>

" command mode 時 Emacs風のキーバインドに
cnoremap <C-B> <Left>
cnoremap <C-F> <Right>
cnoremap <C-A> <Home>
cnoremap <C-E> <END>
cnoremap <C-K> <Up>
cnoremap <C-J> <Down>
cnoremap <C-H> <BS>

" カーソル位置にかかわらず全部消す
cnoremap <C-u> <C-e><C-u>

inoremap <C-B> <Left>
inoremap <C-F> <Right>
inoremap <C-K> <UP>
inoremap <C-J> <DOWN>
inoremap <C-H> <BS>

" そのコマンドを実行
nnoremap ,e :execute '!' &ft ' %'<CR>

" インデントを考慮して貼り付け
nnoremap p p=']

" 表示行単位で行移動する
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk

" 単語の移動
noremap E e
noremap W w
noremap B b

" 標準の単語選択
vnoremap <space>iw iw
vnoremap <space>ie ie

" バッファ移動
map <F2> <ESC>:bp<CR>
map <F3> <ESC>:bn<CR>
map <F4> <ESC>:bw<CR>

" diffsplit したときデフォルトでno wrapなので必要なら使う
map <F5> <ESC>:set wrap<CR>

" カレントファイルの文字コードを変更する
map <F7>e <ESC>:set fileencoding=euc-jp<CR>
map <F7>s <ESC>:set fileencoding=cp932<CR>
map <F7>u <ESC>:set fileencoding=utf8<CR>
map <F7>n <ESC>:set fileformat=unix<CR>
map <F7>r <ESC>:set fileformat=dos<CR>

" カレントファイルを指定文字コードで読み直す
map <F8>e <ESC>:e ++enc=euc-jp<CR>
map <F8>s <ESC>:e ++enc=cp932<CR>
map <F8>u <ESC>:e ++enc=utf8<CR>

" Shift-K で使う辞書設定
map <F9>m <ESC>:set keywordprg=man\ -a<CR>
map <F9>pm <ESC>:set keywordprg=perldoc<CR>
map <F9>pf <ESC>:set keywordprg=perldoc\ -f<CR>
map <F9>d <ESC>:set keywordprg=dic<CR>
map <F9>j <ESC>:set keywordprg=dic\ -j<CR>
map <F9>e <ESC>:set keywordprg=eword<CR>

" 翻訳する(先にv/Vで範囲指定する)
map <F10> :w !trans -d<CR>

" 折り返し行関係なく上下移動する
nnoremap j gj
nnoremap k gk

" 分割ウィンドウの移動
"map <Right> <c-w>l
"map <Left> <c-w>h
"map <Up> <c-w>k
"map <Down> <c-w>j

" 分割ウィンドウのサイズ変更
map <Right> <c-w>>
map <Left> <c-w><
map <Up> <c-w>-
map <Down> <c-w>+
"map <kPlus> <C-W>+
"map <kMinus> <C-W>-
"map <kDivide> <c-w>< 
"map <kMultiply> <c-w>> 

" 選択時にペーストしたときに最後のレジスタを上書きする
vnoremap <silent> p p:call SelectPasteTextOverWriteRegister()<cr>

" マウス有効無効設定
map <F11> <ESC>:set mouse=a<CR>
map <F12> <ESC>:set mouse=<CR>

" マウス操作でスクロールした時に誤操作で意図しないペーストをしない
noremap <MiddleMouse> <Nop>
inoremap <MiddleMouse> <Nop>

"クリップボードを使ったコピペ
vnoremap <M-c> "+y
inoremap <M-v> <MiddleMouse>
nnoremap <M-v> i<MiddleMouse><esc>

" 全て選択
nnoremap <space>V ggVG
" 改行を含まない1行選択
nnoremap <space>v 0v$h

"rubyのメソッドやクラスをまとめて選択する(b:block用、m:def用、c:class用、M:module用)
nnoremap vab 0/end<CR>%Vn
nnoremap vib 0/end<CR>%kVnj
nnoremap vam $?\%(.*#.*def\)\@!def<CR>%Vn
nnoremap vim $?\%(.*#.*def\)\@!def<CR>%kVnj
nnoremap vac $?\%(.*#.*class\)\@!class<CR>%Vn
nnoremap vic $?\%(.*#.*class\)\@!class<CR>%kVnj
nnoremap vaM $?\%(.*#.*module\)\@!module<CR>%Vn
nnoremap viM $?\%(.*#.*module\)\@!module<CR>%kVnj

" カーソル位置キーワードをカレントディレクトリファイルからgrep...?
"map _g :let efsave=&ef<Bar>let &ef=tempname()<Bar>exe ':!grep -n -w "<cword>" * >'.&ef<CR>:cf<CR>:exe ":!rm ".&ef<CR>:let &ef=efsave<Bar>unlet efsave<CR><CR>:cc<CR>

" .vimrcの再読み込み
nnoremap ,vr :source ~/.vimrc<CR>
" nnoremap ,vr :source $HOME/.vimrc<CR>:source $HOME/.gvimrc<CR>

" YankRingっぽいレジスタ履歴Yank&Paste
vnoremap <silent> y <ESC>:call NumberedRegisterRotation()<CR>gvy
vnoremap <silent> x <ESC>:call NumberedRegisterRotation()<CR>gvx
vnoremap <silent> d <ESC>:call NumberedRegisterRotation()<CR>gvd
nnoremap <silent> yy :call NumberedRegisterRotation()<CR>yy
nnoremap <silent> dd :call NumberedRegisterRotation()<CR>dd
inoremap <C-Space><C-n> <C-R>=RegistersComplete()<CR>
nnoremap <C-Space><C-n> i<C-R>=RegistersComplete()<CR>

" 設定をトグルする {{{2
nnoremap <silent> <space>tw :set wrap!<CR>
" }}}2

" 設定を有効にする {{{2
nnoremap <silent> <space>ea :AutoComplPopEnable<CR>
" }}}2

" 設定を無効にする {{{2
nnoremap <silent> <space>da :AutoComplPopDisable<CR>
" }}}2

" 検索時に画面中央にくるようにする
" nzzを割り当てるとfold時の検索でnを押して次に進んだ場合に自動展開されない
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap * *zzzv
nnoremap # #zzzv
nnoremap g* g*zzzv
nnoremap g# g#zzzv

" 選択中の文字を検索する
"vnoremap <silent> n :call SelSearch()<CR>
vnoremap <silent> n :call SearchTheSelectedTextLiteraly()<CR>

" 選択中の文字をURLエスケープする（1:エンコード 2:デコード）
vnoremap <silent> <space>ue :call UrlEscapeTheSelectedTextLiteraly(1)<CR>
vnoremap <silent> <space>ud :call UrlEscapeTheSelectedTextLiteraly(2)<CR>

" migemo検索用(incsearchの設定を行う)
"nnoremap g/ :set incsearch<CR>g/
"nnoremap g? :set incsearch<CR>g?
" perl系正規表現検索用(/でLL系正規表現が使えるようにする。※eregex.vimを使う）
"nnoremap / :set noincsearch<CR>:M/
" vim正規表現検索用(元のデフォルトの/検索は）
"nnoremap ,/ :set noincsearch<CR>/
"nnoremap ?  :set noincsearch<CR>?

" textobj-datetimeの設定
silent! call textobj#datetime#default_mappings(1)

"ScreenのキーバインドでC-Tを割り当てているため、タグジャンプの戻るはc-[に割り当てる。
nnoremap <M-]> :pop<CR>
" tags key map (C-z を C-tに,C-tはGNU/screenとかぶる)
noremap <C-z> <C-t>

" 選択中のCSVカラム名の列をハイライト表示する
vnoremap <silent> ,hc :call SelectCsvH()<CR>

if has("win32")
	" 画面の最大化と元のサイズをキーに割り当て
	noremap <silent> <F2> :simalt ~x<CR>
	noremap <silent> <F3> :simalt ~r<CR>
	"文字の大きさ変更キーマップ
	noremap _w :simalt ~r<CR>:set guifont=MS_Gothic:h12:cSHIFTJIS<CR>:set columns=110<CR>:set lines=30<CR>
	noremap _1 :simalt ~r<CR>:set columns=110 lines=30<CR>
	noremap _2 :simalt ~x<CR>:let &guifont=substitute(&guifont, ":h\\d\\+:", ":h16:", "")<CR>
	noremap _3 :simalt ~x<CR>:let &guifont=substitute(&guifont, ":h\\d\\+:", ":h18:", "")<CR>
	noremap _4 :simalt ~x<CR>:let &guifont=substitute(&guifont, ":h\\d\\+:", ":h20:", "")<CR>
	noremap _5 :simalt ~x<CR>:let &guifont=substitute(&guifont, ":h\\d\\+:", ":h24:", "")<CR>
	noremap _6 :simalt ~x<CR>:let &guifont=substitute(&guifont, ":h\\d\\+:", ":h32:", "")<CR>
	noremap _7 :simalt ~x<CR>:let &guifont=substitute(&guifont, ":h\\d\\+:", ":h48:", "")<CR>
endif

" 異なるプロセスvim間でコピー（yanktmp.vim用）
noremap <silent> sy :call YanktmpYank()<CR>
noremap <silent> sp :call YanktmpPaste_p()<CR>
noremap <silent> sP :call YanktmpPaste_P()<CR>

" 水平スクロール
nnoremap <C-l> zl
nnoremap <C-h> zh

"FuzzyFinder時にCtrl-Dで一行消しできるように
inoremap <silent> <c-d> \<c-r>=repeat('', setline('.', ''))<cr>

" phpdocumenter.php
nnoremap <space>ppd :call PhpDocSingle()<CR>
vnoremap <space>ppd :call PhpDocRange()<CR>

" }}}1
" Plugin: プラグイン設定 ============================================== {{{1

" Vimball 
if has('win32')
    let g:vimball_home = "C:/configs/.vim/"
else
    let g:vimball_home = "~/configs/.vim/"
endif

" QuickFix
noremap mm <Plug>QuickFixNote
noremap <silent> <F9> :copen<CR>
noremap ms <Plug>QuickFixSave

" Gauche
autocmd FileType scheme :let is_gauche=1
autocmd FileType scheme :setlocal dictionary+=~/.vim/dict/gosh_completions.dict

" for golang
" :Fmt などで gofmt の代わりに goimports を使う
let g:gofmt_command = 'goimports'

" Go に付属の plugin と gocode を有効にする
set rtp^=${GOROOT}/misc/vim
set rtp^=${GOPATH}/src/github.com/nsf/gocode/vim

" 保存時に :Fmt する
au BufWritePre *.go Fmt
au BufNewFile,BufRead *.go set sw=4 noexpandtab ts=4
au FileType go compiler go

" QuicRun ----------------------------------------------------- {{{2
nnoremap <Space>e :QuickRun<CR>
let g:quickrun_config = {}
let g:quickrun_config['markdown'] = {
      \ 'type': 'markdown/pandoc',
      \ 'outputter': 'browser',
      \ 'cmdopt': '-c ~/style.css -s'
      \ }

" git.vim ----------------------------------------------------- {{{2
nnoremap <Space>gs  :CD \| GitStatus<CR>
nnoremap <Space>ga  :CD \| GitAdd
nnoremap <Space>gac :CD \| GitAdd <C-r>=expand("%:t")<CR><CR>
nnoremap <Space>gd  :CD \| GitDiff 
nnoremap <Space>gc  :CDGit \| GitCommit<CR>
nnoremap <Space>gcs :CDGit \| GitCommit 
nnoremap <Space>gca :CDGit \| GitCommit -a<CR>
nnoremap <Space>gcc :CDGit \| GitCommit <C-r>=expand("%:t")<CR><CR>
nnoremap <Space>gl  :CD \| GitLog<CR>
nnoremap <Space>gs  :CD \| GitStatus<CR>
" ":CD<CR> :GitStatus<CR>"では<Space> (:help <Space>)が実行されてしまう。
"nnoremap <space>gs  :CD<CR> :GitStatus<CR>

" }}}2
" project.vim ------------------------------------------------------------- {{{2
let g:proj_window_width = 32
 
" CamelCase Motion -------------------------------------------------------- {{{2

" Replace the default 'w', 'b' and 'e' mappings instead of defining
nmap <silent> w <Plug>CamelCaseMotion_w
nmap <silent> b <Plug>CamelCaseMotion_b
nmap <silent> e <Plug>CamelCaseMotion_e

" Replace default 'iw' text-object and define 'ie' and 'ib' motions: 
omap <silent> iw <Plug>CamelCaseMotion_iw
vmap <silent> iw <Plug>CamelCaseMotion_iw
omap <silent> ib <Plug>CamelCaseMotion_ib
vmap <silent> ib <Plug>CamelCaseMotion_ib
omap <silent> ie <Plug>CamelCaseMotion_ie
vmap <silent> ie <Plug>CamelCaseMotion_ie
" sqlUtil ----------------------------------------------------------------- {{{2
let g:sqlutil_align_where = 1
let g:sqlutil_align_comma = 1

" SourceExplorer ---------------------------------------------------------- {{{2
"自動でプレビューを表示する。TODOうざくなってきたら手動にする。またはソースを追う時だけ自動に変更する
let g:SrcExpl_RefreshTime   = 1
"プレビューウインドウの高さ
let g:SrcExpl_WinHeight     = 9
"tagsは自動で作成する
let g:SrcExpl_UpdateTags    = 1
let g:SrcExpl_RefreshMapKey = "<Space>"
let g:SrcExpl_GoBackMapKey  = "<C-b>"
nnoremap <F8> :SrcExplToggle<CR>
let g:SrcExpl_pluginList = [
         \ "__Tag_List__",
         \ "_NERD_tree_",
         \ "Source_Explorer"
     \ ]

"FuzzyFinder用 ----------------------------------------------------------- {{{2
nnoremap <silent> <space>fb :FuzzyFinderBuffer<CR>
nnoremap <silent> <space>fc :FuzzyFinderMruCmd<CR>
nnoremap <silent> <space>fd :FuzzyFinderDir<CR>
nnoremap <silent> <space>ff :FuzzyFinderFile<CR>
nnoremap <silent> <space>fm :FuzzyFinderMruFile<CR>
nnoremap <silent> <space>fv :FuzzyFinderBookmark<CR>
nnoremap <silent> <space>ft :FuzzyFinderTag<CR>



"speeddating.vim用のマッピング ------------------------------------------- {{{2
" システム日付を挿入する
inoremap <leader>dF  <C-r>=strftime('%Y-%m-%dT%H:%M:%S+09:00')<Return>
inoremap <leader>df  <C-r>=strftime('%Y-%m-%dT%H:%M:%S')<Return>
inoremap <leader>dd  <C-r>=strftime('%Y-%m-%d')<Return>
inoremap <leader>dT  <C-r>=strftime('%H:%M:%S')<Return>
inoremap <leader>dt  <C-r>=strftime('%H:%M')<Return>

" calender.vim ------------------------------------------------------------ {{{2
"let g:calendar_erafmt = '平成,-1988'
"let g:calendar_mruler ='1月,2月,3月,4月,5月,6月,7月,8月,9月,10月,11月,12月'
"let g:calendar_wruler = '日 月 火 水 木 金 土 日'

" NERD_comments.vim ------------------------------------------------------- {{{2
" コメントの間にスペースを空ける
let NERDSpaceDelims = 1
" 対応していないファイルに対して警告をしない
let NERDShutUp = 1

" netrw ------------------------------------------------------------------- {{{2
let g:netrw_ftp_cmd="netkit-ftp"  " netrw-ftp
let g:netrw_http_cmd="wget -q -O" " netrw-http

" surround.vim ------------------------------------------------------------ {{{2
"surroundに定義を追加する【ASCIIコードを調べるには:echo char2nr("-")】
"タグ系
let g:surround_{char2nr('!')} = "<!-- \r -->"
let g:surround_{char2nr('%')} = "<% \r %>"
let g:surround_{char2nr('-')} = "<!-- \r -->"
"変数展開系
let g:surround_{char2nr('#')} = "#{\r}"
let g:surround_{char2nr('$')} = "${\r}"
let g:surround_{char2nr('@')} = "@{\r}"

" tabbar.vim -------------------------------------------------------------- {{{2
let g:Tb_MaxSize=3
" }}}2
" scratch.vim  ------------------------------------------------------------ {{{2
let g:scratch_buffer_name = "Scratch"
" }}}2

" }}}1
" NeoBundle: Plugin設定 =============================================== {{{1
"Absorb vimrc/.vim in Windows 
if has('win32') || has ('win64')
	set shellslash
	let $VIMFILES = $USERPROFILE.'\git\config\vim\dot.vim'
else
	let $VIMFILES = $HOME."/.vim"
endif

if has('vim_starting') && (has('win32') || has('win64'))
	set runtimepath+=~/git/config/vim/dot.vim
endif

" Configure bundles
" Note: Skip initialization for vim-tiny or vim-small."
if !1 | finish | endif

if has('vim_starting')
	if &compatible
		set nocompatible
	endif
	set runtimepath+=$VIMFILES/bundle/neobundle.vim
endif

call neobundle#begin(expand('~/.vim/bundle'))

" Let NeoBundle manage NeoBundle
NeoBundleFetch 'Shougo/neobundle.vim'

" My Bundles here:
" Refer to |:NeoBundle-examples|.
" Note: You don't set neobundle setting in .gvimrc!

" Edit {{{2
" NERD_commenter.vim :最強コメント処理 (<Leader>c<space>でコメントをトグル)
NeoBundle 'scrooloose/nerdcommenter.git'

" 自動閉じタグ
NeoBundle 'yuroyoro/vim-autoclose'

" -- でメソッドチェーン整形
NeoBundle 'c9s/cascading.vim'

" visually indent guide
NeoBundle 'nathanaelkane/vim-indent-guides'

" XMLとかHTMLとかの編集機能を強化する
NeoBundle 'xmledit'

" Align : 高機能整形・桁揃えプラグイン
NeoBundle 'Align'

" フィルタリングと整形
NeoBundle 'godlygeek/tabular'

" マルチバイト対応の整形
NeoBundle 'h1mesuke/vim-alignta'

" YankRing.vim : ヤンクの履歴を管理し、順々に参照、出力できるようにする
NeoBundle 'YankRing.vim'

" undo履歴を追える (need python support)
NeoBundle 'Gundo'

" surround.vim : テキストを括弧で囲む／削除する
NeoBundle 'vim-scripts/surround.vim'

" smartchr.vim : ==などの前後を整形
NeoBundle 'smartchr'

" vim-operator-user : 簡単にoperatorを定義できるようにする
NeoBundle 'operator-user'

" operator-camelize : camel-caseへの変換
NeoBundle 'operator-camelize'

" operator-replace : yankしたものでreplaceする
NeoBundle 'operator-replace'

" textobj-user : 簡単にVimエディタのテキストオブジェクトをつくれる
" NeoBundle 'textobj-user'

" vim-textobj-syntax : syntax highlightされたものをtext-objectに
NeoBundle 'kana/vim-textobj-syntax.git'

" vim-textobj-plugins : いろんなものをtext-objectにする
" NeoBundle 'thinca/vim-textobj-plugins.git'

" vim-textobj-lastpat : 最後に検索されたパターンをtext-objectに
NeoBundle 'kana/vim-textobj-lastpat.git'

" vim-textobj-indent : インデントされたものをtext-objectに
NeoBundle 'kana/vim-textobj-indent.git'

" vim-textobj-function : 関数の中身をtext-objectに
NeoBundle 'kana/vim-textobj-function.git'

" vim-textobj-fold : 折りたたまれたアレをtext-objectに
" NeoBundle 'kana/vim-textobj-fold.git'

NeoBundle 'textobj-rubyblock'

" vim-textobj-entire : buffer全体をtext-objectに
NeoBundle 'textobj-entire'

" 「foo」 or 【bar】などをtext-objectに
NeoBundle 'textobj-jabraces'

" 改造したmonday.vim(git rebase -i とかtrue/falseとか)
" NeoBundle 'yuroyoro/monday'

" <C-a>でtrue/false切替。他色々
NeoBundle 'taku-o/vim-toggle'

" root権限でファイルを編集/保存できるようにする
NeoBundle 'sudo.vim'
" ex.
" コマンドラインから実行: vim sudo:<filename>
" 複数のファイルを開く時にsudo対象のファイルを選択: vim <filename> sudo:<filename> <filename>
" 現在開いているファイルをsudoを実行して開く :e sudo:%
" }}}2


" Completion {{{2
" 補完 autocomplpop.vim : insertmodeで自動で補完をpopup
NeoBundle 'vim-scripts/AutoComplPop'

" 補完 neocomplcache.vim : 究極のVim的補完環境
NeoBundle 'Shougo/neocomplcache'

" neocomplcacheのsinpet補完
NeoBundle 'Shougo/neosnippet'

" for rsense
NeoBundle 'm2ym/rsense'
" NeoBundle 'taichouchou2/vim-rsense'

" rubyでrequire先を補完する
NeoBundle 'ujihisa/neco-ruby'

" A neocomplcache plugin for English, using look command
NeoBundle 'ujihisa/neco-look'
" }}}2


" Searching/Moving{{{2
" smooth_scroll.vim : スクロールを賢く
NeoBundle 'Smooth-Scroll'

" vim-smartword : 単語移動がスマートな感じで
NeoBundle 'smartword'

" camelcasemotion : CamelCaseやsnake_case単位でのワード移動
NeoBundle 'camelcasemotion'

" <Leader><Leader>w/fなどで、motion先をhilightする
NeoBundle 'EasyMotion'

" matchit.vim : 「%」による対応括弧へのカーソル移動機能を拡張
NeoBundle 'matchit.zip'

" ruby用のmatchit拡張
NeoBundle 'ruby-matchit'

" grep.vim : 外部のgrep利用。:Grepで対話形式でgrep :Rgrepは再帰
NeoBundle 'grep.vim'

" eregex.vim : vimの正規表現をrubyやperlの正規表現な入力でできる :%S/perlregex/
NeoBundle 'eregex.vim'

" open-browser.vim : カーソルの下のURLを開くor単語を検索エンジンで検索
NeoBundle 'tyru/open-browser.vim'
" }}}2


" Programming {{{2
" quickrun.vim : 編集中のファイルを簡単に実行できるプラグイン
NeoBundle 'thinca/vim-quickrun'

" perldocやphpmanual等のリファレンスをvim上で見る
NeoBundle 'thinca/vim-ref'

" SQLUtilities : SQL整形、生成ユーティリティ
NeoBundle 'SQLUtilities'

" vim-ruby : VimでRubyを扱う際の最も基本的な拡張機能
NeoBundle 'vim-ruby/vim-ruby'

" rails.vim : rails的なアレ
NeoBundle 'tpope/vim-rails'

" Pydiction : Python用の入力補完
" NeoBundle 'Pydiction'

" ソースコード上のメソッド宣言、変数宣言の一覧を表示
" NeoBundle 'taglist.vim'

" エラーがある場所をhilight
" NeoBundle 'errormarker.vim'

" tagsを利用したソースコード閲覧・移動補助機能 tagsファイルの自動生成
NeoBundle 'Source-Explorer-srcexpl.vim'

" NERD_tree, taglist, srcexpl の統合
" NeoBundle 'trinity.vim'
" }}}2


" Syntax {{{2
" haml
NeoBundle 'haml.zip'

" JavaScript
NeoBundle 'JavaScript-syntax'

" jQuery
NeoBundle 'jQuery'

" nginx conf
NeoBundle 'nginx.vim'

" markdown
NeoBundle 'tpope/vim-markdown'

" coffee script
NeoBundle 'kchmck/vim-coffee-script'

" python
NeoBundle 'yuroyoro/vim-python'

" scala
NeoBundle 'yuroyoro/vim-scala'

" golang
NeoBundle 'google/vim-ft-go'
" NeoBundle 'dgryski/vim-godef' "vim-ft-goは最新版のvimを使えない場合のみ
NeoBundle 'fatih/vim-go'
NeoBundle 'vim-jp/vim-go-extra'

" clojure
NeoBundle 'jondistad/vimclojure'

" ghc-mod
NeoBundle 'eagletmt/ghcmod-vim'

" syntax checking plugins exist for eruby, haml, html, javascript, php, python, ruby and sass.
NeoBundle 'scrooloose/syntastic'
" }}}2


" Buffer {{{2
" DumbBuf.vim : quickbufっぽくbufferを管理。 "<Leader>b<Space>でBufferList
" NeoBundle 'DumbBuf'

" minibufexpl.vim : タブエディタ風にバッファ管理ウィンドウを表示
" NeoBundle 'minibufexpl.vim'

" NERDTree : ツリー型エクスプローラ
NeoBundle 'The-NERD-tree'

" vtreeexplorer.vim : ツリー状にファイルやディレクトリの一覧を表示
NeoBundle 'vtreeexplorer'
" }}}2


" Encording {{{2
NeoBundle 'banyan/recognize_charcode.vim'
" }}}2


" Utility {{{2
" vimshell : vimのshell
NeoBundle 'Shougo/vimshell'

" vimproc : vimから非同期実行。vimshelleで必要
NeoBundle 'Shougo/vimproc', {
  \ 'build' : {
    \ 'windows' : 'make -f make_mingw32.mak',
    \ 'cygwin' : 'make -f make_cygwin.mak',
    \ 'mac' : 'make -f make_mac.mak',
    \ 'unix' : 'make -f make_unix.mak',
  \ },
\ }

" vim上でのファイル操作
NeoBundle 'Shougo/vimfiler'

" vim-altercmd : Ex command拡張
NeoBundle 'tyru/vim-altercmd'

" vim Interface to Web API
NeoBundle 'mattn/webapi-vim'

" cecutil.vim : 他のpluginのためのutillity1
NeoBundle 'cecutil'

" urilib.vim : vim scriptからURLを扱うライブラリ
NeoBundle 'tyru/urilib.vim'

" ステータスラインに顔文字を表示
" NeoBundle 'mattn/hahhah-vim'

" utillity
NeoBundle 'L9'

" Buffer管理のLibrary
NeoBundle 'thinca/vim-openbuf'

" vimdoc 日本語
NeoBundle 'yuroyoro/vimdoc_ja'

" vim上のtwitter client
NeoBundle 'TwitVim'

" Lingrのclient
NeoBundle 'tsukkee/lingr-vim'

" vimからGit操作する
NeoBundle 'tpope/vim-fugitive'

" ステータスラインをカッコよくする
" NeoBundle 'Lokaltog/vim-powerline'
NeoBundle 'delphinus35/vim-powerline'

" Redmine on Vim
NeoBundle 'mattn/vim-metarw-redmine'

" A framework to read/write fake:path
NeoBundle 'kana/vim-metarw'

"   "
NeoBundle 'kana/vim-metarw-git'
" }}}2


" ColorSchema{{{2
" color schema 256
NeoBundle 'desert256.vim'
NeoBundle 'mrkn256.vim'
NeoBundle 'tomasr/molokai'
NeoBundle 'yuroyoro/yuroyoro256.vim'
NeoBundle 'altercation/vim-colors-solarized'
NeoBundle 'croaker/mustang-vim'
NeoBundle 'jeffreyiacono/vim-colors-wombat'
NeoBundle 'nanotech/jellybeans.vim'
NeoBundle 'vim-scripts/Lucius'
NeoBundle 'vim-scripts/Zenburn'
NeoBundle 'jpo/vim-railscasts-theme'
NeoBundle 'therubymug/vim-pyte'
" }}}2


" Unite {{{2
" Unite.vim : - すべてを破壊し、すべてを繋げ - vim scriptで実装されたanythingプラグイン
" カラースキーム一覧表示に Unite.vim を使う
NeoBundle 'Shougo/unite.vim'
NeoBundle 'taka84u9/unite-git'
NeoBundle 'h1mesuke/unite-outline'
NeoBundle 'Sixeight/unite-grep'
NeoBundle 'tsukkee/unite-help'
NeoBundle 'thinca/vim-unite-history'
NeoBundle 'ujihisa/unite-font'
NeoBundle 'tsukkee/unite-tag'
NeoBundle 'choplin/unite-vim_hacks'
NeoBundle 'ujihisa/unite-colorscheme'
NeoBundle 'basyura/unite-rails'
NeoBundle 'ujihisa/unite-gem'
" }}}2


" その他 {{{2
NeoBundle 'tyru/restart.vim'
NeoBundle 'git@github.com:sorah/metarw-simplenote.vim.git'
NeoBundle 'motemen/git-vim'
NeoBundle 'ujihisa/vimshell-ssh'
" NeoBundle 'mattn/zencoding-vim'
NeoBundle 'godlygeek/csapprox'
NeoBundle 'ujihisa/shadow.vim'
NeoBundle 'cakebaker/scss-syntax.vim'
NeoBundle 'tpope/vim-haml'
NeoBundle 'groenewege/vim-less'
NeoBundle 'thinca/vim-scouter'
NeoBundle 'tyru/eskk.vim'
NeoBundle 'tyru/skkdict.vim'
NeoBundle 'kana/vim-textobj-user'
NeoBundle 'nelstrom/vim-textobj-rubyblock'
NeoBundle 'thinca/vim-splash'			"Vim を引数なしで起動した場合に任意のテキストファイル(defaultではVim Girl)を表示, 作業中は :Splashで表示可 
" }}}2

filetype plugin indent on
runtime macros/matchit.vim

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck

call neobundle#end()

" Color: 色設定 ======================================================= {{{1
" 特定の文字を視覚化。この例では全角スペース
" TODO:listcharsの設定と調整する
highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=white
match ZenkakuSpace /　/
if !has('gui_running')
	set background=dark
	highlight Folded ctermfg=yellow ctermbg=black 
	highlight FoldColumn ctermfg=yellow ctermbg=black 
	highlight Pmenu ctermfg=white ctermbg=darkgray  guibg=#606060
	highlight PmenuSel ctermbg=darkred guibg=SlateBlue
	highlight PmenuSbar ctermbg=darkblue guibg=#404040
endif

" ColorScheme選択
" colorscheme mrkn256
" colorscheme yuroyoro256
" colorscheme desert256
" colorscheme desert
" colorscheme Lucius
" colorscheme molokai
" colorscheme mustang
colorscheme jellybeans
" colorscheme solarized
" colorscheme Zenburn

" highlight設定
hi clear CursorLine
hi CursorLine cterm=underline gui=underline     " 下線
"highlight CursorLine ctermfg=white ctermbg=red guifg=white guibg=red
"highlight CursorLine cterm=underline ctermfg=NONE ctermbg=NONE
highlight SpecialKey term=underline ctermfg=white guifg=white

""行頭のスペースの連続をハイライトさせる
""Tab文字も区別されずにハイライトされるので、区別したいときはTab文字の表示を別に
""設定する必要がある。
"function! SOLSpaceHilight()
"	syntax match SOLSpace "^\s\+" display containedin=ALL
"	highlight SOLSpace term=underline ctermbg=LightGray
"endf
""全角スペースをハイライトさせる。
"function! JISX0208SpaceHilight()
"	syntax match JISX0208Space "　" display containedin=ALL
"	highlight JISX0208Space term=underline ctermbg=LightCyan
"endf
""syntaxの有無をチェックし、新規バッファと新規読み込み時にハイライトさせる
"if has("syntax")
"	syntax on
"		augroup invisible
"		autocmd! invisible
"		autocmd BufNew,BufRead * call SOLSpaceHilight()
"		autocmd BufNew,BufRead * call JISX0208SpaceHilight()
"	augroup END
"endif

" ターミナルタイプによるカラー設定
"if &term =~ "xterm-256color" || "screen-256color"
	" 256色
	"set t_Co=256
	"set t_Sf=[3%dm
	"set t_Sb=[4%dm
"elseif &term =~ "xterm-debian" || &term =~ "xterm-xfree86"
	"set t_Co=16
	"set t_Sf=[3%dm
	"set t_Sb=[4%dm
"elseif &term =~ "xterm-color"
	"set t_Co=8
	"set t_Sf=[3%dm
	"set t_Sb=[4%dm
"endif

" ポップアップメニューのカラーを設定
hi Pmenu guibg=#666666
hi PmenuSel guibg=#8cd0d3 guifg=#666666
hi PmenuSbar guibg=#333333

" 補完候補の色づけ for vim7
 hi Pmenu ctermbg=255 ctermfg=0 guifg=#000000 guibg=#999999
 hi PmenuSel ctermbg=blue ctermfg=black
 hi PmenuSel cterm=reverse ctermfg=33 ctermbg=222 gui=reverse guifg=#3399ff guibg=#f0e68c
 hi PmenuSbar ctermbg=0 ctermfg=9
 hi PmenuSbar ctermbg=255 ctermfg=0 guifg=#000000 guibg=#FFFFFF

" }}}1
" Tags: tags設定 ====================================================== {{{1
if has("autochdir")
	set autochdir
	set tags=tags;
else
	"set tags=$HOME/.vim/tags,./tags,./../tags,./*/tags,./../../tags,./../../../tags,./../../../../tags,./../../../../../tags
	set tags+=./tags
endif
command! -nargs=? Ctags call <SID>Ctags(<q-args>)

" }}}1
" Function: 関数定義 ================================================== {{{1
"--------------------------------------------------------
" ステータスライン表示に使用する関数群
" -------------------------------------------------------
function! GetB()
	let c = matchstr(getline('.'), '.', col('.') - 1)
	let c = iconv(c, &enc, &fenc)
	return String2Hex(c)
endfunction
function! Nr2Hex(nr)
	let n = a:nr
	let r = ""
	while n
		let r = '0123456789ABCDEF'[n % 16] . r
		let n = n / 16
	endwhile
	return r
endfunc

function! String2Hex(str)
	let out = ''
	let ix = 0
	while ix < strlen(a:str)
		let out = out . Nr2Hex(char2nr(a:str[ix]))
		let ix = ix + 1
	endwhile
	return out
endfunc

"-------------------------------------------------------------------
"Screenのステータスラインに編集中のファイルを表示し、
" 終了時にはShellと表示する。※^[ はctrl + v を押しながら [
"-------------------------------------------------------------------
function! SetScreenTabName(name)
	let arg = 'k' . a:name . ' > vim \\'
	silent! exe '!echo -n "' . arg . "\""
endfunction

"-------------------------------------------------------------------
"　自動補完をタブで選択できるように(cho45さんから)
" http://subtech.g.hatena.ne.jp/cho45/20071009#c1191925480
"-------------------------------------------------------------------
function! InsertTabWrapper() 
	let col = col('.') - 1 
	if !col || getline('.')[col - 1] !~ '\k' 
		return "\<TAB>"
	else
		if pumvisible()
			return "\<C-N>"
		else
			return "\<C-N>\<C-P>"
		end
	endif
endfunction
" インサート時のTabキーマッピングをInsertTabWrapperで書き換える
inoremap <silent> <tab> <c-r>=InsertTabWrapper()<cr>


"------------------------------------------------
" CSVのハイライト表示
" @see http://www.vim.org/tips/tip.php?tip_id=667
"------------------------------------------------
" csv の特定のカラムをハイライト (put in .vimrc)
" :Csv 5   # 5番めのカラムをハイライト
function! CSVH(x)
	execute 'match Keyword /^\([^,]*,\)\{'.a:x.'}\zs[^,]*/'
	execute 'normal ^'.a:x.'f,'
endfunction
command! -nargs=1 Csv :call CSVH(<args>)

"-----------------------------
" カラム名からIndex値を取得する
"-----------------------------
function! CsvCol2Index(colName)
ruby << EOF
	colName = VIM::evaluate("a:colName")
	columns = eval("[#{VIM::Buffer.current.line}]")
	colIndex = columns.index(colName) || -1
	VIM::command("return '#{colIndex.to_s#}'")
EOF
endfunction

"------------------------------------------------
" 選択中のCSVカラムをハイライトする
"------------------------------------------------
function! SelectCsvH()
	" 最後のヤンクを保管しておく
	let tmp = @"
	" 現在選択中のテキストを取得する
	normal! gv"ty
	" 取得した結果を変数に格納する
	let seltext=@t
	let columnNumber = CsvCol2Index(seltext)
	if columnNumber >= 0
		let result = CSVH(columnNumber)
	else
		echo "対象のカラムは存在しません"
	endif
	" 最後のヤンクを書き戻す
	let @" = tmp
	let @/ = seltext
endfunction

"-----------------------------
" html escape function
"-----------------------------
function! HtmlEscape()
	silent s/&/\&amp;/eg
	silent s/</\&lt;/eg
	silent s/>/\&gt;/eg
endfunction
function! HtmlUnEscape()
	silent s/&lt;/</eg
	silent s/&gt;/>/eg
	silent s/&amp;/\&/eg
endfunction

"------------------------------------------------
"選択中の文字列を検索する
"------------------------------------------------
function! SelSearch()
	"最後のヤンクを保管しておく
	let tmp = @"
	"現在選択中のテキストを取得する
	normal! gv"ty 
	"取得した結果を変数に格納する
	let seltext=@t
	silent! exe ":/" . seltext
	"最後のヤンクを書き戻す
	let @" = tmp
	let @/ = seltext
	"二回の移動を組み合わせることで、次の検索したい文字列へジャンプする
	normal! N
	normal! n
endfunction

function! SearchTheSelectedTextLiteraly()
	let reg_0 = [@0, getregtype('0')]
	let reg_u = [@", getregtype('"')]
	
	normal! gvy
	let @/ = @0
	call histadd('/', '\V' . escape(@0, '\'))
	normal! n
	
	call setreg('0', reg_0[0], reg_0[1])
	call setreg('"', reg_u[0], reg_u[1])
endfunction

"------------------------------------------------
" tagファイル作成関数 
"------------------------------------------------
"taglist.vim用設定
"tagsを使用できるようにする
" tag ファイルの指定
"tagファイル作成関数 
" 使い方：srcディレクトリをCtagsの引数に渡すと、~/.vim/tags ファイルを作成します。
"		引数がない場合、vimが認識してるカレントディレクトリでctagsを実行します。
"		http://d.hatena.ne.jp/smeghead/searchdiary?word=*%5Bvim%5D
function! s:Ctags(searchPath)
	let searchPath = a:searchPath
	if searchPath ==# ""
		let searchPath = getcwd()
	endif
		exe ':!ctags -R -f ' . $HOME . '/tags' searchPath
endfunction

"---------------------------------
" 最後に選択したテキストを取得する
"-----------------------------
function! s:selected_text()
	let [visual_p, pos, r_, r0] = [mode() =~# "[vV\<C-v>]", getpos('.'), @@, @0]

if visual_p
	execute "normal! \<Esc>"
endif
	normal! gvy
	let _ = @@

	let [@@, @0] = [r_, r0]
if visual_p
	  normal! gv
else
	call setpos('.', pos)
endif
	return _
endfunction

" :argdoと同等
function! Allargs(command)
	let i = 0
	while i < argc()
		if filereadable(argv(i))
			execute "e " . argv(i)
			execute a:command
		endif
			let i = i + 1
		endwhile
endfunction
command! -nargs=+ -complete=command Allargs call Allargs(<q-args>)

  " IMEの状態を取得する Return 1:ON 0:OFF
  function! ImeStatus()
      if has('win32') && has('ruby')
  ruby << EOF
      require 'Win32API'
  
      # 最前面のウィンドウハンドルを取得（操作中のvimウインドウ）
      wndObj = Win32API.new('user32.dll', 'GetForegroundWindow', 'v', 'n')
      hWnd = wndObj.call
      # IMEのコンテキストを取得
      imcObj = Win32API.new('imm32','ImmGetContext','l','l')
      himc = imcObj.call(hWnd)
      # IMEの状態を取得
      imeOpenObj = Win32API.new('imm32','ImmGetOpenStatus',%w(l),'l')
      p imeOpenObj.call(himc).to_s
      VIM::command("return '" + imeOpenObj.call(himc).to_s + "'")
  EOF
      else
          return '0'
      endif
  endfunction

"------------------------------------------------
" 選択したテキストのURLEscapeを行う関数
"------------------------------------------------
function! UrlEscapeTheSelectedTextLiteraly(escape_flag)
    if !has('ruby')
        echoerr "実行にはRubyインターフェースが必要です"
        return
    end
    let reg_0 = [@0, getregtype('0')]
    let reg_u = [@", getregtype('"')]
    normal! gvy
    let @0 = UrlEscape(a:escape_flag)
    normal! gvp
    call setreg('0', reg_0[0], reg_0[1])
    call setreg('"', reg_u[0], reg_u[1])
endfunction
function! UrlEscape(escape_flag)
ruby << EOF
    require 'cgi'
    convert_text = ""
    escape_flag = {:escape => "1", :unescape => "2"}
    selected_text = VIM::evaluate('@0')
    escape_flag_param = VIM::evaluate('a:escape_flag')
    if escape_flag_param == escape_flag[:escape]
        convert_text = CGI.escape(selected_text)
    elsif escape_flag_param == escape_flag[:unescape]
        convert_text = CGI.unescape(selected_text)
    end
    VIM::command("return '#{convert_text}'")
EOF
endfunction

" YankRingっぽいローテーションペーストを行う
" TODO:複数行の対応とレジスタ汚染などの問題
function! NumberedRegisterRotation()
    let @9 = @8
    let @8 = @7
    let @7 = @6
    let @6 = @5
    let @5 = @4
    let @4 = @3
    let @3 = @2
    let @2 = @1
    let @1 = @"
endfunction
function! RegistersComplete()
    call complete(col('.'), [@",@1,@2,@3,@4,@5,@6,@7,@8,@9])
    return ''
endfunction

"" .gitのあるディレクトリに移動する
function! CdDotGitDir()
    let l:current_path = getcwd()
    lcd %:p:h
    if finddir('.git','.;') !~ ".git$"
        echo 'Not found dotgit directory.'
        exec "lcd " . l:current_path
        return ''
    endif
    let l:dotgit_path = SearchDotGitPath('')
    exec "lcd " . l:dotgit_path
endfunction
function! SearchDotGitPath(search_path)
    if finddir('.git', a:search_path) =~ ".git$"
        return a:search_path
    else
        let l:search_path = a:search_path . '../'
        let l:search_result_path = SearchDotGitPath(l:search_path)
        return l:search_result_path
    endif
endfunction
" }}}1
" Envroiments: 環境固有設定 =========================================== {{{1

""Screenの場合にvimを使用した時にスクリーンタブ名を書き換える
if &term =~ "screen"
	autocmd VimLeave * call SetScreenTabName('shell')
	autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | call SetScreenTabName("%") | endif
endif

"" 公開できない設定やローカルマシンごとの固有設定を読み込む
"if filereadable("$HOME/.private/.vimrc_private")
"    source $HOME/.private/.vimrc_private
"endif

" }}}1
" Tmp: 一時な設定 ===================================================== {{{1

" Copy and paste with fakeclip
" Command-C and Command-V are also available in MacVim
" see :help fakeclip-multibyte-on-mac
map gy "*y
map gp "*p
if exists('$WINDOW') || exists('$TMUX')
	map gY <Plug>(fakeclip-screen-y)
	map gP <Plug>(fakeclip-screen-p)
endif

" ckfix のエラー箇所を波線でハイライト
let g:hier_enabled             = 1


" quickfix に出力して、ポッポアップはしない outputter/quickfix
" すでに quickfix ウィンドウが開いている場合は閉じるので注意
"let s:silent_quickfix = quickrun#outputter#quickfix#new()
"function! s:silent_quickfix.finish(session)
"	call call(quickrun#outputter#quickfix#new().finish, [a:session], self)
"	:cclose
"	" vim-hier の更新
"	:HierUpdate
"	" quickfix への出力後に quickfixstatus を有効に
"	:QuickfixStatusEnable
"endfunction
"" quickrun に登録
"call quickrun#register_outputter("silent_quickfix", s:silent_quickfix)
"
" ファイルの保存後に quickrun.vim が実行するように設定する
autocmd BufWritePost *.c,*.h,*.h :QuickRun c -outputter quickfix
autocmd FileType qf nnoremap <buffer><silent> q :q<CR>:HierClear<CR>

" }}}1
" Etc: その他 ========================================================= {{{1

" ^@を削除するテスト
inoremap <C-space><C-d> <ESC>:%s/<C-@>$//ge<CR>:%s/<C-@>/\r/ge<CR>A


" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplcache.
let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" Use camel case completion.
let g:neocomplcache_enable_camel_case_completion = 1
" Use underbar completion.
let g:neocomplcache_enable_underbar_completion = 1
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 2
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

let g:neocomplcache_auto_completion_start_length = 2

" Define dictionary.
let g:neocomplcache_dictionary_filetype_lists = {
            \ 'default' : '',
            \ 'vimshell' : $HOME.'/.vimshell_hist',
            \ 'scheme' : $DOTVIM.'/.gosh_completions', 
            \ 'scala' : $DOTVIM.'/dict/scala.dict', 
            \ 'css' : $DOTVIM.'/dict/css.dict', 
            \ 'html' : $DOTVIM.'/dict/html.dict', 
            \ 'perl' : $DOTVIM.'/dict/perl.dict', 
            \ 'ruby' : $DOTVIM.'/dict/ruby.dict'
            \ }


" Define keyword.
if !exists('g:neocomplcache_keyword_patterns')
	let g:neocomplcache_keyword_patterns = {}
endif
	let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
imap <C-k>     <Plug>(neocomplcache_snippets_expand)
smap <C-k>     <Plug>(neocomplcache_snippets_expand)
inoremap <expr><C-g>     neocomplcache#undo_completion()
inoremap <expr><C-l>     neocomplcache#complete_common_string()

" SuperTab like snippets behavior.
"imap <expr><TAB> neocomplcache#sources#snippets_complete#expandable() ? "\<Plug>(neocomplcache_snippets_expand)" : pumvisible() ? "\<C-n>" : "\<TAB>"

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <expr><CR>  neocomplcache#smart_close_popup() . "\<CR>"
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplcache#close_popup()
inoremap <expr><C-e>  neocomplcache#cancel_popup()

" AutoComplPop like behavior.
let g:neocomplcache_enable_auto_select = 1

" Shell like behavior(not recommended).
"set completeopt+=longest
"let g:neocomplcache_enable_auto_select = 1
"let g:neocomplcache_disable_auto_complete = 1
"inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<TAB>"
"inoremap <expr><CR>  neocomplcache#smart_close_popup() . "\<CR>"

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.

if !exists('g:neocomplcache_omni_patterns')
  let g:neocomplcache_omni_patterns = {}
endif
"let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete

let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.c = '\%(\.\|->\)\h\w*'


" Unite.vim:設定 {{{
" 起動時にインサートモードで開始
let g:unite_enable_start_insert = 1
let g:unite_source_history_yank_enable = 1

" For ack.
if executable('ack-grep')
  let g:unite_source_grep_command = 'ack-grep'
  let g:unite_source_grep_default_opts = '--no-heading --no-color -a'
  let g:unite_source_grep_recursive_opt = ''
endif

" file_mruの表示フォーマットを指定。空にすると表示スピードが高速化される
let g:unite_source_file_mru_filename_format = ''

"" data_directory はramdiskを指定
"if has('win32')
"  let g:unite_data_directory = 'R:\.unite'
"elseif  has('macunix')
"  let g:unite_data_directory = '/Volumes/RamDisk/.unite'
"else
"  let g:unite_data_directory = '~/ramdisk/.unite'
"  " let g:unite_data_directory = '/mnt/ramdisk/.unite'
"endif
 
" bookmarkだけホームディレクトリに保存
let g:unite_source_bookmark_directory = $HOME . '/.unite/bookmark'

" 現在開いているファイルのディレクトリ下のファイル一覧
" 開いていない場合はカレントディレクトリ
nnoremap <silent> [unite]f :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
" バッファ一覧
nnoremap <silent> [unite]b :<C-u>Unite buffer<CR>
" レジスタ一覧
nnoremap <silent> [unite]r :<C-u>Unite -buffer-name=register register<CR>
" 最近使用したファイル一覧
nnoremap <silent> [unite]m :<C-u>Unite file_mru<CR>
" ブックマーク一覧
nnoremap <silent> [unite]c :<C-u>Unite bookmark<CR>
" ブックマークに追加
nnoremap <silent> [unite]a :<C-u>UniteBookmarkAdd<CR>
" uniteを開いている間のキーマッピング
augroup vimrc
  autocmd FileType unite call s:unite_my_settings()
augroup END
function! s:unite_my_settings()
  " ESCでuniteを終了
  nmap <buffer> <ESC> <Plug>(unite_exit)
  " 入力モードのときjjでノーマルモードに移動
  imap <buffer> jj <Plug>(unite_insert_leave)
  " 入力モードのときctrl+wでバックスラッシュも削除
  imap <buffer> <C-w> <Plug>(unite_delete_backward_path)
  " sでsplit
  nnoremap <silent><buffer><expr> s unite#smart_map('s', unite#do_action('split'))
  inoremap <silent><buffer><expr> s unite#smart_map('s', unite#do_action('split'))
  " vでvsplit
  nnoremap <silent><buffer><expr> v unite#smart_map('v', unite#do_action('vsplit'))
  inoremap <silent><buffer><expr> v unite#smart_map('v', unite#do_action('vsplit'))
  " fでvimfiler
  nnoremap <silent><buffer><expr> f unite#smart_map('f', unite#do_action('vimfiler'))
  inoremap <silent><buffer><expr> f unite#smart_map('f', unite#do_action('vimfiler'))
endfunction

" インサート／ノーマルどちらからでも呼び出せるようにキーマップ
nnoremap <silent> <C-f> :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
inoremap <silent> <C-f> <ESC>:<C-u>UniteWithBufferDir -buffer-name=files file<CR>
nnoremap <silent> <C-b> :<C-u>Unite buffer file_mru<CR>
inoremap <silent> <C-b> <ESC>:<C-u>Unite buffer file_mru<CR>

nnoremap <silent> <space>fb :<C-u>Unite buffer<CR>
nnoremap <silent> <space>fc :<C-u>Unite command<CR>
nnoremap <silent> <space>fd :<C-u>Unite directory_mru<CR>
nnoremap <silent> <space>ff :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
nnoremap <silent> <space>fp :<C-u>Unite -buffer-name=register register<CR>
nnoremap <silent> <space>fm :<C-u>Unite file_mru<CR>
nnoremap <silent> <space>fv :<C-u>Unite bookmark<CR>

" unite.vim上でのキーマッピング
autocmd FileType unite call s:unite_my_settings()
function! s:unite_my_settings()
	" 単語単位からパス単位で削除するように変更
	imap <buffer> <C-w> <Plug>(unite_delete_backward_path)
	" ESCキーを2回押すと終了する
	nmap <silent><buffer> <ESC><ESC> q
	imap <silent><buffer> <ESC><ESC> <ESC>q
endfunction

"}}}2
" VimFiler:設定 {{{
"" data_directory はramdiskを指定
"if has('win32')
"  let g:vimfiler_data_directory = 'R:\.vimfiler'
"elseif  has('macunix')
"  let g:vimfiler_data_directory = '/Volumes/RamDisk/.vimfiler'
"else
"  let g:unite_data_directory = '~/ramdisk/.vimfiler'
"  " let g:vimfiler_data_directory = '/mnt/ramdisk/.vimfiler'
"endif

" vimデフォルトのエクスプローラをvimfilerで置き換える
let g:vimfiler_as_default_explorer = 1
" セーフモードを無効にした状態で起動する
let g:vimfiler_safe_mode_by_default = 0
" 現在開いているバッファのディレクトリを開く
nnoremap <silent> <Leader>fe :<C-u>VimFilerBufferDir -quit<CR>
" 現在開いているバッファをIDE風に開く
nnoremap <silent> <Leader>fi :<C-u>VimFilerBufferDir -split -simple -winwidth=35 -no-quit<CR>

" デフォルトのキーマッピングを変更
augroup vimrc
	autocmd FileType vimfiler call s:vimfiler_my_settings()
augroup END
function! s:vimfiler_my_settings()
	nmap <buffer> q <Plug>(vimfiler_exit)
	nmap <buffer> Q <Plug>(vimfiler_hide)
endfunction

command! VimFilerTree call VimFilerTree()
function VimFilerTree()
	exec ':VimFiler -buffer-name=explorer -split -simple -winwidth=45 -toggle -no-quit'
	wincmd t
	setl winfixwidth
endfunction
autocmd! FileType vimfiler call s:my_vimfiler_settings()
function! s:my_vimfiler_settings()
	nmap     <buffer><expr><CR> vimfiler#smart_cursor_map("\<Plug>(vimfiler_expand_tree)", "\<Plug>(vimfiler_edit_file)")
	nnoremap <buffer>s          :call vimfiler#mappings#do_action('my_split')<CR>
	nnoremap <buffer>v          :call vimfiler#mappings#do_action('my_vsplit')<CR>
endfunction

let my_action = {'is_selectable' : 1}
function! my_action.func(candidates)
	wincmd p
	exec 'split '. a:candidates[0].action__path
endfunction
call unite#custom_action('file', 'my_split', my_action)

let my_action = {'is_selectable' : 1}
function! my_action.func(candidates)
	wincmd p
	exec 'vsplit '. a:candidates[0].action__path
endfunction
call unite#custom_action('file', 'my_vsplit', my_action)

"}}}2


" Escの2回押しでハイライト消去
nmap <ESC><ESC> :nohlsearch<CR><ESC>

" Vim起動中はtmuxのステータスラインを隠す
"if !has('gui_running') && $TMUX !=# ''
"    augroup Tmux
"        autocmd!
"        autocmd VimEnter,VimLeave * silent !tmux set status
"    augroup END
"endif

" }}}1
