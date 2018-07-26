struct ContextChain {
	var parent: ContextChain*;
	var context: Context*;
};

func newContextChain(): ContextChain* {
	return (ContextChain*)xcalloc(1, sizeof(ContextChain));
};

var contexts: ContextChain*;

func pushContextChain() {
	var newChain = newContextChain();
	newChain->parent = contexts;
	contexts = newChain;
};

func popContextChain() {
	if (contexts == NULL) {
		ProgrammingError("popContextChain called with no ContextChain present");
	};
	contexts = contexts->parent;
};

func stashContextChain(): ContextChain* {
	if (contexts == NULL) {
		ProgrammingError("stashContextChain called with no ContextChain present");
	};
	var chain = contexts;
	contexts = chain->parent;
	chain->parent = NULL;
	return chain;
};

func restoreContextChain(chain: ContextChain*) {
	chain->parent = contexts;
	contexts = chain;
};

func stashContextChainToRoot(): ContextChain* {
	var chain = contexts;
	while (contexts->parent != NULL) { popContextChain(); };
	return chain;
};

func restoreContextChainFromRoot(chain: ContextChain*) {
	contexts = chain;
};
