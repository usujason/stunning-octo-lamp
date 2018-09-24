--Save the script below as an application, run it, and add it to your startup items—it should run continuously in the background
-- v.0.99
-- Ignore Bluetooth Headphones Mic
-- inkedtater@protonmail.com

repeat
    set statusOld to checkStatus()
    set statusNew to checkStatus()

    if statusNew is true then
        tell application "System Preferences" to activate
        tell application "System Preferences"
            reveal anchor "input" of pane id "com.apple.preference.sound"
        end tell
        delay 0.5
        tell application "System Events" to tell process "System Preferences"
            tell table 1 of scroll area 1 of tab group 1 of window 1
                select (row 1 where value of text field 1 is "Internal Microphone")
            end tell
        end tell
        tell application "System Preferences" to quit
    else
        -- Nothing more to do here if the device is disconnected or gone
    end if
    
    repeat while statusOld is equal to statusNew
        delay 5 --Change this value if you want to change how often we check
        set statusNew to checkStatus()
    end repeat
    
    
end repeat

on checkStatus()
    set bluetoothDeviceName to "[YOUR HEADPHONES' NAME]"
    set myString to do shell script "system_profiler SPBluetoothDataType"

    --Lets make sure the Bluetooth Device we are looking for is there
    if myString does not contain bluetoothDeviceName then
        return false
    else

        --find out if connected/disconnected
        set AppleScript's text item delimiters to "name:"
        set myList to the text items of myString --each item of mylist is now one of the devices

        set numberOfDevices to count of myList
        set counter to 1
        repeat numberOfDevices times --loop through each devices checking for Connected string
            if item counter of myList contains bluetoothDeviceName then
                if item counter of myList contains "Connected: Yes" then
                    return true
                else if item counter of myList contains "Connected: No" then
                    return false
                else
                    display dialog "Something went wrong with the script" --this shouldn't happen
                end if
            end if
            set counter to counter + 1
        end repeat
    end if
end checkStatus
