   +--+
  ++  |
+-++--+
|  |  |
+--+--+

"+-+",
"| |",
"+-+",

"+-+-+",
"| | |",
"+-+-+",
"| | |",
"+-+-+",

for y,row in m:
    for x,v in row:
        match v:
            '+' => detect(top, m)
            _ => _
; sx = starter x
; sy = starter y
detect(state, m, sx, sy):
    match state:
        top =>`
            match m.x+1:
                '-' => detect(top, m, sx, sy)
                '+' => 
                    detect(right, m, sx, sy)        // rectangle
                        + detect(top, m, x , y)     // composite rectangle
                _   => detect(fail, m, sx, sy)

        right =>
            match m.y+1:
                '|' => detect(right, m, sx, sy)     
                '+' => 
                    detect(bottom, m, sx, sy)    // rectangle
                        + detect(right, m, x ,y) // composite rectangle
                '_' => detect(fail, m, sx, sy)
        
        bottom =>
            match m.x-1:
                '-' => detect(bottom, m, sx, sy)
                '+' => 
                    detect(left, m, sx, sy)       // rectangle
                        + detect(bottom, m, x, y) // composite rectangle
                _   => detect(fail, m, sx, sy, sx, sy)
        
        left =>
            match m.y-1:
                '|' => detect(left, m, sx, sy)
                '+' => 
                    detect(success, m, sx, sy)  // rectangle
                        + detect(left, m, x, y) // composite rectangle
                _   => detect(fail, m, sx, sy)
        
        fail => 0
        
        success => if (m.x == sx && m.y == sy) {1} else {0}
