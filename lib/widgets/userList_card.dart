import 'package:alumniapp/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:alumniapp/utils/global_variable.dart';

class UserListCard extends StatefulWidget {
  final snap;
  const UserListCard({
    Key? key,
    required this.snap,
    // required this.userData,
  }) : super(key: key);

  @override
  State<UserListCard> createState() => _UserListCardState();

}

class _UserListCardState extends State<UserListCard> {


  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
      //   // Navigate to profile screen and pass user data
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => ProfileScreen( uid:    ['uid']),
      //     ),
      //   );
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: width > webScreenSize ? Colors.blueGrey : Colors.white,
          ),
          color: Colors.white,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 10,
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 12,
              ).copyWith(right: 0),
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: width > webScreenSize ? Colors.blueGrey : Colors.black,
                    ),
                    borderRadius: BorderRadius.circular(112), // Add border radius for rounded corners
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 9.0),
                    child: Row(
                      children: <Widget>[
                        CircleAvatar(
                          radius: 48,
                          backgroundImage: NetworkImage(
                            widget.snap['photoUrl'].toString(),
                          ),
                        ),
                        SizedBox(
                          width: 50,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 8,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  widget.snap['username'].toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:alumniapp/utils/global_variable.dart';
// import 'package:your_app_name/profile_screen.dart'; // Import your profile screen
//
// class UserListCard extends StatelessWidget {
//   final Map<String, dynamic> userData;
//
//   const UserListCard({
//     Key? key,
//     required this.userData,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//
//     return GestureDetector(
//       onTap: () {
//         // Navigate to profile screen and pass user data
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => ProfileScreen(username: userData['username']),
//           ),
//         );
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           border: Border.all(
//             color: width > webScreenSize ? Colors.blueGrey : Colors.white,
//           ),
//           color: Colors.white,
//         ),
//         padding: const EdgeInsets.symmetric(
//           vertical: 10,
//         ),
//         child: Column(
//           children: [
//             Container(
//               padding: const EdgeInsets.symmetric(
//                 vertical: 8,
//                 horizontal: 12,
//               ).copyWith(right: 0),
//               child: Padding(
//                 padding: const EdgeInsets.only(right: 10.0),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     border: Border.all(
//                       color: width > webScreenSize ? Colors.blueGrey : Colors.black,
//                     ),
//                     borderRadius: BorderRadius.circular(112), // Add border radius for rounded corners
//                   ),
//                   padding: const EdgeInsets.symmetric(
//                     vertical: 10,
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.only(left: 9.0),
//                     child: Row(
//                       children: <Widget>[
//                         CircleAvatar(
//                           radius: 48,
//                           backgroundImage: NetworkImage(
//                             userData['photoUrl'].toString(),
//                           ),
//                         ),
//                         SizedBox(
//                           width: 50,
//                         ),
//                         Expanded(
//                           child: Padding(
//                             padding: const EdgeInsets.only(
//                               left: 8,
//                             ),
//                             child: Column(
//                               mainAxisSize: MainAxisSize.min,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: <Widget>[
//                                 Text(
//                                   userData['username'].toString(),
//                                   style: const TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.black,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
