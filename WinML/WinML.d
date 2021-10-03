module WinML;

import std.stdio;
import std.string;
import std.conv;
import std.algorithm;

/**

WinML is a Simple Mathematical expression calculator written in the D programming language.

WinML is abbreviated as (WML), but does support WinML too.

A normal expression looks like:

    (+ 2 2) -> 4

A wrong expression looks like:
    (+ 11 -> Error: Syntax Error: Expected ')'

Comments in WML are //.

*/

const char DIV_OP = '/';
const char MUL_OP = '*';
const char ADD_OP = '+';
const char SUB_OP = '-';

/**
WinML (Syntax Error: Expected KEY)
*/
class WinML_Expected {
public:
    this(char k) {
        writeln("Syntax Error: Expected '"~k~"'");
        assert(0);
	}
}

/**
Parses and handles parenthesis.

If the statment starts with '//' then we'll count it as a comment.

If the statement doesn't start with '//' and doesn't start with '(', then we'll throw a syntax error.
*/
class WinML_GetBox {
    string exp;
public:
    this(string ex) {
        exp = ex;
	}
    string Gret() {
        if (exp.startsWith("//")) {
            assert(1); // count as comment
		} else if (exp.startsWith("(")) {
            string return_string;
            foreach (char k; exp) {
                if (k == '(') {
                    continue;
				} else if (k == ')') {
                    break;
				} else {
                    return_string = return_string~k;
				}
			}
            return return_string;
		}
        return "Nothing";
	}

}

/**
Does all of the boring stuff with a Statement

What should be passed in:

[+|-|/|*] <nums>

NOT:

(<expr>)
*/
class WinML_Adder {
    private:
        string sta;
        WinML_GetBox wml_gb;
    public:
	    this(string st) {
            sta = st;
            wml_gb = new WinML_GetBox(sta);
	    }
        /**
        returns the given sum (or any other check)
        */
        int return_given_sum() {

            if (!sta.endsWith(")\n")) {
                new WinML_Expected(')');
			}
            if (wml_gb.Gret()[0] == ADD_OP) { // If it's addition
                string[] narr = wml_gb.Gret().split(" "); // split by space (0: token, 1...: Numbers)
                int fnum = 0; // number that we'll start out with
                foreach (string t; narr.remove(0)) {
                    if (t != null) {
                        fnum = fnum + to!int(t);
					}
				}
                return fnum;
			}
            else if (wml_gb.Gret()[0] == MUL_OP) { // If it's multiplication
                string[] narr = wml_gb.Gret().split(" "); // split by space (0: token, 1...: Numbers)
                int fnum=1; // number that we'll start out with
                foreach (string t; narr.remove(0)) {
                    if (t != null) {
                        fnum = fnum*to!int(t);
					}
                    
				}
                return fnum;
			}
            else if (wml_gb.Gret()[0] == DIV_OP) { // If it's divison
                string[] narr = wml_gb.Gret().split(" "); // split by space (0: token, 1...: Numbers)
                int fnum=1; // number that we'll start out with
                narr = narr.remove(0);
                if (narr.length < 2) {
                    writeln("Invalid Division Expression!\nSyntax Error: Requires two numbers (/ 100 50)");
				} else {
                    fnum = to!int(narr[0]) / to!int(narr[1]);
				}
                return fnum;
			}
            else if (wml_gb.Gret()[0] == '&') { // If it's divison
                string[] narr = wml_gb.Gret().split(" "); // split by space (0: token, 1...: Numbers)
                float fnum=1; // number that we'll start out with
                narr = narr.remove(0);
                if (narr.length < 2) {
                    writeln("Invalid Division Expression!\nSyntax Error: Requires two numbers (/ 100 50)");
				} else {
                    fnum = to!float(narr[0]) / to!float(narr[1]);
				}
                writeln("f: "~to!string(fnum));
                return to!int(fnum);
			}
            else if (wml_gb.Gret()[0] == '?') { // If it's REFERENCE
                string[] narr = wml_gb.Gret().split(" "); // split by space (0: token, 1...: Numbers)
                if (narr.length == 2) {
                    writeln("r: "~to!string(&narr[1]));
				}
                return 1;
			}
            else if (wml_gb.Gret()[0] == SUB_OP) { // If it's subtraction
                string[] narr = wml_gb.Gret().split(" "); // split by space (0: token, 1...: Numbers)
                int fnum=0; // number that we'll start out with
                narr = narr.remove(0);
                if (narr.length > 2 || narr.length < 2) {
                    writeln("s: Value too low! Syntax: (- <num1> <num2>)");
				} else {
                    fnum = to!int(narr[0]);
				}

                return fnum-to!int(narr[1]);
			}
            return -1;
		}

        
}

int main(string[] args)
{
    if (args.length > 1) {
        if (args[1] == "-help") {
            writeln("Usage: WinML [--help] [-exec]");
	    }
        else if (args[1] == "-exec") {
            writeln(new WinML_Adder(args[1]).return_given_sum());
	    } else if (args[1] == "-readme") {
            File f = File("README", "r");
            while (!f.eof()) {
                string ln = f.readln();
                writeln(ln);
		    }
	    }
	}
    writeln("WinML: Quick Math Evaluator.\nCopyright 2021 (C) Kai D. Gonzalez");
    while (1) {   
        write(">>>");
        WinML_Adder wml_a = new WinML_Adder(readln());
        try {
            writeln(wml_a.return_given_sum());
		} catch (Exception e) {
            writeln("An Error Occurred in the main process!");
            writeln("Would you like to try again?");
            string inp = readln();
            if (inp == "y") {
                main(args);
			} else {
                return -1;
			}
		}
	}
    return 0;
}
