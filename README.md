# Selenium_Py.ahk
Selenium_Py.ahk

Using the Selenium 4 python library to pull Chrome webdriver, pass commands, and retrieve values or interact.
Following syntax, found here: https://www.selenium.dev/documentation/#tabs-03-01 (python)

Download exe for Selenium driver and python here: https://github.com/samfisherirl/Selenium_Py.ahk/releases/download/v1/Selenium_Py.ahk.zip

EXE compiled for driver here. https://github.com/samfisherirl/Selenium_Py.ahk

```autohotkey
Drivers.sendCommand("--get--https://github.com/samfisherirl")
;get for navigating to url, separated by "--"
```
```autohotkey
Drivers.sendCommand("--click--LINK_TEXT--github.ahk")
;By.LINK_TEXT for reference, "github.ahk"
```
```autohotkey
msg := Drivers.retrieveValue("--get_link--ID--pull-requests-tab")
msgbox(msg) ; retrieves url for pull request tab
```
Very messy, just a concept so far. I have extra functions and need to reorganize, but I just wanted to put it out in the ether for feedback. I may move to passing command lines instead of log data, we'll see.

Log.txt stores "false" until command written to file, listener imports function and args. upon completing task, value returns to false to notify ahk.
log_out.txt stores return values including single or lists of links.

library webdriver_manager handles chrome version to ensure no bothering with chrome driver exe versions.

