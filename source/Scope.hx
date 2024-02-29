package source;

import source.values.Value;

class Scope {
	public var vars: Map<String, Value>;
	public var parent: Scope;

	public function new(?parent: Scope) {
		this.vars = [];
		this.parent = parent;
	}

	///////////////////////

	public function declare(name: String, value: Value) {
		if (this.lookup(name) != null) {
			return null;
		}

		this.set(name, value);
		return this.lookup(name);
	}

	public function assign(name: String, value: Value) {
		if (this.lookup(name) == null) {
			return null;
		}

		this.set(name, value);
		return this.lookup(name);
	}

	///////////////////////

	public function set(name: String, value: Value) {
		this.vars.set(name, value);
	}

	public function lookup(name: String) {
		if (!this.vars.exists(name)) {
			return null;
		}

		return this.vars[name];
	}

	///////////////////////

	public function string() {
		return this.vars.toString();
	}
}