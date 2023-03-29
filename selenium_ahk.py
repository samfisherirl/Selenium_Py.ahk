from selenium.webdriver import Chrome #, ChromeOptions
from selenium.webdriver.chrome.service import Service as ChromeService
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from time import sleep
from pathlib import Path

log = Path.cwd()  / "log.txt"
temp = Path.cwd()  / "temp.txt"
out = Path.cwd() / "log_out.txt"
    #options = ChromeOptions()
    #options.add_experimental_option('excludeSwitches', ['enable-logging'])

driver = Chrome(service=ChromeService(ChromeDriverManager().install()))

class Sel:
    def __init__(self):
        self.links = []
        self.running = True
        self.element = None
        self.lastcommand = ""
        self.counter = 0

    def listener(self):
        while True:
            sleep(1)
            if self.running == False:
                break
            else:
                self.reader()

            
    def reader(self):
        if Path.is_file(temp):
            with open(temp, "r") as f:
                command = f.read() 
            with open(log, "w") as f:
                f.write("True")
            if command == self.lastcommand or command == "":
                return True
            else:
                print(f"\n\nSuccess!\n{command}\n")
                self.lastcommand = command
                self.commander(command)
        else:
            Sel.write_ahk_log("False", log)
        

    @staticmethod
    def write_ahk_log(notes, file):
        with open(file, "w") as f:
            print(notes)
            f.write(notes)
            
    def commander(self, command):
        try: 
            counter = command.count("--") 
            command = command.split("--")       
            if command[1] == "quit":
                self.close_driver()
            elif counter == 1:
                self.call_function_by_name(command[1])
            elif counter == 2:
                self.call_function_by_name(command[1], command[2])
            elif counter == 3:
                self.call_function_by_name(command[1], command[2], command[3])
            elif counter == 4:
                self.call_function_by_name(command[1], command[2],command[3], command[4])
            
        except Exception as e:
            print(str(e))
            Sel.write_ahk_log(str(e), out)
            self.close_driver()
    
    def enum_commands(self, *args):
        if args[0]:
            self.call_function_by_name(args[0])
        else:
            self.call_function_by_name(args[0], args[1:])
            
    def call_function_by_name(self, function_name, *arg):
        print(f"\n\ncall\n{function_name}\n{arg}\n")
        func = getattr(self, function_name)
        if not arg:
            func()
        elif len(arg) == 1:
            print(str(arg))
            func(arg[0])
        elif len(arg) == 2:
            print(str(arg))
            func(arg[0], arg[1])
        Sel.write_ahk_log("False", log) 

    def get(self, url):
        """Navigates to the specified URL"""
        driver.get(url)
        return True

    
    def find_element(self, locator, value):
        return driver.find_element(locator, value)

    def find_elements(self, locator, value):
        return driver.find_elements(locator, value)

    def by(self, locator, value):
        com = getattr(By, locator)
        self.element = self.find_element(com, value)
    
    def click(self, locator, value):
        com = getattr(By, locator)
        self.find_element(com, value).click()
        #print("\n\n\nclicking")
        #com = getattr(By, locator)
        #link = self.find_element(com, value).get_attribute("href")
        #link.click()
    
    def get_link(self, locator, value):
        com = getattr(By, locator)
        link = self.find_element(com, value)
        out_data = link.get_attribute("href")
        if "Message: no such element" in out_data:
            self.err(self, out_data)
        else:
            self.write_listor_string(out_data)
        return out_data
        
    def all_links(self):
        links = self.find_elements(By.TAG_NAME, "a")
        urls = [link.get_attribute("href") for link in links]
        text = [link.text for link in links]
        list = {f"{k}: {v}" for k, v in zip(urls, text)}
        self.write_listor_string(list)
    # def all_links(self):
    #     links = driver.find_elements(By.TAG_NAME, "a")
    #     urls = [link.get_attribute("href") for link in links]
    #     text = [link.text for link in links]
    #     dic = {k: v for k, v in zip(urls, text)}
    #     self.write_listor_string(str(dic))
        
    def wait_until_element_visible(self, locator, value, timeout=1):
        WebDriverWait(driver, timeout).until(EC.visibility_of_element_located((locator, value)))


    def pass_return_to_ahk(val):
        pass

    @staticmethod
    def delete_er():
        with open("er.txt", "w") as f:
            f.write("")
    
    def err(self, e):
        print(str(e))
        with open("er.txt", "a", errors="ignore") as f:
            f.write(str(e))
        with open("er.txt", "a", errors="ignore") as f:
            f.write(str(e))
        self.close_driver()
        

    def write_listor_string(self, *args):
        with open(out, "w", errors="replace") as f:
            if args:
                [f.write(f"{i}\n") for i in args]
                    
        Sel.write_ahk_log("False", log)
    #################################################
        
    def writer(self, dic, filename):
        file = Path(__file__).parent / "log_out.txt"
        with open(f"{file}", "w", errors="ignore") as f:
            for k, v in dic.items():
                f.write(f",{k},{v},\n")
        Sel.write_ahk_log("False", log)


    def close_driver(self):
        """Closes the webdriver instance"""
        driver.quit()
        self.running = False
        return

if __name__ == "__main__":
    print(log)
    print(out)
    Sel.delete_er()
    S = Sel()
    S.listener()
    #drivers = Sel() 
    #drivers.get("https://www.github.com/")
    #drivers.all_links()