import sys, re, configparser, pathlib, os, subprocess, psutil, time
from colorama import Fore, Back, Style

def log(message, type = 'log'):
    match type:
        case 'info':
            title = 'Info'
            back = Back.WHITE
            fore = Fore.WHITE
        case 'warn':
            title = 'Warn'
            back = Back.YELLOW
            fore = Fore.YELLOW
        case 'error':
            title = 'Err '
            back = Back.RED
            fore = Fore.RED
        case 'ok':
            title = ' Ok '
            back = Back.GREEN
            fore = Fore.GREEN
        case 'header':
            title = f'        {message}        '
            message = ''
            back = Back.WHITE
            fore = Fore.WHITE
        case 'fail':
            title = 'Fail'
            back = Back.RED + Style.DIM
            fore = Fore.RED + Style.DIM
        case _:
            title = '    '
            back = Back.LIGHTBLACK_EX
            fore = Fore.LIGHTBLACK_EX

    print(f'{back} {title} {Back.RESET}', end='')
    print(Back.RESET + fore + " " + message, end='')
    print(Style.RESET_ALL)

# Get arguments from command line
options = sys.argv[1:]
arguments = {}
for (index, option) in enumerate(options):
    if(re.match(r'^--[a-zA-Z]+$', option) != None):
        valueIndex = index + 1
        valueIndex = valueIndex if valueIndex <= len(options) else None
        if valueIndex > len(options) -1 or (valueIndex < 0):
            log(f'Option {option} has no value', 'error')
            exit(2)
        arguments[option.replace('--', '').lower()] = options[valueIndex]

# Get the tasks configuration
config = configparser.ConfigParser()
config_content = "[DEFAULT]\n" + open('./ocen/oi.conf').read()
config.read_string(config_content)
config = config['DEFAULT']

# Get tests
tests = {}
tasks = config['tasks'].replace('"', "").split(' ')
for task in tasks:
    test = config['tests_' + task]
    tests[task] = test.replace('"', '').split(' ')
    
# Verify input
task = arguments.get('task')
test = arguments.get('test') or 'all'

if(task not in tasks):
    tasklist = '/'.join(tasks)
    log(f"Task name invalid, please specify a valid: --task {tasklist}", 'error')
    exit(2)

selectedTests = []
if(test == 'all'):
    selectedTests = tests[task]
else:
    if(not str(test).isnumeric()):
        log(f"Test number invalid type, please specify a valid: --test [number]", 'error')
        exit(2)
    test = int(test)
    if test > len(tests[task]) - 1 or test < 0:
        testlist = '/'.join(tests[task])
        log(f"Test number invalid, please specify a valid: --test {testlist}", 'error')
        exit(2)
    selectedTests.append(tests[task][test])

stats = {
    'ok': 0,
    'fail': 0,
    'error': 0
}
def doTest(testname):

    paths = {
        "in": f"./ocen/in/{task}{testname}.in",
        "out": f"./ocen/out/{task}{testname}.out",
    }
    files = {}
    def readTextFile(path):
        with open(path, 'r') as file:
            return file.read()
        
    for type in paths.keys():
        path = paths[type]
        abs = pathlib.Path(path).absolute()
        if(not os.path.exists(abs)):
            print(f"File {path} not found")
            exit(2)
        files[type] = readTextFile(abs)

    # Import solution
    solution = pathlib.Path(f"./rozwiazania/{task}.py").absolute()
    if(not os.path.exists(solution)):
        print(f"Solution file {solution} not found")
        exit(2)

    # Create start command
    from conf import config
    command = config['command'].replace('[FILE]', f'"{solution}"')

    # Run solution
    startTime = time.time()
    process = subprocess.Popen(command, stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)

    process.stdin.write(files['in'])


    # Get memory usage
    pid = process.pid
    subprocess_process = psutil.Process(pid)
    memory_used = subprocess_process.memory_info().rss
    process.stdin.close() 
    while(process.poll() is None):
        try:
            memory_used = subprocess_process.memory_info().rss
            time.sleep(0.02)
        except:
            break;
    memory_used = str(round(memory_used / 1024 / 1024)) + "MB"

    # Get output
    stdout, stderr = process.communicate()
    duration = round(time.time() - startTime, 2)
    duration = str(duration) + "s"
    # Verify output
    report = {}
    memory = Fore.LIGHTBLACK_EX + f"  (Mem: {memory_used}, Time: {duration})" + Fore.RESET
    indent = Back.LIGHTBLACK_EX + " " + Back.RESET + "  "
    if(stderr != ''):
        report['status'] = 'error'
        error = stderr.split('\n')
        for no, line in enumerate(error):
            error[no] = indent + Fore.RED + line
        error.pop()
        error = '\n'.join(error)
        report['message'] = f'Test {test} errored: {memory}\n' + Fore.RESET + error + "\n"
    elif stdout == files['out']:
        report['status'] = 'ok'
        report['message'] = f'Test {testname} passed\n'
    else:
        report['status'] = 'fail'
        received = Fore.WHITE + stdout + Fore.RED
        expected = Fore.WHITE + files["out"] + Fore.RED
        report['message'] = f'Test {testname} failed {memory}{Fore.RED} \n{indent}Received: {received}\n{indent}Expected: {expected}'

    stats[report['status']] += 1
    log(report['message'], report['status'])

log(f"Running tests:\n", 'info')

for t in selectedTests:
    doTest(t)

log(f"Tests finished:\n{Fore.GREEN + str(stats['ok'])} passed{Fore.RESET},{Fore.RED} {str(stats['fail'])} failed{Fore.RESET} and {Fore.RED}{stats['error']} errored", 'info')