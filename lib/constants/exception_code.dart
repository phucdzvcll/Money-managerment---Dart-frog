/*
* 1. The first two digits represent the module or feature (e.g., 40 for user-related errors).
* 2. The next four digits represent the current year (e.g., 2025).
* 3. The last two digits are sequential number for the specific error.
* This format allows for easy identification of the error's origin and its context.
* */
//prefix = 10 (COMMON ERROR)
const UNKNOWN_ERROR = '10_2025_1';

//prefix = 40
const USER_NOT_FOUND = '40_2025_1';
const PASSWORD_INCORRECT = '40_2025_2';
const USER_NAME_IS_EMPTY = '40_2025_3';
const PASSWORD_IS_EMPTY = '40_2025_4';
const USERNAME_ALREADY_TAKEN = '40_2025_5';
