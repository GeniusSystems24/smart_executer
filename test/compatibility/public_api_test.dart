import 'package:flutter_test/flutter_test.dart';
import 'package:smart_executer/smart_executer.dart';

void main() {
  test('legacy static method tear-offs remain available', () {
    final execute = SmartExecuter.execute<int>;
    final run = SmartExecuter.run<int>;
    final background = SmartExecuter.inBackground<int>;
    final runStream = SmartExecuter.runStream<int>;
    final backgroundStream = SmartExecuter.inBackgroundStream<int>;

    expect(execute, isNotNull);
    expect(run, isNotNull);
    expect(background, isNotNull);
    expect(runStream, isNotNull);
    expect(backgroundStream, isNotNull);
  });

  test('configuration and model constructors remain available', () {
    const options = ExecuterOptions(
      showLoadingDialog: false,
      operationName: 'compatibility',
    );
    const metadata = ExceptionMetadata(operationName: 'compatibility');
    const exception = ConnectionException(
      'offline',
      null,
      null,
      metadata,
    );

    expect(options.showLoadingDialog, isFalse);
    expect(exception.exceptionType, SmartExceptionType.connection);
    expect(exception.toFailure<int>(), const Failure<int>(exception));
  });
}
