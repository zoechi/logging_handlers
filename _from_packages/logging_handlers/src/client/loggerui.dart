// Auto-generated from loggerui.html.
// DO NOT EDIT.

library loggerui;

import 'dart:html' as autogenerated;
import 'dart:svg' as autogenerated_svg;
import 'package:web_ui/web_ui.dart' as autogenerated;
import 'package:web_ui/observe/observable.dart' as __observe;
import 'dart:html';
import 'package:web_ui/web_ui.dart';
import 'package:web_ui/watcher.dart' as watcher;
import 'package:logging/logging.dart';
import 'package:logging_handlers/logging_handlers_shared.dart';



class LoggerUi extends WebComponent implements BaseLoggingHandler {
  /** Autogenerated from the template. */

  /** CSS class constants. */
  static Map<String, String> _css = {};

  /**
   * Shadow root for this component. We use 'var' to allow simulating shadow DOM
   * on browsers that don't support this feature.
   */
  var _root;
  static final __html1 = new autogenerated.Element.html('<pre class="loggerline"></pre>'), __shadowTemplate = new autogenerated.DocumentFragment.html('''
         <style>
           #loggerbox {
             width:90%; 
             height:100px; 
             border:1px solid blue;
             overflow:auto;
           }
           .loggerline {
             margin:0px;
             padding:0px;
           }
         </style>
         <div id="loggerbox">
             <template></template>
         </div>
      ''');
  autogenerated.Element __e3;
  autogenerated.Template __t;

  void created_autogenerated() {
    _root = createShadowRoot();
    __t = new autogenerated.Template(_root);
    _root.nodes.add(__shadowTemplate.clone(true));
    __e3 = _root.nodes[3].nodes[1];
    __t.loop(__e3, () => messages, ($list, $index, __t) {
      var message = $list[$index];
      var __e2;
      __e2 = __html1.clone(true);
      var __binding1 = __t.contentBind(() =>  message , false);
      __e2.nodes.add(__binding1);
    __t.addAll([new autogenerated.Text('\n               '),
        __e2,
        new autogenerated.Text('\n             ')]);
    });
    __t.create();
  }

  void inserted_autogenerated() {
    __t.insert();
  }

  void removed_autogenerated() {
    __t.remove();
    __t = __e3 = null;
  }

  void composeChildren() {
    super.composeChildren();
    if (_root is! autogenerated.ShadowRoot) _root = this;
  }

  /** Original code from the component. */

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
  
}
//@ sourceMappingURL=loggerui.dart.map