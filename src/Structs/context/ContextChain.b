struct ContextChain {
	var parent: ContextChain*;
	var context: Context*;
};

func newContextChain(): ContextChain* {
	return (ContextChain*)Calloc(1, sizeof(ContextChain));
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

func stashContextChainToRoot(): ContextChain* {
	var chain = contexts;
	while (contexts->parent != NULL) { popContextChain(); };
	return chain;
};

func restoreContextChainFromRoot(chain: ContextChain*) {
	contexts = chain;
};
