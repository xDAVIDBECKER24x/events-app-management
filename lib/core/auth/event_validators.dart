import 'dart:async';

class EventValidators{

  final validateInfo = StreamTransformer<String, String>.fromHandlers(
      handleData: (info, sink){
        if(info.length >= 20){
          sink.add(info);
        }else{
          sink.addError("Mínimo 20 caracteres");
        }
      }
  );

  final validateName = StreamTransformer<String, String>.fromHandlers(
      handleData: (name, sink){
        if(name.length !=null){
          sink.add(name);
        }else{
          sink.addError("Não pode estar vazio");
        }
      }
  );

}