#!/usr/bin/env awk -f
function next_token(    tok) {
    if (currchar > nchars) { print "PROCESSING ERROR 1"; exit 1 }
    tok = chars[currchar++]
    switch (tok) {
    case /[-0-9]/:
        while (chars[currchar] ~ /[0-9]/) tok = tok chars[currchar++]
        return tok+0
    case "\"":
        tok = ""
        while (chars[currchar] != "\"") tok = tok chars[currchar++]
        ++currchar
        return (tok == "red") ? "RED" : "STR"
    case /[\[\{\]\},:]/:
        return tok
    default:
        print "PROCESSING ERROR 2"; exit 1
    }
}
function parse(token,    sum, red)
{
    if (token == "{") {
        if (chars[currchar] == "}") {
            next_token()
            return 0
        }
        while (token != "}") {
            token = next_token()
            if (token != "STR" && token != "RED") { print "PROCESSING ERROR 3"; exit 1 }
            token = next_token()
            if (token != ":") { print "PROCESSING ERROR 4"; exit 1 }
            token = next_token()
            switch (token) {
            case /[\[\{]/:
                sum += parse(token)
                break
            case /[-0-9]+/:
                sum += token
                break
            case "STR":
                break
            case "RED":
                red = 1
                break
            default:
                print "PROCESSING ERROR 5"; exit 1
            }
            token = next_token()
            if (token ~ /,\}/) { print "PROCESSING ERROR 6"; exit 1 }
        }
        return red ? 0 : sum+0
    } else if (token == "[") {
        if (chars[currchar] == "]") {
            next_token()
            return 0
        }
        while (token != "]") {
            token = next_token()
            switch (token) {
            case /[\[\{]/:
                sum += parse(token)
                break
            case /[-0-9]+/:
                sum += token
                break
            case "STR":
                break
            case "RED":
                break
            default:
                print "PROCESSING ERROR 7"; exit 1
            }
            token = next_token()
            if (token ~ /,\}/) { print "PROCESSING ERROR 8"; exit 1 }
        }
        return sum+0
    } else { print "PROCESSING ERROR 9"; exit 1 }
}
{
    nchars = split($0, chars, "")
    currchar = 1
    print parse(next_token())
}
