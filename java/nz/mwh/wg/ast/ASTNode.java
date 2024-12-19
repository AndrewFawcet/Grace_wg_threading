package nz.mwh.wg.ast;

import nz.mwh.wg.Visitor;
import nz.mwh.wg.runtime.GraceObject;
import nz.mwh.wg.runtime.GracePort;

public abstract class ASTNode{

    public abstract <T> T accept(T context, Visitor<T> visitor);

    // Overloaded accept method for threaded communication
    // public <T> T accept(T context, Visitor<T> visitor, GracePort<GraceObject> port) {
    //     // Default implementation calls the original accept method
    //     return accept(context, visitor);
    // }
    public <T, SendT, ReceiveT> T accept(T context, Visitor<T> visitor, GracePort<SendT, ReceiveT> port) {
        // Default implementation calls the original accept method
        return accept(context, visitor);  // Assuming another accept method exists for this type
    }


    protected static String escapeString(String value) {
        
        for (int i = 0; i < value.length(); i++) {
            char c = value.charAt(i);
            if (c == '\\') {
                return "safeStr(\"" + value.substring(0, i) + "\", charBackslash, " + escapeString(value.substring(i + 1)) + ")";
            }
            if (c == '$') {
                return "safeStr(\"" + value.substring(0, i) + "\", charDollar, " + escapeString(value.substring(i + 1)) + ")";
            }
            if (c == '*') {
                return "safeStr(\"" + value.substring(0, i) + "\", charStar, " + escapeString(value.substring(i + 1)) + ")";
            }
            if (c == '{') {
                return "safeStr(\"" + value.substring(0, i) + "\", charLBrace, " + escapeString(value.substring(i + 1)) + ")";
            }
            if (c == '\n') {
                return "safeStr(\"" + value.substring(0, i) + "\", charLF, " + escapeString(value.substring(i + 1)) + ")";
            }
            if (c == '\r') {
                return "safeStr(\"" + value.substring(0, i) + "\", charCR, " + escapeString(value.substring(i + 1)) + ")";
            }
            if (c == '"') {
                return "safeStr(\"" + value.substring(0, i) + "\", charDQuote, " + escapeString(value.substring(i + 1)) + ")";
            }
            if (c == '~') {
                return "safeStr(\"" + value.substring(0, i) + "\", charTilde, " + escapeString(value.substring(i + 1)) + ")";
            }
            if (c == '^') {
                return "safeStr(\"" + value.substring(0, i) + "\", charCaret, " + escapeString(value.substring(i + 1)) + ")";
            }
            if (c == '`') {
                return "safeStr(\"" + value.substring(0, i) + "\", charBacktick, " + escapeString(value.substring(i + 1)) + ")";
            }
            if (c == '@') {
                return "safeStr(\"" + value.substring(0, i) + "\", charAt, " + escapeString(value.substring(i + 1)) + ")";
            }
            if (c == '&') {
                return "safeStr(\"" + value.substring(0, i) + "\", charAmp, " + escapeString(value.substring(i + 1)) + ")";
            }
            if (c == '%') {
                return "safeStr(\"" + value.substring(0, i) + "\", charPercent, " + escapeString(value.substring(i + 1)) + ")";
            }
        }
        return "\"" + value.replace("\\", "\\\\")
            .replace("\n", "\\n")
            .replace("\r", "\\r")
            .replace("\"", "\\\"") + "\"";
    }

}