
class AccountMessage {

  late int code;
  late String message;

  AccountMessage({
    required this.code,
    required this.message
  });


  getAccountMessage(){
    return {
      code : this.code,
      message : this.message
    };
  }


}