
class ReportMessage {

  late int code;
  late String message;

  ReportMessage({
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