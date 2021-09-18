node:
	curl -L https://git.io/n-install | bash

deno:
	curl -fsSL https://deno.land/x/install/install.sh | sh

go:
	curl -LO https://get.golang.org/$(uname)/go_installer && chmod +x go_installer && ./go_installer && rm go_installer

all:
	node deno go