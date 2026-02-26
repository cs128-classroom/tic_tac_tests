#include <fcntl.h>
#include <string.h>
#include <sys/wait.h>
#include <unistd.h>

#include <algorithm>
#include <iostream>
#include <set>
#include <string>
#include <vector>

bool RunCommand(char** command, int fd);
int main() {
  std::set<std::string> correct_implementations = {"test7"};
  std::set<std::string> incorrect_implementations = {
      "test1", "test2", "test3", "test4", "test5", "test6"};
  std::set<std::string> implementations;
  implementations.insert(correct_implementations.begin(),
                         correct_implementations.end());
  implementations.insert(incorrect_implementations.begin(),
                         incorrect_implementations.end());
  char make[] = {'m', 'a', 'k', 'e', '\0'};
  for (const auto& target : implementations) {
    char t[64];
    unsigned int i = 0;
    for (char c : target) {
      t[i++] = c;
    }
    t[i] = '\0';
    char* compile_command[] = {make, t, nullptr};
    bool does_compile = RunCommand(compile_command, -1);
    if (!does_compile) {
      return 1;
    }
  }
  int correctly_classified_correct_implementations = 0;
  int correctly_classified_incorrect_implementations = 0;
  char exec[64];
  memcpy(exec, "./bin/", 6);
  char file[64];
  memcpy(file, "./tests_output/", 15);
  for (const std::string& target : implementations) {
    unsigned int i = 6;
    unsigned int j = 15;
    for (char c : target) {
      exec[i++] = c;
      file[j++] = c;
    }
    exec[i] = '\0';
    file[j] = '.';
    file[j + 1] = 't';
    file[j + 2] = 'x';
    file[j + 3] = 't';
    file[j + 4] = '\0';
    char* execute_command[] = {exec, nullptr};
    int filedes = open(file, O_CREAT | O_TRUNC | O_WRONLY, S_IRUSR | S_IWUSR);
    bool passed = RunCommand(execute_command, filedes);
    if (passed && correct_implementations.contains(target)) {
      correctly_classified_correct_implementations++;
    } else if (!passed && incorrect_implementations.contains(target)) {
      correctly_classified_incorrect_implementations++;
    }
    close(filedes);
  }
  std::cout << "Correctly classified "
            << correctly_classified_correct_implementations << "/"
            << correct_implementations.size() << " correct implementaions."
            << std::endl;
  std::cout << "Correctly classified "
            << correctly_classified_incorrect_implementations << "/"
            << incorrect_implementations.size() << " incorrect implementaions."
            << std::endl;
}
// if filedescriptor is -1 print to stdout otherwise write to file
// returns if the command runs sucessfully with successful exit status
bool RunCommand(char** command, int fd) {
  fflush(stdout);
  pid_t pid = fork();
  if (pid < 0) {
    return false;
  }
  if (pid > 0) {
    int status = 0;
    pid_t a = waitpid(pid, &status, 0);
    if (a == -1) {
      return false;
    }
    return WIFEXITED(status) != 0 && WEXITSTATUS(status) == 0;
  }
  // child
  if (fd != -1) {
    dup2(fd, 1);
    close(fd);
  }
  execvp(command[0], command);
  _exit(1);
}
