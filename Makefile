publish_dir := public
timestamps_dir := .timestamps
orgs := $(wildcard *.org)
emacs_pkgs := org

publish_el := elisp/publish.el

^el = $(filter %.el,$^)
EMACS.funcall = emacs --quick --batch --directory elisp/ $(addprefix --load ,$(^el)) --funcall

all: publish

publish: $(publish_el) $(orgs)
	$(EMACS.funcall) rw-publish-all

clean:
	rm -rf $(publish_dir)
	rm -rf $(timestamps_dir)

#####
# Import from markdown
#####

mds:=$(wildcard _posts/*.md) $(wildcard _drafts/*.md)
md_orgs:=$(patsubst %.md,%.org,$(mds))

convert-all: $(md_orgs)

%.org: %.md
	pandoc -f markdown -t org -o $@ $<
	rm $<
