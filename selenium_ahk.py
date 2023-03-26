from selenium.webdriver import Chrome #, ChromeOptions
from selenium.webdriver.chrome.service import Service as ChromeService
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from time import sleep
from pathlib import Path

    #options = ChromeOptions()
    #options.add_experimental_option('excludeSwitches', ['enable-logging'])
log = Path.cwd()  / "log.txt"
out = Path.cwd() / "log_out.txt"
print(log)
print(out)
driver = Chrome(service=ChromeService(ChromeDriverManager().install()))

class Sel:
    def __init__(self):
        self.links = []
        self.running = True
        self.element = None

    def listener(self):
        while True:
            sleep(.5)
            if self.running == False:
                break
            else:
                self.reader()

            
    def reader(self):
        if Path.is_file(log):
            with open(log, "r") as f:
                command = f.read()
            if str(command) == "False":
                return True
            else:
                print("\n\nSuccess!\n\n")
                self.commander(command)        
        else:
            self.write_ahk_log("False", log)
        

    @staticmethod
    def write_ahk_log(notes, file):
        with open(file, "w") as f:
            f.write(notes)
            
    def commander(self, command):
        try:
            if command.count("--") == 2:
                command = command.split("--")
                self.call_function_by_name(command[1], command[2])
            elif command.count("--") == 3:
                command = command.split("--")
                self.call_function_by_name(command[1], command[2], command[3])
            elif command.count("--") == 1:
                command = command.split("--")
                print(str(command))
                self.call_function_by_name(command[1])
            elif command == "-quit":
                self.close_driver()
        except Exception as e:
            print(str(e))
            sleep(15)
            
    def call_function_by_name(self, function_name, *arg):
        func = getattr(self, function_name)
        if not arg:
            func()
        elif len(arg) == 1:
            func(arg[0])
        elif len(arg) == 2:
            func(arg[0], arg[1])
        self.write_ahk_log("False", log)

    def get(self, url):
        """Navigates to the specified URL"""
        driver.get(url)
        return True

    
    def find_element(self, locator, value):
        return driver.find_element(locator, value)

    def by(self, locator, value):
        com = getattr(By, locator)
        self.element = self.find_element(com, value)
    
    def click(self, locator, value):
        com = getattr(By, locator)
        self.find_element(com, value).click()
    
    def get_link(self, locator, value):
        com = getattr(By, locator)
        out_data = self.find_element(com, value).get_attribute("href")
        self.write_out(out_data)
        
    def get_links(self, locator, value):
        com = getattr(By, locator)
        out_data = self.find_elements(com, value).get_attribute("href")
        self.write_out(out_data)
        
    def wait_until_element_visible(self, locator, value, timeout=10):
        WebDriverWait(driver, timeout).until(EC.visibility_of_element_located((locator, value)))


    def pass_return_to_ahk(val):
        pass

    def err(self, e):
        with open("er.txt", "a") as f:
            f.write(str(e))

    def write_out(self, *args):
        with open(out, "w") as f:
            if args:
                for i in args:
                    f.write(f"{i}\n")
        self.write_ahk_log("False", log)
    ##################################################
    def get_links(self):
        links = driver.find_elements_by_tag_name("a")
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
        driver.quit()
        self.running = False

if __name__ == "__main__":
    drivers = Sel() 
    drivers.listener()