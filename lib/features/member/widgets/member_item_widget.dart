import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iba_member_app/core/data/models/Member.dart';
import 'package:iba_member_app/features/member/view/member_detail_page.dart';
import 'package:intl/intl.dart';

class MemberItemWidget extends StatelessWidget {
  const MemberItemWidget(
      {super.key, required this.member, required this.fetchMembers});

  final Member member;
  final Function() fetchMembers;

  @override
  Widget build(BuildContext context) {
    ImageProvider backgroundImage;
    try {
      if (member.photo.isNotEmpty) {
        backgroundImage = MemoryImage(base64Decode(member.photo));
      } else {
        backgroundImage = const AssetImage('lib/assets/logo.jpg');
      }
    } catch (e) {
      backgroundImage = const AssetImage('lib/assets/logo.jpg');
    }

    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.yellow.shade700, width: 1.0),
        borderRadius: BorderRadius.circular(12.0),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
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
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: backgroundImage,
                backgroundColor: Colors.grey[800],
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AutoSizeText(
                      member.fullName,
                      style: GoogleFonts.lato(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      minFontSize: 14,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      children: [
                        Icon(Icons.cake_outlined,
                            size: 16.0, color: Colors.grey[400]),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: AutoSizeText(
                            DateFormat('dd/MM/yyyy')
                                .format(member.birthdayDate),
                            style: GoogleFonts.roboto(
                              fontSize: 14,
                              color: Colors.grey[300],
                            ),
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4.0),
                    Row(
                      children: [
                        Icon(Icons.calendar_today_outlined,
                            size: 14.0, color: Colors.grey[400]),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: AutoSizeText(
                            'Desde ${toBeginningOfSentenceCase(DateFormat('MMMM yyyy', 'pt_BR').format(member.memberSince))}',
                            style: GoogleFonts.roboto(
                              fontSize: 14,
                              color: Colors.grey[300],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
