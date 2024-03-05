import 'package:career_quest/Jobs/job_details.dart';
import 'package:career_quest/Services/global_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


class JobWidget extends StatefulWidget {

  final String jobTitle;
  final String jobDescription;
  final String jobId;
  final String uploadedby;
  final String userImage;
  final String name;
  final bool recruitment;
  final String email;
  final String location;

  const JobWidget({
    required this.jobTitle,
    required this.jobDescription,
    required this.jobId,
    required this.uploadedby,
    required this.userImage,
    required this.name,
    required this.recruitment,
    required this.email,
    required this.location,

  });

  @override
  State<JobWidget> createState() => _JobWidgetState();
}

class _JobWidgetState extends State<JobWidget> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  _deleteDialog()
  {
    User? user = _auth.currentUser;
    final _uid = user!.uid;
    showDialog(
        context: context,
        builder: (ctx)
        {
          return AlertDialog(
            actions: [
              TextButton(
                onPressed: () async{
                  try{
                    if(widget.uploadedby == _uid){
                      await FirebaseFirestore.instance.collection('jobs')
                          .doc(widget.jobId)
                          .delete();
                      await Fluttertoast.showToast(
                        msg: 'Job has been deleted',
                        toastLength: Toast.LENGTH_LONG,
                        backgroundColor: Colors.grey,
                        fontSize: 18.0,
                      );
                      Navigator.canPop(ctx) ? Navigator.pop(ctx) : null;
                    }
                    else{
                      GlobalMethod.showErrorDialog(error: 'You cannot perform this action', ctx: ctx);
                    }
                  }
                  catch (error)
                  {
                    GlobalMethod.showErrorDialog(error: 'This task cannot be deleted '+ error.toString(),  ctx: ctx);
                  }
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.delete,
                      color: Colors.red,

                    ),
                    Text(
                      'Delete',
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
    );

  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white24,
      elevation: 8,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Dismissible(
        key: ObjectKey(widget.jobId),
        background: Container(
          color: Colors.red,
          padding: EdgeInsets.only(left: 16),
          child: Align(alignment: Alignment.centerLeft, child: Icon(Icons.delete, color: Colors.white,)),
        ),
        direction: DismissDirection.startToEnd,
        confirmDismiss: (direction){
          final result =
          _deleteDialog();
          return result;
        },
        child: ListTile(
          onTap: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => JobDetailsScreen(
              uploadedBy: widget.uploadedby,
              jobID: widget.jobId,
            )));
          },
          onLongPress: (){
           // _deleteDialog();
          },
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          leading: Container(
            padding: const EdgeInsets.only(right: 12),
            decoration: const BoxDecoration(
              border: Border(
                right: BorderSide(width: 1),
              ),
            ),
            child: Image.network(widget.userImage),

          ),
          title: Text(
            widget.jobTitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.amber,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                widget.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 8,),
              Text(
                widget.jobDescription,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          trailing: const Icon(
            Icons.keyboard_arrow_right,
            size: 30,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
