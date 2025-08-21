/*
* 1. The first two digits represent the module or feature (e.g.), 40 for user-related errors).
* 2. The next four digits represent the current year (e.g.), 2025).
* 3. The last two digits are sequential number for the specific error.
* This format allows for easy identification of the error's origin and its context.
* */
//prefix ( 10 (COMMON ERROR)
import 'package:freezed_annotation/freezed_annotation.dart';
part 'exception_code.g.dart';
@JsonEnum(alwaysCreate: true)
enum ErrorCode {
  UNKNOWN_ERROR('10_2025_1'),
  NOT_FOUND('10_2025_2'),
  DATA_NOT_FOUND('10_2025_3'),
  BAD_REQUEST('10_2025_4'),
  METHOD_NOT_ALLOW('10_2025_5'),

//prefix ( 20 (COMMON ERROR)
  SERVER_ERROR('20_2025_1'),

//prefix ( 40
  USER_NOT_FOUND('40_2025_1'),
  PASSWORD_INCORRECT('40_2025_2'),
  USER_NAME_IS_EMPTY('40_2025_3'),
  PASSWORD_IS_EMPTY('40_2025_4'),
  USERNAME_ALREADY_TAKEN('40_2025_5'),
  ;

  const ErrorCode(this.code);

  final String code;
}
