import "parser" as parser

def str = getFileContents "test.grace"
def pr = parser.parse(str)
print(pr)