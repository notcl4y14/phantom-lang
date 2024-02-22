import source.values.Value;
import source.nodes.Program;
import sys.io.File;
import sys.FileSystem;
import source.*;

class Main {

	public function outputResultToString(name: String, result: Array<Token>, lineWidth: Int = 40) {
		var strings: Array<String> = [];
		
		for (token in result) {
			var str = token.string(true);

			if (str.length > lineWidth) {
				lineWidth += str.length - lineWidth;
			}

			strings.push(str);
		}

		this.outputResult(name, strings, lineWidth);
	}
	
	public function outputResult(name: String, result: Array<String>, lineWidth: Int = 40) {
		var topLineWidth = (lineWidth - (name.length + 1));

		Sys.print('${name} ');
		for (i in 0...topLineWidth) Sys.print("-");
		Sys.print("\n");

		for (str in result) Sys.println(str);
		for (i in 0...lineWidth) Sys.print("-");
		Sys.print("\n");
	}

	public function readFile(filename: String = ""): Null<String> {
		if (!FileSystem.exists(filename)) {
			return null;
		}

		return File.getContent(filename);
	}

	///////////////////////
	
	public function new() {
		// Sys.println("Hello World!");
		// var token = new Token(TokenType.Operator, "+");
		// Sys.println("Tokens ---------------------------------");
		// Sys.println(token.string());
		// Sys.println("----------------------------------------");
		// this.outputResult("Tokens", [token.string()]);
		var args = Sys.args();
		var filename = args[0];
		var code = this.readFile(filename);

		if (code == null) {
			var error = filename != null
				? 'File "${filename}" not found'
				: 'Filename expected';
			Sys.println(error);
			Sys.exit(0);
		}

		var lexer = new Lexer(filename, code);
		var tokens = lexer.lexerize();

		if (args.contains("--lexer")) {
			this.outputResultToString("Tokens", tokens);
		}

		var parser = new Parser(tokens);
		var ast = new Program();          // For compiler
		try { ast = parser.parse(); }
		catch (e: source.Error) { Sys.println(e.string()); Sys.exit(1); }

		if (args.contains("--parser")) {
			this.outputResult("AST", [ast.string()]);
		}

		var interpeter = new Interpreter();
		var result: Value = null;                // For compiler
		try { result = interpeter.eval(ast); }
		catch (e: source.Error) { Sys.println(e.string()); Sys.exit(1); }

		if (args.contains("--eval-value") && result != null) {
			// For compiler
			// try {
			this.outputResult("Evaluated value", [result.string()]);
			// } catch(e) {}
		}
	}

	static public function main() {
		new Main();
	}
}