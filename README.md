# Selenium_Py.ahk
Selenium_Py.ahk

Using the Selenium 4 python library to pull Chrome webdriver, pass commands, and retrieve values or interact.
Following syntax, found here: https://www.selenium.dev/documentation/#tabs-03-01 (python)

Download exe for Selenium driver and python here: https://github.com/samfisherirl/Selenium_Py.ahk/releases/download/v1/Selenium_Py.ahk.zip

EXE compiled for driver here. https://github.com/samfisherirl/Selenium_Py.ahk

Finding web elements https://www.selenium.dev/documentation/webdriver/elements/finders/
Locating the elements based on the provided locator values. https://www.selenium.dev/documentation/webdriver/elements/interactions/
Interacting with web elementshttps://www.selenium.dev/documentation/webdriver/elements/interactions/

todo: needs to be able to input form data, should be running soon.

```autohotkey
;A high-level instruction set for manipulating form controls.
settings := [A_ScriptDir . "\lib\selenium_ahk.exe"]
chrome := Selenium.Commands(["get", "https://slatestarcodex.com/"], settings)

PID := chrome.PID ; manipulate window

chrome.start()
; initiate driver, if first time, downloads appropriate webdriver automatically & restarts
; navigates to initial url request

chrome.newCall(["click", "PARTIAL_LINK_TEXT", "CODEX"])
chrome.newCall(["get_link", "ID", "a"])
chrome.newCall(["click", "CLASS_NAME", "data"])

MsgBox(chrome.read())
;upon retrieving value like "all_links" or "get_link", log is stored locally and object has retrievable value

chrome.newCall(["all_links"])
MsgBox(chrome.read())
```

Very messy, just a concept so far. I have extra functions and need to reorganize, but I just wanted to put it out in the ether for feedback. I may move to passing command lines instead of log data, we'll see.

Log.txt stores "false" until command written to file, listener imports function and args. upon completing task, value returns to false to notify ahk.
log_out.txt stores return values including single or lists of links.

library webdriver_manager handles chrome version to ensure no bothering with chrome driver exe versions.

