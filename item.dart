import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart' as actions;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'test_model.dart';
export 'test_model.dart';

class TestWidget extends StatefulWidget {
  const TestWidget({Key? key}) : super(key: key);

  @override
  _TestWidgetState createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  late TestModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TestModel());

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'test'});
    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      logFirebaseEvent('TEST_PAGE_test_ON_INIT_STATE');
      logFirebaseEvent('test_firestore_query');
      _model.contacQuwery = await queryContactsRecordOnce(
        singleRecord: true,
      ).then((s) => s.firstOrNull);
      logFirebaseEvent('test_custom_action');
      _model.allContacts = await actions.unSpaghett(
        _model.contacQuwery!.all,
      );
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(_model.unfocusNode),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: Builder(
            builder: (context) {
              final contacts = _model.allContacts!.toList();
              return ListView.builder(
                padding: EdgeInsets.zero,
                scrollDirection: Axis.vertical,
                itemCount: contacts.length,
                itemBuilder: (context, contactsIndex) {
                  final contactsItem = contacts[contactsIndex];
                  return Text(
                    getJsonField(
                      contactsItem,
                      r'''$.Name''',
                    ).toString(),
                    style: FlutterFlowTheme.of(context).bodyMedium,
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
