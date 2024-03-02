package source;

import source.values.*;
import source.nodes.*;

class Interpreter {
	public function new() {}
	public function eval(node: Node, scope: Scope, ignoreVarError: Bool = false): Value {
		// Sys.println(node.string());
		
		// Values
		if (node is NumericLiteral) {
			return new NumberValue(cast (node, NumericLiteral).value);

		} else if (node is StringLiteral) {
			return new StringValue(cast (node, StringLiteral).value);

		} else if (node is Literal) {
			var node = cast (node, Literal);
			
			if (node.value == "null") {
				return new NullValue();
			}

			return new BooleanValue(node.value == "true");

		} else if (node is Identifier) {
			var node = cast (node, Identifier);
			var _var = scope.lookup(node.value);

			// Yes, it looks like it needs a cleanup
			if (_var == null && !ignoreVarError) {
				throw new Error('${node.value} does not exist in the current scope', node.pos);
			} else if (ignoreVarError) {
				return new NullValue();
			}

			return _var;
		}
		
		// Misc.
		else if (node is Program) {
			return this.evalProgram(cast (node, Program), scope);
		}

		// Statements
		else if (node is VarDeclaration) {
			return this.evalVarDeclaration(cast (node, VarDeclaration), scope);
		}

		// Expressions
		else if (node is VarAssignment) {
			return this.evalVarAssignment(cast (node, VarAssignment), scope);
		}
		
		else if (node is BinaryExpr) {
			return this.evalBinaryExpr(cast (node, BinaryExpr), scope);
		}

		throw new Error('Undefined AST type for interpretation', node.pos);
	}

	  ///////////
	 // Misc. //
	///////////
	
	public function evalProgram(program: Program, scope: Scope): Value {
		var lastEval: Value = null;

		for (expr in program.body) {
			lastEval = this.eval(expr, scope);
		}

		return lastEval;
	}

	  ////////////////
	 // Statements //
	////////////////

	public function evalVarDeclaration(stmt: VarDeclaration, scope: Scope): Value {
		var value = this.eval(stmt.value, scope);
		var _var = scope.declare(stmt.ident.value, value);

		if (_var == null) {
			throw new Error('Cannot redeclare "${stmt.ident.value}"', stmt.ident.pos);
		}

		return _var;
	}

	  /////////////////
	 // Expressions //
	/////////////////

	public function evalVarAssignment(expr: VarAssignment, scope: Scope): Value {
		var value = this.eval(expr.value, scope);
		var _var = scope.assign(expr.varname.value, value);

		if (_var == null) {
			throw new Error('"${expr.varname.value}" does not exist in the current scope', expr.varname.pos);
		}

		return _var;
	}
	
	public function evalBinaryExpr(expr: BinaryExpr, scope: Scope): Value {
		var left = this.eval(expr.left, scope);
		var right = this.eval(expr.right, scope);
		var value = left.operation(expr.op.value, right);

		if (value == null) {
			throw new Error('Cannot do ${left.type} ${expr.op.value} ${right.type}', expr.pos);
		}

		// switch (expr.op.value) {
			// case "+": value = left.value + right.value;
		// }
		
		return value;
	}
}