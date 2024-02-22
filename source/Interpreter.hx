package source;

import source.values.*;
import source.nodes.*;

class Interpreter {
	public function new() {}
	public function eval(node: Node): Value {
		// var type = Type.typeof(node);
		
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
		}
		
		// Misc.
		else if (node is Program) {
			return this.evalProgram(cast (node, Program));
		}

		// Expressions
		else if (node is BinaryExpr) {
			return this.evalBinaryExpr(cast (node, BinaryExpr));
		}

		throw new Error('Undefined AST type for interpretation', node.pos);
	}
	
	public function evalProgram(program: Program): Value {
		var lastEval: Value = null;

		for (expr in program.body) {
			lastEval = this.eval(expr);
		}

		return lastEval;
	}
	
	public function evalBinaryExpr(expr: BinaryExpr): Value {
		var left = this.eval(expr.left);
		var right = this.eval(expr.right);
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