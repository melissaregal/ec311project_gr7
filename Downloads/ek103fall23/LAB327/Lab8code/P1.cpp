//include headers and libraries

#include <iostream>
#include <string>
#include "Library.h"

using namespace std;

int main(){
    Library library;
    
    string command;

    //ask for commands and execute
    while(true){
        cout<<"Enter command: ";
        cin>>command;
        
        if(command == "p"){
            library.print();
        }
        else if (command=="q"){
            cout<<"Exiting"<<endl; 
            break;  
        }
    }   
    return 0;
}





