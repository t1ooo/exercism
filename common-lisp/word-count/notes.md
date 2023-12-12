In:
That's the password: 'PASSWORD 123'!", cried the Special Agent.\nSo I fled

Out:
that's: 1
the: 2
password: 2
123: 1
cried: 1
special: 1
agent: 1
so: 1
i: 1
fled: 1

algo:
    to lower
        (string-downcase "string")
    
    remove not alpha, num, '
        regexp [^a-z\d']
        || 
        filter
            (defun valid-char-p(ch)
                (find ch (concatenate 'string "qwertyuiopasdfghjklzxcvbnm" "1234567890" "'")))
    
    trim
        (string-trim '(#\Space #\Tab #\Newline) "string")
    
    ? replace whitespace to " "
        // (map 'string #'(lambda(v) (char-downcase v)) "1 2 3")
    split by whitespace
        regexp \s+
        ||
        loop for ch across string
            if ch is whitespace
                i++
            else
                array[i].append(ch) 
      
    count of each word
        uniq
        find each uniq word in array
        ||
        sort
        iter and ++ word, when prev==current
        
algo2:
    to lower
    
    def split_by_valid_chars(str):
        valid_chars = list("qwertyuiopasdfghjklzxcvbnm" + "1234567890" + "'")
        words = []
        prev_ch = ""
        i = 0
        for ch in str:
            if ch in valid_chars:
                if len(words) < i+1:
                    words.append("")
                words[i] += ch
            elif prev_ch in valid_chars:
                    i += 1
            prev_ch = ch
        return words

    def count_of_each_word(words):
        counts = {}
        for word in words:
            if word not in counts:
                counts[word] = 0
            counts[word] += 1
        return counts
        
        
 