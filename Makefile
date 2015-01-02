
all:
	git pull
	FAST_NANOC=1 nanoc co

full:
	git pull
	nanoc co
