library loggerui;

import 'dart:html';
import 'package:web_ui/web_ui.dart';
import 'package:web_ui/watcher.dart' as watcher;
import 'package:logging/logging.dart';
import 'package:logging_handlers/logging_handlers_shared.dart';

class LoggerUi extends WebComponent implements BaseLoggingHandler {
  List<LogRecord> logRecords = new List<LogRecord>();
  
  List<String> messages = new List<String>();

  final _logger = new Logger("loggerui");
  
  LoggerUi() {
    transformer = new StringTransformer();
  }
  
  LogRecordTransformer transformer;
  
  void call(LogRecord logRecord) {
    if (logRecord.loggerName != "loggerui") _logger.finest("adding logrecord"); // don;t log our own records
    logRecords.add(logRecord);
    messages.add(transformer.transform(logRecord));
    watcher.dispatch();
    if (logRecord.loggerName != "loggerui") _logger.finest("logrecord added");
  }

  void addEventListener(String type, listener(Event event), [bool useCapture]) {
    super.addEventListener(type, listener, useCapture);
  }

  Document get ownerDocument => super.ownerDocument;

  Element querySelector(String selectors) {
    return super.querySelector(selectors);
  }

  ElementList querySelectorAll(String selectors) {
    return super.querySelectorAll(selectors);
  }

  void removeEventListener(String type, listener(Event event), [bool useCapture]) {
    super.removeEventListener(type, listener, useCapture);
  }
}