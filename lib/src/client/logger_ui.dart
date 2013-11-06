library loggerui;

import 'dart:async';

import 'package:polymer/polymer.dart';
import 'package:logging/logging.dart';
import 'package:logging_handlers/logging_handlers_shared.dart';

@CustomTag("logger-ui")
class LoggerUi extends PolymerElement implements BaseLoggingHandler {
  final _logger = new Logger("loggerui");
  
  @observable bool isSearchDisabled = false;
  @observable bool isLogEnabled = false;
  
  List<LogEntry> messages = new ObservableList<LogEntry>();
 
  List<LogRecord> logRecords = new List<LogRecord>();

  LogRecordTransformer transformer;
  
  List<LogEntry> filteredMessages = new ObservableList<LogEntry>();
  
  String _oldFilterValue;
  String _filterValue = "";
  @published String defaultFilter = r"^((?!polymer).)*$"; 
  Map<String,bool> showLogLevels = new Map<String,bool>();
  
  bool _useRegex = true;
  
//  bool _showFinest = true;
//  bool _showFiner = true;
//  bool _showFine = true;
//  bool _showConfig = true;
//  bool _showInfo = true;
//  bool _showWarning = true;
//  bool _showSevere = true;
//  bool _showShout = true;
  
  LoggerUi.created() : super.created() {
    _filterValue = defaultFilter;
    transformer = new StringTransformer(messageFormat: "%t %n\t[%p] %m", exceptionFormatSuffix: "\n%e\n%x", timestampFormat:"HH:mm:ss.SSS");
    Logger.root.onRecord.asBroadcastStream().listen((e) => call(e));
    showLogLevels["FINEST"]=true;
    showLogLevels["FINER"]=true;
    showLogLevels["FINE"]=true;
    showLogLevels["CONFIG"]=true;
    showLogLevels["INFO"]=true;
    showLogLevels["WARNING"]=true;
    showLogLevels["SEVERE"]=true;
    showLogLevels["SHOUT"]=true;
    
// only for testing purposes    
//    Timer.run(() {
//    _logger.finest("finest", transformer);
//    _logger.finer("finer");
//    _logger.fine("fine");
//    _logger.config("config");
//    _logger.info("info");
//    _logger.warning("warning");
//    _logger.severe("severe");
//    _logger.shout("shout");
//    });
  }
  
  @override
  void enteredView() {
    super.enteredView();
    
    Timer.run((){
      filteredMessages.forEach((m){
        m.show =_showMessage(m); 
      });
      
      notifyPropertyChange(#filteredMessages, null, null);
    });
  }
  
  
  void call(LogRecord logRecord) {
    if (logRecord.loggerName != "loggerui") {
      //_logger.finest("adding logrecord"); // don;t log our own records // leads to an exception - Uncaught Error: Bad state: Cannot fire new event. Controller is already firing an event
    }

    logRecords.add(logRecord);
    var m = transformer.transform(logRecord);
    var le = new LogEntry(m, logRecord);
    messages.insert(0, le);
    
    le.show = _showMessage(le);
    filteredMessages.insert(0, le);

    if (logRecord.loggerName != "loggerui") { 
      //_logger.finest("logrecord added"); // leads to an exception - Uncaught Error: Bad state: Cannot fire new event. Controller is already firing an event
    }
  }
  
  
  void filterHandler(e) {
    //_logger.finest("Target: ${e.target.id}.");
    
    switch(e.target.id) {
      case "search":
        _filterValue = e.target.value;
        
        
        // prevent updates on non-character keyups
        if(_filterValue == _oldFilterValue) {
          return;
        }
        _oldFilterValue = _filterValue;
        break;
        
      case "searchRegex":
        _useRegex = e.target.checked;
        break;
        
      case "FINEST":
      case "FINER":
      case "FINE":
      case "CONFIG":
      case "INFO":
      case "WARNING":
      case "SEVERE":
      case "SHOUT":
        showLogLevels[e.target.id] = e.target.checked;
        print(e.target.id);
        break;
        
        
      default:
//        _logger.warning("Unknown element: ${e.target.id}.");
        break;
    }
    
    Timer.run(() {
      filteredMessages.forEach((m){
        m.show =_showMessage(m); 
      });
      
      
      notifyPropertyChange(#filteredMessages, this.filteredMessages, this.filteredMessages);
    });
  }
  
  /**
   * !! dont call log in this method to prevent infinite loop
   */
  bool _showMessage(LogEntry le) {
    //bool show = true;
    
    if(isSearchDisabled) {
      return false;
    }
    
    if(_filterValue != "") {
      if(_useRegex) {
        if( !new RegExp(_filterValue).hasMatch(le.message)) {
          return false;
        }
      } else {
        if (!le.message.contains(_filterValue)) {
          return false;
        }
      }
    }
    
    if(!showLogLevels[le.logRecord.level.name]) {
      return false;
    }

    return true;
  }
}

class LogEntry extends Object with Observable {
  String message;
  LogRecord logRecord;
  @observable bool show = true;
  
  LogEntry(this.message, this.logRecord, {this.show});
}
