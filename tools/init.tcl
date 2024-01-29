# Inspired from: https://gist.github.com/davidzwa/ef1eafc6cd23e613af612e27eddb054b
set nsigs [ gtkwave::getNumFacs ]
set sigs [list]
# fix a strange bug where addSignalsFromList doesn't seem to work
# if the 1st signal to be added is not a single bit
lappend sigs "__bug_marker__"

# Add non internal-uut signals to design
puts "Appending signals:"
for {set i 0} {$i < $nsigs} {incr i} {
    set signame [ gtkwave::getFacName $i ]
    set index1 [ string first "uut" $signame  ]
    if {$index1 == -1} {
        lappend sigs $signame
	puts "\t$signame"
    }
}
set added [ gtkwave::addSignalsFromList $sigs ]

# Zoom
gtkwave::/Time/Zoom/Zoom_Full

# Show decimal values
gtkwave::/Edit/Highlight_All
gtkwave::/Edit/Data_Format/Decimal
gtkwave::/Edit/UnHighlight_All

# Beautification - View settings
gtkwave::/View/Show_Wave_Highlight
gtkwave::/View/Show_Filled_High_Values
gtkwave::/View/Show_Mouseover
gtkwave::/View/Scale_To_Time_Dimension/None

