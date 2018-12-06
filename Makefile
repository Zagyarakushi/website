publish_dir := public
timestamps_dir := .timestamps
orgs := $(wildcard *.org)
emacs_pkgs := org

publish_el := elisp/publish.el

^el = $(filter %.el,$^)
EMACS.funcall = emacs --batch --no-init-file $(addprefix --load ,$(^el)) --funcall

all: publish

publish: $(publish_el) $(orgs)
	$(EMACS.funcall) rw-publish-all

clean:
	rm -rf $(publish_dir)
	rm -rf $(timestamps_dir)

cert:
	certbot certonly -m toon@iotcl.com \
          --agree-tos --no-eff-email --manual-public-ip-logging-ok \
          -d www.writepermission.com -d writepermission.com \
          --manual --manual-auth-hook=script/acme-deploy.sh \
          --deploy-hook=script/cert-install.sh \
          --config-dir=./config --work-dir=./ --logs-dir=./log

mds:=$(wildcard _posts/*.md) $(wildcard _drafts/*.md)
md_orgs:=$(patsubst %.md,%.org,$(mds))

convert-all: $(md_orgs)

%.org: %.md
	pandoc -f markdown -t org -o $@ $<
	rm $<
