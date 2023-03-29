settings := [A_ScriptDir . "\lib\selenium_ahk.exe"]
chrome := Selenium.Commands(["get", "https://slatestarcodex.com/"], settings)

chrome.start() ; true if no value but successful
PID := chrome.PID ; manipulate window

chrome.newCall(["click", "PARTIAL_LINK_TEXT", "CODEX"])
chrome.newCall(["get_link", "PARTIAL_LINK_TEXT", "ARCHIVE"])

MsgBox(chrome.read())

chrome.newCall(["all_links"])
MsgBox(chrome.read())

; returns link by text name
chrome.quit()
/*
chrome.newCall(["click", "TAG_NAME", "A"])
chrome.newCall(["click", "TAG_NAME", "A"])
find_element(By.ID, "id")
find_element(By.NAME, "name")
find_element(By.XPATH, "xpath")
find_element(By.LINK_TEXT, "link text")
find_element(By.PARTIAL_LINK_TEXT, "partial link text")
find_element(By.TAG_NAME, "tag name")
find_element(By.CLASS_NAME, "class name")
find_element(By.CSS_SELECTOR, "css selector")
*/
class Selenium
{
    class Commands
    {
        __New(command, settings) {
            key := command.Length
            this.function := command[1]
            this.key := command.Length
            this.PID := ""
            SplitPath(settings[1], , &folder)
            this.folder := folder
            this.temp := folder . "\temp.txt"
            this.log := folder . "\log.txt"
            this.out := folder . "\log_out.txt"
            this.selpath := Settings[1]
            this.storage := ""
            if (key > 1) {
                this.paramX := command[2]
                if (key > 2) {
                    this.paramY := command[3]
                    if (key > 3) {
                        this.paramZ := command[4]
                    } }
            }
            this.command := command
        }

        start() {
            if !FileExist(this.log) and !FileExist(this.temp) {
                msg := "This may be your first time using, please restart after selenium driver download."
                msgbox(msg)
                this.stringify()
                Run(this.selpath, this.folder, , &PID)
                exitapp

            }
            this.clean(this.log)
            this.clean(this.temp)
            this.stringify()
            Run(this.selpath, this.folder, , &PID)
            this.pid := PID
            this.call() 
            sleep(1000)

        }
        call() {
            
            this.clean(this.log)
            this.clean(this.out)
            this.stringify()
            this.loopEngage()
            Selenium.Commands.delLog(this.out)
            
        }
        loopEngage(){
            f := this.function
            if (instr(f,"get_link")) or (instr(f,"get_links")) or (instr(f,"all_links")) {
                this.readLog(this.out, 2)
            }
            else if (instr(f,"quit")) {
                exitapp
            }
            else {
                this.readLog(this.log, 1)
            }
        }
        stringify(){
            stringify := ""
            loop this.command.Length {
                stringify .= "--" . this.command[A_Index]
            }
            Selenium.Commands.delLog(this.temp)
            sleep(5)
            FileAppend(stringify, this.temp)
        }
        quit(){
            this.newCall(["quit"])
            exitapp
        }
        clean(file){
            if FileExist(file) {
                Selenium.Commands.delLog(file)
            }
        }
        newCall(params) {
            Sleep(500)
            this.command := params
            this.key := params.Length
            this.function := params[1]
            if (this.key > 1) {
                this.paramX := params[2]
                if (params.Length > 2) {
                    this.paramY := params[3]
                    if (params.Length > 3) {
                        this.paramZ := params[4]
                    }
                } 
            }
            this.call()
        }
        readLog(file, mode) {
            x := "`n"
            loop 50
            {
                if (A_Index == 50) {
                    msg := this.function . x .
                        file . x .
                        this.PID . x .
                        x . this.storage . x . mode
                    FileAppend(msg, A_ScriptDir "\er.txt")
                    Msgbox("Looping, not receiving updates from selenium`nLogdump:`n" . msg)
                    processclose(this.PID)
                    exitapp
                }
                else if FileExist(file) {
                    try {
                        output := FileRead(file)
                    }
                    catch {
                        Sleep(200)
                        continue
                    }
                    if (mode == 1) {
                        if (instr(output, "False")) {
                            break
                        }
                        else {
                            Sleep(200)
                            continue
                        }
                    }
                    else if (mode == 2) {
                        this.storage := output
                        Selenium.Commands.delLog(file)
                        break
                    }
                    else {
                        if (output == this.paramX) {
                        sleep(200)
                        break
                        }
                        else {
                            sleep(200)
                            continue
                        }
                    }
                }
                else {
                    Sleep(200)
                    continue
                }
            }

        }
        read()
        {
            return this.storage
        }

        static delLog(log) {
            loop 10 {
                try {
                    FileDelete(log)
                }
                catch {
                    sleep(50)
                } 
            }
        }
    }
}