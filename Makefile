all:
	LANG=zh_EN.UTF-8 emacs --script auto_publish.el
clean:
	rm -rf html/*
	rm -rf ~/.org-timestamps/
