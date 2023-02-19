import socket

with open('users.txt') as f:
    for line in f:
        # remove spaces at the beginning and end of the line
        lineTrimmed = line.strip()
        lineParts = lineTrimmed.split() 

        if(len(lineParts) < 3):
            continue
        #check if email
        if('@' not in lineParts[1] and '.' not in lineParts[1]):
            continue
        # get email domain
        emailDomain = lineParts[1].split('@')[1]
        try:
            ip_address = socket.gethostbyname(emailDomain)
        except:
            continue

        try:
            int(lineParts[2])
        except ValueError:
            continue

        isEven = int(lineParts[2])%2 == 0

        # check if iseven true if so make it even else make it odd
        if(isEven):
            isEven = 'even'
        else:
            isEven = 'odd'

        print(lineParts[0] + ' ID:(' + lineParts[2] + ') of ' + lineParts[1] + ' is ' + isEven + ' number')
        print('--')