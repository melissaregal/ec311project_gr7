#include <iostream>
#include <string>

using namespace std;

string swapNthCase(const string & str, const int n);

//DO NOT MODIFY THE MAIN FUNCTION

int main(){
    //prompt for string
    string str;
    int n;
    cout << "Enter word: ";
    cin >> str;
    cout << "Enter N: ";
    cin >> n;
    //swap cases
    cout << "Swapped every Nth case: " << swapNthCase(str, n) << endl;

    return 0;
}

string swapNthCase(const string & str, const int n){
    //implement function here
}
