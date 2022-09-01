import 'dart:async';

class SignupValidators{

  final validateEmail = StreamTransformer<String, String>.fromHandlers(
      handleData: (email, sink){
        if(email.contains("@")){
          sink.add(email);
        }else{
          sink.addError("Insira um e-mail válido");
        }
      }
  );

  final validatePassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink){
        if(password.length>=8){
          sink.add(password);
        }else{
          sink.addError("Insira uma senha de no mínimo 8 caracteres");
        }
      }
  );


}