address = "asdasdasd(4444)"
strStart = address.index('(')
strEnd = address.index(')')
address2 = address[0..(strStart-1)]
    
puts address2