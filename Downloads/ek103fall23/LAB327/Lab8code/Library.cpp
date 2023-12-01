//include headers and libraries
#include "Library.h"
#include <iostream>
#include <string>

using namespace std;

Library::Library(){
    //Constructor

    for(int i = 0; i < 10; i++){
        books[i]= "";
    }
}

bool Library::addBook(string bookName){

    for(int i = 0; i < 10; i++){
        if (books[i] == bookName){
            return false;
            //book exists
        }
    }

    for (int i = 0; i < 10; i++){
        if (books[i]==""){
            books[i] = bookName;
            return true;
        }
    }

    return false; // already full
}

bool Library::removeBook(string bookName){
    for (int i = 0; i < 10; i++){
        if(books[i] == bookName){
            books[i]= "";
            return true;
        }
    }
    return false; // doesnt exist 
}

void Library::print(){
    for(int i = 0; i < 10; i++){
        if( books[i] == ""){ //if not empty it willl print out books
            cout<<books[i]<<endl;
        }
    }
}

bool Library::addBook(string bookName){

    for(int i = 0; i < 10; i++){
        if (books[i] == bookName){
            return false;
            //book exists
        }
    }

    for (int i = 0; i < 10; i++){
        if (books[i]==""){
            books[i] = bookName;
            return true;
        }
    }

    return false; // already full
}

bool Library::removeBook(string bookName){
    for (int i = 0; i < 10; i++){
        if(books[i] == bookName){
            books[i]= "";
            return true;
        }
    }
    return false; // doesnt exist 
}

void Library::print(){
    for(int i = 0; i < 10; i++){
        if( books[i] == ""){ //if not empty it willl print out books
            cout<<books[i]<<endl;
        }
    }
}