#include <stdio.h>
#include <unistd.h>
#include <signal.h>

int n = 0;
void signal_handler(int sig){
    n++;
    n%2==0?printf("Père: %d ", n):printf("Fils: %d ", n);
    fflush(stdout);
}

int main(void){
    pid_t fils = fork();

    if (signal(SIGUSR1,signal_handler) == SIG_ERR){
        perror("signal()\n");
        return 1;
    }

    if (fils == -1){
            perror("fork()\n");
            return 1;
    }
    else if (fils == 0){ // Processus fils
        for (int i = 1; i <= 99; i += 2){
            n = i;
            kill(getppid(), SIGUSR1); // Le processus fils envoie un signal au processus pére pour afficher n...
            pause();  // ... puis attendre le signal provenant du processus père
        }
    }
    else { // Processus père
        for (int i = 2; i <= 100        ; i += 2){
            pause(); // Attendre le signal provenant du processus fils...
            n = i;
            kill(fils, SIGUSR1); // ... puis le processus père envoie un signal au processus fils pour afficher n+1...
        }
    }
    
    return 0 ;
   
}

/*
<blackbird_0> hi, guys
<blackbird_0> I have a problem with signals
<blackbird_0> I'm trying to display this output: Fils: 1 Père:2 Fils: 3 Père: 4 .... Fils: 99 Père: 100
<blackbird_0> My code works fine, if I display line after line: https://ideone.com/PXg8Hm
<blackbird_0> But if I delete the carriage return in line 8, the output will be: Fils: 1 Fils: 3 Fils: 5 ... Fils: 99 Père: 2 Père 4 ... Père: 100
<blackbird_0> Please help
*/