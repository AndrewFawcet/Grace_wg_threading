package nz.mwh.wg.ast;

import nz.mwh.wg.Visitor;

public abstract class ASTNode{

    public abstract <T> T accept(T context, Visitor<T> visitor);

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