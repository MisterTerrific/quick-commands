.PHONY: all download extract os install windows linux sqlite3 eggs eggs_windows eggs_linux compile_win compile_linux
CC=chicken-4.10.0
OSTYPE=$(shell uname)
CCBIN=/c/Chicken/bin
COMPILE_SCM=csc -c cli.scm main.scm
DEPLOY=csc -deploy cli.o main.o -o qc
COPY_RES=cp -r resources/ qc/
INSTALL_EGGS=chicken-install -deploy -p qc sqlite3 posix args srfi-13


ifeq (, $(SUDO_USER))
    USERHOME=$(HOME)
else
    USERHOME=/home/$(SUDO_USER)
endif


all: download extract os

download:
	wget "http://code.call-cc.org/releases/4.10.0/chicken-4.10.0.tar.gz"

extract: chicken-4.10.0.tar.gz
	tar -zxvf chicken-4.10.0.tar.gz
	ls -l

os:
ifeq ($(OS), Windows_NT)
	@echo "this is windows"
	$(MAKE) windows
else
     ifeq ($(OSTYPE), Linux)
	@echo "its linux"
	$(MAKE) linux
     endif
endif



linux: $(CC)/ $(CC)/Makefile
	cd $(CC) && make PLATFORM=linux PREFIX=/usr/local && make PLATFORM=linux PREFIX=/usr/local install
	$(MAKE) eggs_linux

windows: $(CC)/ $(CC)/Makefile
ifneq (,$(findstring MSYS_NT, $(OSTYPE)))
	@echo " ON MSYS"
	cd $(CC) && make PLATFORM=mingw-msys PREFIX=c:/chicken && make PLATFORM=mingw-msys PREFIX=c:/chicken install
	$(MAKE) eggs_windows
endif
ifneq (,$(findstring MINGW, $(OSTYPE)))
	@echo " ON MINGW"
	cd $(CC) && make PLATFORM=mingw PREFIX=c:/chicken && make PLATFORM=mingw PREFIX=c:/chicken install
	$(MAKE) eggs_windows
endif
#cd $(CC) && make

eggs_linux: /usr/local/bin/chicken-install
	@echo May need to install sqlite3 dev packages
	chicken-install sqlite3 posix args srfi-13
	$(MAKE) compile_linux
	
eggs_windows: $(CCBIN)/chicken-install.exe
ifeq (,$(findstring $(CCBIN), $(PATH)))
	@echo "chicken bin not in path"
	export PATH=$(CCBIN):$(PATH)
	$(PATH)
endif
	@echo "May need to install sqlite3 dev packages"
	cd $(CCBIN)/ && chicken-install sqlite3 posix args srfi-13
	$(MAKE) compile_win
	
compile_win: $(CCBIN)/csc.exe cli.scm main.scm resources/qcommands.db
	$(COMPILE_SCM)
	$(DEPLOY)
#$(COPY_RES)
	$(INSTALL_EGGS)
	$(MAKE) install
	
compile_linux: cli.scm main.scm resources/qcommands.db
	$(COMPILE_SCM)
	$(DEPLOY)
#$(COPY_RES)
	$(INSTALL_EGGS)
	$(MAKE) install
	
install: resources/qcommands.db qc LICENSE README.md
	cp README.md LICENSE qc/
	mkdir -p $(USERHOME)/bin/
#cp qc/resources/qcommands.db $(USERHOME)/
#mkdir -p $(USERHOME)/bin/quick_commands/
	cp -avr qc/ $(USERHOME)/bin/
	cp -a resources/qcommands.db $(USERHOME)/
	@echo "Installation complete."


