import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_widgets/flutter_widgets.dart';
import 'package:line_up_tracker/model/candidate.dart';
import 'package:line_up_tracker/observer/generalized_observer.dart';
import 'package:line_up_tracker/screens/screen_tracker.dart';

class Profile extends StatefulWidget {
  String id;
  String name;
  String email;
  String mobno;
  String mobno1;
  String mobno2;
  String gender;
  String skill;
  String currentCompany;
  String noticePeriod;
  String ticket;

  Profile({
    Key key,
    this.id,
    this.name,
    this.email,
    this.mobno,
    this.mobno1,
    this.mobno2,
    this.gender,
    this.skill,
    this.currentCompany,
    this.noticePeriod,
    this.ticket,
  }) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool _loading;
  CandidateItem candidateItem;
  GlobalKey<FormState> _key = new GlobalKey();
  bool _autoValidate = false;
  TextEditingController _nameController,
      _emailController,
      _mobnoController,
      _mobno1Controller,
      _mobno2Controller,
      _genderController,
      _currentCompanyController,
      _noticePeriodController,
      _ticketController,
      _skillsController;

  getCandidateDetails() async {
    _loading = false;
    candidateItem = new CandidateItem();
    candidateItem.isActive = true;
    if (widget.name != null) {
      candidateItem.name = widget.name;
      candidateItem.email = widget.email;
      candidateItem.mobno = widget.mobno;
      candidateItem.mobno1 = widget.mobno1;
      candidateItem.mobno2 = widget.mobno2;
      candidateItem.gender = widget.gender;
      candidateItem.skill = widget.skill;
      candidateItem.currentCompany = widget.currentCompany;
      candidateItem.noticePeriod = widget.noticePeriod;
      candidateItem.ticket = widget.ticket;
    }
  }

  @override
  void initState() {
    super.initState();
    getCandidateDetails();
    _nameController =
        TextEditingController(text: widget.name != null ? widget.name : "");
    _emailController =
        TextEditingController(text: widget.email != null ? widget.email : "");
    _mobnoController =
        TextEditingController(text: widget.mobno != null ? widget.mobno : "");
    _mobno1Controller =
        TextEditingController(text: widget.mobno1 != null ? widget.mobno1 : "");
    _mobno2Controller =
        TextEditingController(text: widget.mobno2 != null ? widget.mobno2 : "");
    _genderController =
        TextEditingController(text: widget.gender != null ? widget.gender : "");
    _currentCompanyController = TextEditingController(
        text: widget.currentCompany != null ? widget.currentCompany : "");
    _noticePeriodController = TextEditingController(
        text: widget.noticePeriod != null ? widget.noticePeriod : "");
    _ticketController = TextEditingController(
        text: widget.ticket != null ? widget.ticket : "");
    _skillsController =
        TextEditingController(text: widget.skill != null ? widget.skill : "");
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
        key: Key(Screen.ADD_PROFILE.toString()),
        onVisibilityChanged: (VisibilityInfo info) {
          ScreenTracker.getInstance().onScreen(Screen.ADD_PROFILE, info);
        },
        child: Scaffold(
          appBar: AppBar(
        elevation: 0.0,
        title: Text(widget.name != null ? "Edit profile" : "Add Profile"),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: _loading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).accentColor),
              ),
            )
          : Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
              child: Form(
                autovalidate: _autoValidate,
                key: _key,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 3.0,
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            autofocus: true,
                            keyboardType: TextInputType.text,
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: "Name",
                              labelStyle: TextStyle(color: Colors.grey),
                            ),
                            validator: (input) {
                              if (input.isEmpty) {
                                return "Please enter valid name.";
                              }
                            },
                            onSaved: (input) =>
                                candidateItem.name = input.trim(),
                          ),

                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: "Email",
                              hintText: 'eg. abc@xyz.com',
                              labelStyle: TextStyle(color: Colors.grey),
                            ),
                            validator: _validateEmail,
                            onSaved: (input) =>
                                candidateItem.email = input.trim(),
                          ),

                          TextFormField(
                            controller: _mobnoController,
                            keyboardType: TextInputType.numberWithOptions(),
                            decoration: InputDecoration(
                              labelText: "Mob-No",
                              hintText: 'eg. 1234567890',
                              labelStyle: TextStyle(color: Colors.grey),
                            ),
                            validator: _validateMobile,
                            onSaved: (input) =>
                                candidateItem.mobno = input.trim(),
                          ),

                          TextFormField(
                            controller: _mobno1Controller,
                            keyboardType: TextInputType.numberWithOptions(),
                            decoration: InputDecoration(
                              labelText: 'Phone-No',
                              hintText: 'eg. 1234567890',
                              labelStyle: TextStyle(color: Colors.grey),
                            ),
                            validator: (input) {},
                            //ToDO need to write validator logic
                            onSaved: (input) =>
                                candidateItem.mobno1 = input.trim(),
                          ),

                          TextFormField(
                            controller: _mobno2Controller,
                            keyboardType: TextInputType.numberWithOptions(),
                            decoration: InputDecoration(
                              labelText: 'Mob-No1',
                              hintText: 'eg. 1234567890',
                              labelStyle: TextStyle(color: Colors.grey),
                            ),
                            validator: (input) {},
                            //ToDO need to write validator logic
                            onSaved: (input) =>
                                candidateItem.mobno2 = input.trim(),
                          ),

                          TextFormField(
                            controller: _genderController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              labelText: 'Gender',
                              hintText: 'eg. Male/Female',
                              labelStyle: TextStyle(color: Colors.grey),
                            ),
                            validator: (input) {},
                            //ToDO need to write validator logic
                            onSaved: (input) =>
                                candidateItem.gender = input.trim(),
                          ),

                          TextFormField(
                            controller: _skillsController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              labelText: 'Skill',
                              hintText: 'eg. Android / iOS / Java',
                              labelStyle: TextStyle(color: Colors.grey),
                            ),
                            validator: (input) {
                              if (input.isEmpty) {
                                return "Please enter skill";
                              }
                            },
                            //ToDO need to write validator logic
                            onSaved: (input) =>
                                candidateItem.skill = input.trim(),
                          ),

                          TextFormField(
                            controller: _currentCompanyController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              labelText: 'Current Company',
                              hintText: 'eg. Amazon..',
                              labelStyle: TextStyle(color: Colors.grey),
                            ),
                            validator: (input) {},
                            //ToDO need to write validator logic
                            onSaved: (input) =>
                                candidateItem.currentCompany = input.trim(),
                          ),

                          TextFormField(
                            controller: _noticePeriodController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              labelText: 'Notice Period',
                              hintText: 'eg. 60 days/2 Months',
                              labelStyle: TextStyle(color: Colors.grey),
                            ),
                            validator: (input) {},
                            //ToDO need to write validator logic
                            onSaved: (input) =>
                                candidateItem.noticePeriod = input.trim(),
                          ),

                          TextFormField(
                            controller: _ticketController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              labelText: 'Ticket',
                              hintText: 'Ticket number',
                              labelStyle: TextStyle(color: Colors.grey),
                            ),
                            validator: (input) {
                              return null;
                            },
                            onSaved: (input) =>
                            candidateItem.ticket = input.trim(),
                          ),

                          RaisedButton(
                            child: Text("Done"),
                            color: Theme.of(context).accentColor,
                            textColor: Colors.white,
                            elevation: 3.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0)),
                            onPressed: () {
                              _validateForm();
                            },
                          ),
//
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    )
    );
  }

  void _validateForm() {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      StateProvider _stateProvider = StateProvider();
      _stateProvider.notify(ObserverState.DATA_UPDATED);
      Navigator.of(context).pop(candidateItem);
    } else {
      if (mounted) {
        setState(() {
          _autoValidate = true;
        });
      }
    }
  }

  String _validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  String _validateMobile(String value) {
// Indian Mobile number are of 10 digit only
    if (value.length != 10)
      return 'Mobile Number must be of 10 digit';
    else
      return null;
  }
}
