CP = cp -nvi

.PHONY: help
help: displaylogo
	@echo "run «make install» to install. Or run «make config» and edit the 'config' file separately."

.PHONY: displaylogo
displaylogo: logo.txt
	@cat $<
	@echo

%: %.in config
	source ./config ;\
	cat $@.in \
		| sed -e "s,GHC_CONF,$${GHC_CONF},g" \
		| sed -e "s,GHCI_PAGER_SUBDIR,$${GHCI_PAGER_SUBDIR},g" \
		| sed -e "s,GHCI_CONF_FILE,$${GHCI_CONF_FILE},g" > $@

.PHONY: install
install: displaylogo config Less.hs less.conf postinstall.txt 
	source ./config ;\
	mkdir -p $${GHC_CONF}/$${GHCI_PAGER_SUBDIR} ;\
	$(CP) Less.hs $${GHC_CONF}/$${GHCI_PAGER_SUBDIR} ;\
	$(CP) less.conf $${GHC_CONF}/$${GHCI_PAGER_SUBDIR} ;
	@echo ====
	@cat postinstall.txt

config:
	echo GHC_CONF=$${HOME}/.ghc > $@
	echo GHCI_PAGER_SUBDIR=ghci-pager >> $@
	if [ -f ~/.ghci ] ; then \
		echo GHCI_CONF_FILE=~/.ghci >> $@ ; \
	else \
		echo GHCI_CONF_FILE=~/.ghc/ghci.conf >> $@ ; fi

.PHONY: clean 
clean:
	- rm -vf less.conf postinstall.txt config
	- rm -vf *~
