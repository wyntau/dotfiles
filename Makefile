DEFAULTNAME = `whoami`
NOW = `pwd`
SUBLIMEPATH ?= $$HOME/Library/Application Support/Sublime Text 2
ZSHPATH = `which zsh`

list:
	@echo "\033[0;32mAvailable tasks:\033[0m"
	@echo "\033[0;32m    1) vimrc\033[0m"
	@echo "\033[0;32m    2) gitconfig\033[0m"
	@echo "\033[0;32m    3) astylerc\033[0m"
	@echo "\033[0;32m    4) sublime\033[0m"
	@echo "\033[0;32m    5) zsh\033[0m"

all: vimrc gitconfig astylerc sublime zsh

vimrc:
	@if [ -d vim/bundle/vundle ]; then \
		echo "\033[0;33mupdate git submodule...\033[0m"; \
		cd vim/bundle/vundle && git pull origin master && cd $(NOW); \
	else \
		echo "\033[0;33minit and update sublime...\033[0m"; \
		git clone https://github.com/gmarik/vundle.git vim/bundle/vundle; \
	fi;

	@echo "\033[0;33m==> Installing vimrc and bundle configs......\033[0m"

	@rm -rf ~/.vim
	@echo "\033[0;36mlinking $(NOW)/vim to ~/.vim\033[0m"
	@ln -s $(NOW)/vim ~/.vim

	@for FILE in vimrc editorconfig; do \
		rm -rf ~/.$$FILE; \
		echo "\033[0;36mlinking $(NOW)/vim/$$FILE to ~/.$$FILE\033[0m"; \
		ln -s $(NOW)/vim/$$FILE ~/.$$FILE; \
	done;

	@echo "\033[0;33m==> Installing vim bundles......\033[0m"
	@vim +BundleInstall +qall
	@echo "\033[0;32m==> Install vimrc and bundles completed.\033[0m"

gitconfig:
	@echo "\033[0;33m==> Installing gitconfig......\033[0m"
	@rm -rf ~/.gitconfig;

	@echo "\033[0;36mlinking $(NOW)/gitconfig to ~/.gitconfig\033[0m";
	@ln -s $(NOW)/gitconfig ~/.gitconfig;

	@echo "\033[0;33m==> Now config your name and email for git.\033[0m"

	@echo "\033[0;35mWhat's your git username? ($(DEFAULTNAME)) \033[0m\c";
	@read USERNAME; \
	if [ "$$USERNAME" = "" ]; then \
		USERNAME=$(DEFAULTNAME); \
	fi; \
	git config --global user.name $$USERNAME;

	@echo "\033[0;35mWhat's your git email? ($(DEFAULTNAME)@example.com) \033[0m\c";
	@read EMAIL; \
	if [ "$$EMAIL" = "" ]; then \
		EMAIL=$(DEFAULTNAME)@example.com; \
	fi; \
	git config --global user.email $$EMAIL;

	@echo "\033[0;32m==> Install gitconfig completed.\033[0m"

astylerc:
	@echo "\033[0;33m==> Installing astylerc......\033[0m"
	@rm -rf ~/.astylerc
	@echo "\033[0;36mlinking $(NOW)/astylerc to ~/.astylerc\033[0m";
	@ln -s $(NOW)/astylerc ~/.astylerc;
	@echo "\033[0;32m==> Install astylerc completed.\033[0m"

sublime:
	@if [ -d sublime/monokai-custom ]; then \
		echo "\033[0;33mupdate git submodule...\033[0m"; \
		cd sublime/monokai-custom && git pull origin master && cd $(NOW); \
	else \
		echo "\033[0;33minit and update sublime...\033[0m"; \
		git clone https://github.com/Jeremial/sublime-monokai-custom.git sublime/monokai-custom; \
	fi;

	@echo "\033[0;33m==> Installing sublime Preference and Monokai-custom theme......\033[0m"

	@rm -rf "$(SUBLIMEPATH)/Packages/User/monokai-custom"
	@echo "\033[0;36mlinking $(NOW)/sublime/monokai-custom $(SUBLIMEPATH)/Packages/User/monokai-custom\033[0m"
	@ln -s $(NOW)/sublime/monokai-custom "$(SUBLIMEPATH)/Packages/User/monokai-custom"

	@rm -rf "$(SUBLIMEPATH)/Packages/User/Preferences.sublime-settings"
	@echo "\033[0;36mlinking $(NOW)/sublime/Preferences.sublime-settings to $(SUBLIMEPATH)/Packages/User/Preferences.sublime-settings\033[0m"
	@ln -s $(NOW)/sublime/Preferences.sublime-settings "$(SUBLIMEPATH)/Packages/User/Preferences.sublime-settings"

	@echo "\033[0;32m==> Install sublime Preference and Monokai-custom theme completed.\033[0m"

zsh:
	@if [ -d zsh/oh-my-zsh ]; then \
		echo "\033[0;33mupdate oh-my-zsh...\033[0m"; \
		cd zsh/oh-my-zsh && git pull origin master && cd $(NOW); \
	else \
		echo "\033[0;33minit and update oh-my-zsh...\033[0m"; \
		git clone https://github.com/robbyrussell/oh-my-zsh.git zsh/oh-my-zsh; \
	fi;

	@echo "\033[0;33m==> Installing zsh and oh-my-zsh......\033[0m"
	@rm -rf ~/.oh-my-zsh;
	@rm -rf ~/.zshrc;

	@echo "\033[0;36mlinking $(NOW)/zsh/oh-my-zsh to ~/.oh-my-zsh\033[0m"
	@ln -s $(NOW)/zsh/oh-my-zsh ~/.oh-my-zsh

	@echo "\033[0;36mlinking $(NOW)/zsh/zshrc to ~/.zshrc\033[0m";
	@ln -s $(NOW)/zsh/zshrc ~/.zshrc;

#	@if [ -d zsh/z ]; then \
#		echo "\033[0;33mupdate zjump...\033[0m"; \
#		cd zsh/zjump && git pull origin master && cd $(NOW); \
#	else \
#		echo "\033[0;33minit and update zjump...\033[0m"; \
#		git clone https://github.com/rupa/z zsh/z; \
#	fi;
#
#	@echo "\033[0;33m==> Installing zjump......\033[0m"
#	@rm -rf ~/.zjump;
#
#	@echo "\033[0;36mlinking $(NOW)/zsh/z to ~/.zjump\033[0m"
#	@ln -s $(NOW)/zsh/z ~/.zjump;

	@echo "\033[0;36mTime to change your default shell to zsh!\033[0m"
	@if [ "$(ZSHPATH)" != "" ]; then \
		chsh -s $(ZSHPATH); \
	else \
		echo "\033[0;31mNo Zsh found! Please install zsh first\033[0m"; \
		exit 1; \
	fi;

	@echo "\033[0;32m==> Install zsh and oh-my-zsh completed.\033[0m"
	@/usr/bin/env zsh
	@source ~/.zshrc
.PHONY: all vimrc gitconfig astylerc zsh sublime

#none         = "\033[0m"
#black        = "\033[0;30m"
#dark_gray    = "\033[1;30m"
#red          = "\033[0;31m"
#light_red    = "\033[1;31m"
#green        = "\033[0;32m"
#light_green -= "\033[1;32m"
#brown        = "\033[0;33m"
#yellow       = "\033[1;33m"
#blue         = "\033[0;34m"
#light_blue   = "\033[1;34m"
#purple       = "\033[0;35m"
#light_purple = "\033[1;35m"
#cyan         = "\033[0;36m"
#light_cyan   = "\033[1;36m"
#light_gray   = "\033[0;37m"
#white        = "\033[1;37m"
