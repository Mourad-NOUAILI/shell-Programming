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
