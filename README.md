# Selenium_Py.ahk
Selenium_Py.ahk

Using the Selenium 4 python library to pull Chrome webdriver, pass commands, and retrieve values or interact.
Following syntax, found here: https://www.selenium.dev/documentation/#tabs-03-01 (python)

Download exe for Selenium driver and python here: https://github.com/samfisherirl/Selenium_Py.ahk/releases/download/v1/Selenium_Py.ahk.zip

EXE compiled for driver here. https://github.com/samfisherirl/Selenium_Py.ahk

```autohotkey

params := ["get", "https://slatestarcodex.com/"]
obj := Selenium.Commands(Params, settings)

PID := obj.start()
returnValue := obj.call() ; true if no value but successful

obj.updateParams(["click", "LINK_TEXT", "INTRODUCING ASTRAL CODEX TEN"])
obj.call()

obj.updateParams(["get_links"])

```
 Very messy, just a concept so far. I have extra functions and need to reorganize, but I just wanted to put it out in the ether for feedback. I may move to passing command lines instead of log data, we'll see.

Log.txt stores "false" until command written to file, listener imports function and args. upon completing task, value returns to false to notify ahk.
log_out.txt stores return values including single or lists of links.

library webdriver_manager handles chrome version to ensure no bothering with chrome driver exe versions.

