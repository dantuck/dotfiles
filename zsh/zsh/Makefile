include ../env.mk

install: .ensure.xdg
	ln -sfn $(CURDIR) $(XDG_CONFIG_HOME)/zsh
	mkdir -p $(XDG_CACHE_HOME)/zsh
	mkdir -p $(XDG_CONFIG_HOME)/zsh
	mkdir -p $(XDG_DATA_HOME)/zsh
	# antibody bundle < $(CURDIR)/bundle > ${XDG_DATA_HOME}/zsh/plugins
	ln -sf $(CURDIR)/zshenv $(HOME)/.zshenv

clean: .remove.xdg.module.zsh
	rm -rf $(HOME)/.zshenv
	rm -rf $(XDG_CONFIG_HOME)/zsh
	rm -rf ${XDG_CACHE_HOME}/zsh
	rm -rf $(XDG_DATA_HOME)/zsh

.PHONY: install clean
