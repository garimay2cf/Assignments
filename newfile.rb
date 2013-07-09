#$/="END"
#user_input=STDIN.gets
#output=user_input.split(/\n/)
#print output

def multiline
    text=""
    while (txt = gets) != "\n"
        text << txt
    end
    return text
end

output=multiline

lines=output.split(/\n/)

#line=lines[1]
#chars=line.split
#print chars
stack = [[0,0,0,0,0,0,0], [0,0,0,0,0,0,0], [0,0,0,0,0,0,0], [0,0,0,0,0,0,0], [0,0,0,0,0,0,0], [0,0,0,0,0,0,0]]
vars={"dictionary"=>100}
top=-1
count=-1
regex=/[a-z]/
lines.each do |line|
    chars=line.split
    if chars[0]=="["
        top=top+1
    elsif chars[0]=="print"
        if(vars.has_key?(chars[1]))
            val = stack[vars[chars[1]]][top]
            topnew=top
            while val==0
            
                if topnew==-1
                    break
                end
                topnew=topnew-1;
                val = stack[vars[chars[1]]][topnew]
            end
        
                print stack[vars[chars[1]]][topnew].to_s + "\n"
            else
                print "0"
         end
    elsif chars[0]=="]"
        #print stack
        stack.each do |x|
            x[top]=0
            end
        top=top-1
    elsif regex.match(chars[0]) && regex.match(chars[1])
        
        val = stack[vars[chars[1]]][top]
        topnew=top
        while val==0
            
            if topnew==-1
                break
            end
            topnew=topnew-1;
            #stack[vars[chars[0]]][top]=stack[vars[chars[1]]][topnew]
            val = stack[vars[chars[1]]][topnew]
            end
            stack[vars[chars[0]]][top]=val
    else
        if(!vars.has_key?(chars[0]))
            count=count+1
            vars[chars[0]]=count
        end
            stack[vars[chars[0]]][top]=chars[1]
    end
end
#print stack
