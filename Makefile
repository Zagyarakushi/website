publish_dir := public
timestamps_dir := .timestamps
packages_dir := .packages
orgs := $(wildcard *.org)
emacs_pkgs := org

publish_el := scripts/publish.el

restore_mtime = python3 scripts/git-restore-mtime.py

^el = $(filter %.el,$^)
EMACS.funcall = emacs --quick --batch --directory scripts/ $(addprefix --load ,$(^el)) --funcall

all: publish

publish: $(publish_el) $(orgs)
	$(restore_mtime)
	$(EMACS.funcall) rw-publish-all

clean:
	rm -rf $(publish_dir)
	rm -rf $(timestamps_dir)
	rm -rf $(packages_dir)

#####
# Import from markdown
#####

mds:=$(wildcard _posts/*.md) $(wildcard _drafts/*.md)
md_orgs:=$(patsubst %.md,%.org,$(mds))

convert-all: $(md_orgs)

%.org: %.md
	pandoc -f markdown -t org -o $@ $<
	rm $<
