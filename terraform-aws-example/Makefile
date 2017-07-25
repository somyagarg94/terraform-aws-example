KISMATIC_VERSION=1.4.0

get-dependencies:
	wget --no-check-certificate -O - https://github.com/apprenda/kismatic/releases/download/v$(KISMATIC_VERSION)/kismatic-v$(KISMATIC_VERSION)-darwin-amd64.tar.gz | tar -zx

provision-cluster:
	chmod 600 ssh/cs_ref_arch
	./kismatic install apply -f kismatic-cluster.yaml --skip-preflight
	cp generated/kubeconfig .
	mkdir ~/.kube/
	cp kubeconfig ~/.kube/config

clean:
	rm -rf ansible helm kismatic kubectl provision
