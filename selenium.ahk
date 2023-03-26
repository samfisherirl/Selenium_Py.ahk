location := A_ScriptDir "\selenium_ahk.exe"
Drivers := Selenium(location)
PID := Drivers.start()
Sleep(500)

Drivers.sendCommand("--get--https://github.com/samfisherirl")

Drivers.sendCommand("--click--LINK_TEXT--github.ahk")
;store the element until calling command
msg := Drivers.retrieveValue("--get_link--ID--pull-requests-tab")

MsgBox(msg)


class Selenium
{
    __New(location) {
        this.location := location
        SplitPath(location, , &Dir)
        this.pid := ""
        this.log := Dir "\log.txt"
        this.out := Dir "\log_out.txt"
    }
    start() {
        if FileExist(this.log) {
            this.delLog()
        }
        Run(this.location, , , &PID)
        this.pid := PID
        this.logfile()
        return PID
    }
    logfile() {
        if FileExist(this.log) {
            loop 30
            {
                output := FileRead(this.log)
                if (output == "False") {
                    break
                }
                else {
                    Sleep(100)
                }
            }
        }
    }
    sendCommand(command) {
        this.delLog()
        FileAppend(command, this.log)
        loop 300
        {
            out := FileRead(this.log)
            if (out == "False")
            {
                break
            }
            else {
                Sleep(500)
            }

        }
    }
    retrieveValue(command) {
        this.delLog()
        FileAppend(command, this.log)
        loop 20
        {
            out := FileRead(this.log)
            if (out == "False")
            {
                break
            }
            else {
                Sleep(1100)
            }

        }
        return this.returnValue()
    }
    returnValue() {
        if FileExist(this.out) {
            return FileRead(this.out)
        }
    }
    
    delLog() {
        loop 20 {
            try {
                FileDelete(this.log)
            }
            catch {
                sleep(100)
            }
        }
    }
}
/*
    def call_function_by_name(self, function_name, *arg):
        func = getattr(self, function_name)
        if arg:
            func(arg)
        else:
            func()

    def pass_return_to_ahk(val):
        pass


    def nav(self, url):
        """Navigates to the specified URL"""
        self.driver.get(url)
        return False

    def find_element_by_id(self, id):
        """Finds an element by its ID"""
        element = self.driver.find_element_by_id(id)
        self.element = element

    def find_element_by_name(self, name):
        """Finds an element by its name"""
        element = self.driver.find_element_by_name(name)
        self.element = element

    def find_element_by_xpath(self, xpath):
        """Finds an element by its xpath"""
        element = self.driver.find_element_by_xpath(xpath)
        self.element = element

    def click_element(self, element):
        """Clicks an element"""
        if (self.element.click()): self.element.click()
        self.element = None

    def input_text(self, text):
        """Inputs text into an input element"""
        self.element.send_keys(text)

    def click_element_by_id(self, id):
        """Finds and clicks an element by its ID"""
        self.element = self.find_element_by_id(id)
        self.click_element(self.element)

    def click_element_by_name(self, name):
        """Finds and clicks an element by its name"""
        element = self.find_element_by_name(name)
        self.click_element(element)

    def click_element_by_xpath(self, xpath):
        """Finds and clicks an element by its xpath"""
        element = self.find_element_by_xpath(xpath)
        self.click_element(element)

    def get_links(self):
        links = self.driver.find_elements_by_tag_name("a")
        urls = [link.get_attribute("href") for link in links]
        text = [link.text for link in links]
        dic = {k: v for k, v in zip(urls, text)}
        self.writer(dic, "links")

    def writer(self, dic, filename):
        file = Path(__file__).parent / filename
        with open(f"{file}.txt", "w") as f:
            for k, v in dic.items():
                f.write(f",{k},{v},\n")


    def close_driver(self):
        """Closes the webdriver instance"""
        self.driver.quit()
        self.running = False
*/
