import 'dart:io';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart';
import 'package:flutter/material.dart';
import 'package:get_ip/get_ip.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  String ip = "unknown";
  WebSocketChannel webSocketChannel;
  ServerSocket serverSocket;
  Socket clientSocket;

  getIp() async {
    String myIp = await GetIp.ipAddress;
    ip = myIp;
    print("-----------------ip found ----------------------");
    print("");
    print(ip);
    print("\n\n\n\n\n");
    serverSocket = await ServerSocket.bind("0.0.0.0", 8080);
    serverSocket.listen(handleClinet);
  }

  void handleClinet(Socket socket) {
    clientSocket = socket;
    print("new client connected");
    print("\n\n\n\n");
  }

  @override
  Widget build(BuildContext context) {
    getIp();
    double touchPadWidth = 410;
    double touchPadHeight = 870;
    double scaleY = 1366.0 / touchPadHeight;
    double scaleX = 768.0 / touchPadWidth;
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        accentColor: Color(0xFF000000),
        primaryColor: Color(0xFF000000),
      ),
      home: Scaffold(
        body: Listener(
          onPointerDown: (PointerDownEvent event) {
            double x = event.position.dx;
            double y = touchPadHeight - event.position.dy;

            x = x * scaleX;
            y = y * scaleY;
            print("x = " + x.toString());
            print("y = " + y.toString());
            if (clientSocket != null) {
              clientSocket.write("(" + y.toString() + "," + x.toString() + ")");
            }
          },
          onPointerMove: (PointerMoveEvent event) {
            double x = event.position.dx;
            double y = touchPadHeight - event.position.dy;

            x = x * scaleX;
            y = y * scaleY;
            print("x = " + x.toString());
            print("y = " + y.toString());
            if (clientSocket != null) {
              clientSocket.write("(" + y.toString() + "," + x.toString() + ")");
            }
          },
          child: Container(
            width: touchPadWidth,
            height: touchPadHeight,
            color: Color(0xFF000000),
          ),
        ),
      ),
    );
  }
}
