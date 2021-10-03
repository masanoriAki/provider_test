import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_test/test.dart';
import 'package:simple_logger/simple_logger.dart';

final logger = SimpleLogger();

void main() {
  logger.setLevel(
    Level.ALL,
    includeCallerInfo: true,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // 自分より下のWidgetに、Testってプロバイダ作ったよって伝えてあげる
        // だから、
        // final _model = Provider.of<Test>(context, listen: false);
        // って宣言した時は、俺の持ってるTestプロバイダを見ろ！って事になる
        ChangeNotifierProvider<Test>(create: (context) => Test())
      ],
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text("テストだよ"),
          ),
          body: FirstPage(),
        ),
      ),
    );
  }
}

class FirstPage extends StatelessWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _model = Provider.of<Test>(context, listen: false);

    // TestっていうProviderで作ったクラスのnameの値が変わったら、Widgetをリビルドしてね
    context.select((Test model) => model.name);

    logger.info("FirstPage リビルド");

    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_model.name),
          ElevatedButton(
              onPressed: () {
                logger.info("おした");
                _model.addName(_model.name == "" ? "あきた" : "");
              },
              child: Text("名前変更")),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SecondPage(),
                    ));
              },
              child: Text("セカンドページ遷移")),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ThirdPage(),
                    ));
              },
              child: Text("サードページ遷移")),
        ],
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  const SecondPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // すでにMaterialAppでTestクラスのProvider生成してるのに、
    // その後で同じclassのProvider生成すると、同じクラスだけど全く別のインスタンスが生成されてしまう
    //  　つまり、Providerで一つのクラスを共通化したいなら、createは一回だけで良い！
    return ChangeNotifierProvider<Test>(
      create: (context) => Test(),
      child: Scaffold(
        appBar: AppBar(title: Text("2号チェック")),
        body: Center(
          child: SecondChildPage(),
        ),
      ),
    );
  }
}

class SecondChildPage extends StatelessWidget {
  const SecondChildPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _model = Provider.of<Test>(context, listen: false);
    context.select((Test model) => model.name);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(_model.name),
        ElevatedButton(
            onPressed: () {
              logger.info("おした");
              _model.addName(_model.name == "" ? "さげんた" : "");
            },
            child: Text("名前変更")),
        ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("ページ遷移")),
      ],
    );
  }
}

class ThirdPage extends StatelessWidget {
  const ThirdPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("3号チェック")),
      body: Center(
        child: ThirdChildPage(),
      ),
    );
  }
}

class ThirdChildPage extends StatelessWidget {
  const ThirdChildPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _model = Provider.of<Test>(context, listen: false);
    context.select((Test model) => model.name);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(_model.name),
        ElevatedButton(
            onPressed: () {
              logger.info("おした");
              _model.addName(_model.name == "" ? "さげんた" : "");
            },
            child: Text("名前変更")),
        ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("ページ遷移")),
      ],
    );
  }
}
