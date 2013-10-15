NOW = `pwd`
DEFAULTNAME = `whoami`
SUBLIMEPATH ?= $$HOME/Library/Application Support/Sublime Text 2

all: submodule vimrc gitconfig astylerc wgetrc zsh

submodule:
	@echo "\033[0;33m==> submodule init and update......\033[0m"
	@git submodule init
	@git submodule update
	@echo "\033[0;32m==> submodule updated.\033[0m"

vimrc: submodule
	@echo "\033[0;33m==> Installing vimrc and bundle configs......\033[0m"
	@for FILE in vim vimrc editorconfig; do \
		rm -rf ~/.$$FILE; \
		echo "\033[0;36mlinking $(NOW)/$$FILE to ~/.$$FILE\033[0m"; \
		ln -s $(NOW)/$$FILE ~/.$$FILE; \
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

wgetrc:
	@echo "\033[0;33m==> Installing wgetrc......\033[0m"
	@rm -rf ~/.wgetrc
	@echo "\033[0;36mlinking $(NOW)/wgetrc to ~/.wgetrc\033[0m";
	@ln -s $(NOW)/wgetrc ~/.wgetrc;
	@echo "\033[0;32m==> Install wgetrc completed.\033[0m"

zsh: submodule
	@echo "\033[0;33m==> Installing zsh and oh-my-zsh......\033[0m"
	@rm -rf ~/.oh-my-zsh;
	@rm -rf ~/.zshrc;

	@echo "\033[0;36mlinking $(NOW)/oh-my-zsh to ~/.oh-my-zsh\033[0m"
	@ln -s $(NOW)/oh-my-zsh ~/.oh-my-zsh

	@echo "\033[0;36mlinking $(NOW)/zshrc to ~/.zshrc\033[0m";
	@ln -s $(NOW)/zshrc ~/.zshrc;

	@echo "\033[0;36mTime to change your default shell to zsh!\033[0m"
	@if [ -f /usr/local/bin/zsh ] && grep -Fxq '/usr/local/bin/zsh' /etc/shells; then \
		chsh -s /usr/local/bin/zsh; \
	elif [ -f /bin/zsh ]; then \
		chsh -s /bin/zsh; \
	else \
		echo "\033[0;31mNo Zsh found! Please install zsh first\033[0m"; \
		exit 1; \
	fi;

	@echo "\033[0;32m==> Install zsh and oh-my-zsh completed.\033[0m"
	@/usr/bin/env zsh
	@source ~/.zshrc

sublime:
	@echo "\033[0;33m==> Installing sublime Preference and Monokai-custom theme......\033[0m"

	@rm -rf "$(SUBLIMEPATH)/Packages/User/Preferences.sublime-settings"
	@echo "\033[0;36mlinking $(NOW)/sublime/Preferences.sublime-settings to $(SUBLIMEPATH)/Packages/User/Preferences.sublime-settings\033[0m"
	@ln -s $(NOW)/sublime/Preferences.sublime-settings "$(SUBLIMEPATH)/Packages/User/Preferences.sublime-settings"

	@rm -rf "$(SUBLIMEPATH)/Packages/User/monokai-custom"
	@echo "\033[0;36mlinking $(NOW)/sublime/monokai-custom $(SUBLIMEPATH)/Packages/User/monokai-custom\033[0m"
	@ln -s $(NOW)/sublime/monokai-custom "$(SUBLIMEPATH)/Packages/User/monokai-custom"
	@echo "\033[0;32m==> Install sublime Preference and Monokai-custom theme completed.\033[0m"

.PHONY: submodule vimrc gitconfig astylerc wgetrc zsh sublime

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