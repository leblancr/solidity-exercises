// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.13;

contract FilterOddNumbers {
    /*
        This exercise assumes you understand how to manipulate Array.
        1. Function `filterOdd` takes an array of uint256 as argument. 
        2. Filter and return an array with the odd numbers removed.
        Note: this is tricky because you cannot allocate a dynamic array in memory, 
              you need to count the even numbers then declare an array of that size.
    */



    function filterOdd(uint256[] memory _arr) public pure returns (uint256[] memory) {
        uint256 evens_count = 0;
        uint256 num_evens = 0;

        // count how many evens, use as size for evens array
        for(uint256 i; i < _arr.length; i++){
            if (_arr[i] % 2 == 0){
                num_evens++;
            }
        }

        uint256[] memory evens = new uint[](num_evens);  // creeate array to return

         // add evens to evens array
        for(uint256 i; i < _arr.length; i++){
            if (_arr[i] % 2 == 0){
                evens[evens_count] = _arr[i];
                evens_count++;
            }
        }

       return evens;
    }
}


