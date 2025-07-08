import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iba_member_app/core/data/models/Member.dart';
import 'package:iba_member_app/features/member/view/member_detail_page.dart';
import 'package:intl/intl.dart';

class MemberItemWidget extends StatelessWidget {
  const MemberItemWidget({super.key, required this.member, required this.fetchMembers});

  final Member member;
  final Function() fetchMembers;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 8.0),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2.0),
              child: CircleAvatar(
                radius: 45,
                backgroundImage: MemoryImage(base64Decode(member.photo)),
                backgroundColor: Colors.grey,
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 12.0),
                Text(
                  member.fullName,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(width: 16.0),
                Text('Data Nasc.: ${DateFormat('dd/MM/yyyy').format(member.birthdayDate)}'),
                const SizedBox(width: 16.0),
                Text('Desde ${toBeginningOfSentenceCase(DateFormat('MMMM yyyy', 'pt_BR').format(member.memberSince))}')
              ],
            ),
          ),
          const SizedBox(width: 16.0),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MemberDetailPage(member: member),
          ),
        ).then((_) {
          fetchMembers();
        });
      },
    );
  }
}
