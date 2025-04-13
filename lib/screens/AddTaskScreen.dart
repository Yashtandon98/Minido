import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:Minido/helpers/DatabaseHelper.dart';
import 'package:Minido/models/TaskModel.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:Minido/helpers/AdHelper.dart';

class AddTaskScreen extends StatefulWidget {

  final Function UpdateTaskList;
  final Task? task;

  AddTaskScreen({required this.UpdateTaskList, this.task});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {

  late InterstitialAd? _interstitialAd;
  late BannerAd _bad;

  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _priority;
  DateTime _date = DateTime.now();
  TextEditingController _dateController = TextEditingController();

  final DateFormat _dateFormatter = DateFormat('MMM dd, yyyy');
  final List<String> _priorities = ['Low', 'Medium', 'High'];

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          print('Ad loaded.');
          _interstitialAd = ad;

          _interstitialAd!.setImmersiveMode(true);

          _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (InterstitialAd ad) =>
                print('Ad showed full screen content.'),
            onAdDismissedFullScreenContent: (InterstitialAd ad) {
              print('Ad dismissed.');
              ad.dispose();
            },
            onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
              print('Failed to show ad: $error');
              ad.dispose();
            },
          );

          _interstitialAd!.show();
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('InterstitialAd failed to load: $error');
        },
      ),
    );
  }

  @override
  void initState(){
    super.initState();
    // If editing an existing task, prefill the fields
    if (widget.task != null) {
      _title = widget.task!.title;
      _date = widget.task!.date;
      _priority = widget.task!.priority;
    } else {
      // Default values for a new task
      _title = '';
      _date = DateTime.now();
      _priority = '';
      _dateController.text = _dateFormatter.format(_date);
    }
  }

  @override
  void dispose(){
    _dateController.dispose();
    _interstitialAd?.dispose();
    super.dispose();
  }

  _handleDatePicker() async {
    final DateTime? date = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
    );
    if(date != _date){
      setState(() {
        _date = date!;
      });
      _dateController.text = _dateFormatter.format(_date);
    }
  }

  _delete(){
    DatabaseHelper.instance.deleteTask(widget.task!.id);
    widget.UpdateTaskList();
    Navigator.pop(context);
  }

  _submit() {
    if(_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print('$_title, $_date, $_priority');
      //Insert new task
      Task task = Task(id: widget.task!.id, title: _title, date: _date, priority: _priority, status: widget.task!.status);
      DatabaseHelper.instance.updateTask(task);
          widget.UpdateTaskList();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 80.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 30,
                    color: Theme.of(context).primaryColor,),
                ),
                SizedBox(height: 20.0,),
                Text(widget.task == null ? "Add Task" : "Update Task",
                  style: TextStyle(
                    //color: Colors.black,
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10,),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                        child: TextFormField(
                          style: TextStyle(
                            fontSize: 18.0),
                          decoration: InputDecoration(
                            labelText: 'Title',
                            labelStyle: TextStyle(fontSize: 18.0,),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          validator: (input) => input!.trim().isEmpty ? 'Please Enter a task title' : null,
                          onSaved: (input) => _title = input!,
                          initialValue: _title,
                        ),
                      ), //Title
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                        child: TextFormField(
                          readOnly: true,
                          controller: _dateController,
                          style: TextStyle(fontSize: 18.0),
                          onTap: _handleDatePicker,
                          decoration: InputDecoration(
                            labelText: 'Date',
                            labelStyle: TextStyle(fontSize: 18.0,),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                      ), //Date
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                        child: DropdownButtonFormField(
                          isDense: true,
                          icon: Icon(Icons.arrow_drop_down_circle),
                          iconSize: 22.0,
                          iconEnabledColor: Theme.of(context).primaryColor,
                          items: _priorities.map((String priority){
                            return DropdownMenuItem(
                              value: priority,
                              child: Text(priority, style: TextStyle(fontSize: 18.0),),
                            );
                          }).toList(),
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 18.0),
                          decoration: InputDecoration(
                            labelText: 'Priority',
                            labelStyle: TextStyle(fontSize: 18.0,),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          validator: (input) => _priority == null ? 'Please select a priority level' : null,
                          onChanged: (value){
                            setState(() {
                              _priority = value as String;
                            });
                          },
                          value: _priority,
                        ),
                      ), //Priority
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 20.0),
                        height: 60.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: TextButton(
                          child: Text(widget.task == null ? 'Add' : 'Update',
                            style: TextStyle(color: Colors.white, fontSize: 20.0,
                            ),
                          ),
                          onPressed: () {
                            _submit();
                            _loadInterstitialAd();
                          },
                        ),
                      ),
                      widget.task != null ? Container(
                        margin: EdgeInsets.symmetric(vertical: 20.0),
                        height: 60.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: TextButton(
                          child: Text('Delete',
                            style: TextStyle(color: Colors.white, fontSize: 20.0,
                            ),
                          ),
                          onPressed: _delete,
                        ),
                      ) : SizedBox.shrink(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
