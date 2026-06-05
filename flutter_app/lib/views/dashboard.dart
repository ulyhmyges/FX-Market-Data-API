import 'package:flutter/material.dart';
import 'package:pricer_app/models/Session.dart';
import 'package:pricer_app/models/option.dart';
import 'package:pricer_app/services/option_service.dart';
import 'package:pricer_app/services/storage_service.dart';
import 'package:pricer_app/services/user_service.dart';
import 'package:pricer_app/views/option_details.dart';

class DashboardWidget extends StatefulWidget {
  const DashboardWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return DashboardWidgetState();
  }
}

class DashboardWidgetState extends State<DashboardWidget> {

  static const apiHOST = String.fromEnvironment('API_HOST', defaultValue: 'localhost');
  static const appHOST = String.fromEnvironment('APP_HOST', defaultValue: 'localhost');
  static const appPORT = String.fromEnvironment('APP_PORT', defaultValue: '80');

  final UserService _userService = UserService(baseURL: "http://$appHOST:$appPORT/$apiHOST/auth");
  final OptionService _optionService = OptionService(baseURL: 'http://$appHOST:$appPORT/$apiHOST/option');
  final _storageService = StorageService.getInstance();
  Session? _session;

  @override
  void initState(){
    super.initState();
    _loadSession();
  }

  Future<void> _loadSession() async {
    final String token = await _storageService.getToken();
    final Session session = await _userService.me(token);
    setState(() {
      _session = session;
    });
  }

  Future<Iterable<Option>> _getOptions() async {
    final String token = await _storageService.getToken();
    final Session session = await _userService.me(token);
    _session = session;
    return await _optionService.getOptions(session.user_id);
  }



  _redirecting() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Session expired. Redirecting...'))
      );
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      });
    });
    return const Center(child: Text('Session expired. Please wait...'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actionsPadding: EdgeInsetsGeometry.symmetric(horizontal: 50),
        actions: [
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.hovered)) {
                  return Colors.orange.shade200;
                }
                return null;
              }),
            ),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
            child: Row(
              spacing: 5,
              children: [Icon(Icons.home), Text('Home')],
            ),
          ),
          SizedBox(width: 10),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.hovered)) {
                  return Colors.orange.shade200;
                }
                return null;
              }),
            ),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/logout',
                (route) => false,
              );
            },
            child: Row(
              spacing: 5,
              children: [Icon(Icons.logout), Text('Logout')],
            ),
          ),
        ],
      ),
      body: Container(
        color: Colors.orange.shade200,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.person), Text(_session?.pseudo ?? 'Loading...'), SizedBox(width: 20,)],
            ),

            Expanded(
              child: FutureBuilder<Iterable<Option>>(
                  future: _getOptions(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError){
                      return _redirecting();
                    }

                    final options = snapshot.data?.toList() ?? [];
                    return ListView.builder(
                        itemCount: options.length,
                        itemBuilder: (context, index){
                          final option = options[index];
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ConstrainedBox(
                                constraints: BoxConstraints(maxWidth: 600),
                                child: Card(
                                  margin: const EdgeInsets.symmetric(vertical: 10),
                                  child: ListTile(
                                    leading: Icon(Icons.local_cafe_outlined),
                                    title: Text('Option'),
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => OptionDetailsWidget(option: option))
                                      );
                                    },
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Id: ${option.id}'),
                                        Text('Type: ${option.type}'),
                                        Text('Spot: ${option.spot}'),
                                        Text('Strike: ${option.strike}'),
                                        Text('Rate domestic: ${option.rateDomestic}'),
                                        Text('Rate foreign : ${option.rateForeign}'),
                                        Text('Volatility: ${option.volatility}'),
                                        Text('Maturity: ${option.maturity}'),
                                        Text('Day counter: ${option.dayCounter}'),
                                        Text('Price: ${option.price}')
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                    );
                  }
              ),
            )
          ],
        ),
      ),
    );
  }
}
