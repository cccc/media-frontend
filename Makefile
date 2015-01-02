
all:
	git pull
	FAST_NANOC=1 nanoc co

full:
	rm -fr tmp/cache
	rm /srv/www/media.ccc.de/output/index.html
	git pull
	nanoc co

clean:
	rm -fr /srv/www/media.ccc.de/output/*
	rm -fr tmp/cache
