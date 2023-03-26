cd := A_ScriptDir . "\lib"
settings := [
    cd . "\log.txt",
    cd . "\selenium_ahk.py"
]

params := ["get", "https://slatestarcodex.com/"]
obj := Selenium.Commands(Params, settings)

PID := obj.start()
returnValue := obj.call() ; true if no value but successful

obj.updateParams(["click", "LINK_TEXT", "INTRODUCING ASTRAL CODEX TEN"])
obj.call()

obj.updateParams(["get_links"])


/*
<input type="text" name="passwd" id="passwd-id" />
you could find it using any of:
element = driver.find_element(By.ID, "passwd-id")
element = driver.find_element(By.NAME, "passwd")
element = driver.find_element(By.XPATH, "//input[@id='passwd-id']")
element = driver.find_element(By.CSS_SELECTOR, "input#passwd-id")

*/
class Selenium
{


    class Commands
    {
        __New(command, settings) {
            key := command.Length
            this.function := command[1]
            this.paramX := command[2]
            this.key := key
            this.PID := ""
            this.log := Settings[1]
            SplitPath(Settings[1],,&folder)
            this.temp := folder . "\temp.txt"
            this.out := folder . "\log_out.txt"
            this.selpath := Settings[3]
            if (key > 2) {
                this.paramY := command[3]
                if (key > 3) {
                    this.paramZ := command[4]
                }
            }
            this.command := command
        }
        updateParams(params) {
            this.command := params
            this.function := params[1]
            this.paramX := params[2]
            if (params.Length > 2) {
                this.paramY := params[3]
                if (params.Length > 3) {
                    this.paramZ := params[4]
                }
            }
        }

        start() {
            if FileExist(this.log) {
                ; this.delLog()
            }
            Run(this.selpath, cd, , &PID)
            this.pid := PID
            this.readLog(this.log)
            return PID

        }
        call() {
            if FileExist(this.log) {
                Sleep(5)
            }
            stringify := ""
            loop this.command.Length {
                stringify .= "--" . this.command[A_Index]
            }
            FileAppend(stringify, this.temp)
            FileMove(this.temp, this.log, 1)
            f := this.function
            if (f = "get_link") or (f = "get_links") {
                if FileExist(this.out) {
                    this.readLog(this.out)
                    out := FileRead(this.out)
                    return out
                }
            }
            else {
                this.readLog(this.log)
                return True
            }
        }            
        readLog(file) {
                loop 20
                {   
                    if (A_Index == 20) {
                        Msgbox("Looping, not receiving updates from selenium")
                    }
                    if FileExist(file) {
                        output := FileRead(file)
                        if (instr(output, "False")) {
                            break
                        }
                        else {
                            Sleep(500)
                        }
                    }
                    else {
                        Sleep(500)
                    }
                }

            }

            delLog() {
                loop 20 {
                    try {
                        FileDelete(this.log)
                    }
                    catch {
                        sleep(150)
                    }
                }
            }
        }
    }