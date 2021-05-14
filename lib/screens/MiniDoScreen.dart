import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:Minido/helpers/DatabaseHelper.dart';
import 'package:Minido/models/TaskModel.dart';
import 'package:Minido/screens/AddTaskScreen.dart';
import 'package:provider/provider.dart';
import 'package:Minido/helpers/ThemeHelper.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:Minido/helpers/AdHelper.dart';

class MiniDoScreen extends StatefulWidget {
  @override
  _MiniDoScreenState createState() => _MiniDoScreenState();
}

class _MiniDoScreenState extends State<MiniDoScreen> {

  BannerAd _bad;
  InterstitialAd _iad;
  bool isLoaded;

  @override void initState() {
    super.initState();
    _updateTaskList();

    _bad = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: AdListener(
        onAdLoaded: (_) {
          setState(() {
            isLoaded = true;
          });
        },
        onAdFailedToLoad: (_, error) {
          print('Ad failed to load with Error: $error');
        }
      ),
    );

    _bad.load();


    _iad = InterstitialAd(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: AdRequest(),
      listener: AdListener(
        onAdClosed: (ad) {
          print("Closed Ad");
        },
        onAdOpened: (ad) {
          print("Opened Ad");
        },
      ),
    );

    _iad.load();
  }

  @override
  void dispose() {
    _bad?.dispose();
    _iad?.dispose();
    super.dispose();
  }

  Widget checkForAd() {
    if (isLoaded == true) {
      return Container(
        child: AdWidget(
          ad: _bad,
        ),
        width: _bad.size.width.toDouble(),
        height: _bad.size.height.toDouble(),
        alignment: Alignment.center,
      );
    } else {
      return CircularProgressIndicator();
    }
  }

  Color pri;

  Future<List<Task>> _taskList;
  final DateFormat _dateFormatter = DateFormat('MMM dd, yyyy');

  _updateTaskList(){
    setState(() {
      _taskList = DatabaseHelper.instance.getTaskList();
    });
  }

  Widget _buildTask(Task task){
    if(task.priority == 'High'){
      pri = Colors.redAccent;
    }
    else if(task.priority == 'Medium'){
      pri = Colors.yellowAccent;
    }
    else if(task.priority == 'Low'){
      pri = Colors.greenAccent;
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        children: [
          ListTile(
            title: Text(task.title, style: TextStyle(fontSize: 18.0, decoration: task.status == 0 ? TextDecoration.none : TextDecoration.lineThrough)),
            subtitle: RichText(
              text: TextSpan(
                text: '${_dateFormatter.format(task.date)} |',
                style: TextStyle(color: Colors.grey,fontSize: 15.0, decoration: task.status == 0 ? TextDecoration.none : TextDecoration.lineThrough
                ),
                children: [
                  TextSpan(text: ' ${task.priority}',
                    style: TextStyle(color: pri, fontSize: 15.0, decoration: task.status == 0 ? TextDecoration.none : TextDecoration.lineThrough
                    ),
                  ),
                ]
              ),
            ),
            trailing: Checkbox(
                onChanged: (value){
                  task.status = value ? 1 : 0;
                  DatabaseHelper.instance.updateTask(task);
                  _updateTaskList();
              },
            activeColor: Theme.of(context).primaryColor,
            value: task.status == 1 ? true : false,
            ),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) =>
                AddTaskScreen(
                  UpdateTaskList: _updateTaskList,
                  task: task,
                ),
              ),
            ),
          ),
          Divider(color: Theme.of(context).primaryColor,)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AddTaskScreen(UpdateTaskList: _updateTaskList,),
          ),
        ),
      ),
      body: FutureBuilder(
        future: _taskList,
        builder: (context, snapshot){
          if(!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final int completedTaskCount = snapshot.data
              .where((Task task) => task.status == 1)
              .toList()
              .length;

        return ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 80.0),
          itemCount: 1 + snapshot.data.length,
          itemBuilder: (BuildContext context, int index){
            if(index == 0){
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                      Text("My Tasks",
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                      ),),
                        Spacer(),
                        Consumer<ThemeNotifier>(
                          builder: (context, notifier, child) =>
                           Switch(
                            value: notifier.darktheme,
                            onChanged: (boolVal) {
                              notifier.toggleTheme();
                            },
                          ),
                        )
                      ]
                    ),
                    SizedBox(height: 10,),
                    Text("$completedTaskCount of ${snapshot.data.length}",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),),
                  ],
                ),
              );
            }

            return _buildTask(snapshot.data[index-1]);
          }
        );
        },
      ),
    );
  }
}
