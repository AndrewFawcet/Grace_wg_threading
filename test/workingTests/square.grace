// simple example of iso referenceing a imm object
// emulating example from :Domains: Sharing state in the communicating event-loop actor model
// file:///C:/PhD/Research%20Papers/Other/1-s2.0-S147784241600004X-main.pdf

// Immutable Area Object (calculates area)
var squareArea := object is iso {
    method new(side) {
        object is iso {
            var sideValue := side

            method calculateArea() -> Number {
                return sideValue * sideValue
            }
        }
    }
}

// Square Object (sets side and consults ImmutableArea for area calculation)
var square := object is iso {
    method new(){
        object is iso {
            var side := 0

            method setSide(newSide) {
                side := newSide
            }

            // Method to get the area using the Immutable object
            method getArea() {
                return squareArea.new(side).calculateArea()
            }
        }
    }
}

// Example Usage:
var mySquare := square.new()
mySquare.setSide(5)
print("Area of the 5 * 5 square: {mySquare.getArea()} . ")  
print "Should print area as 5 * 5 = 25 "
