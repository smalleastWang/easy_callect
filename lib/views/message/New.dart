import 'package:easy_collect/api/message.dart';
import 'package:easy_collect/views/message/MessageDetai.dart';
import 'package:easy_collect/widgets/List/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NewMessageWidget extends ConsumerStatefulWidget {
  const NewMessageWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NewMessageWidgetState();
}

class _NewMessageWidgetState extends ConsumerState<NewMessageWidget> {
  @override
  Widget build(BuildContext context) {
    return ListWidget(
      isCustomCard: true,
      provider: newMessagePageProvider,
      builder: (data) {
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MessageDetailPage(
                  subject: data['subject'],
                  content: data['content'],
                  createTime: data['createTime'],
                ),
              )
            );
          },
          child: Container(
            margin: const EdgeInsets.only(top: 6),
            padding: const EdgeInsets.only(top: 20, left: 14, right: 14, bottom: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(9)
            ),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0x193489FF),
                    borderRadius: BorderRadius.circular(50)
                  ),
                  child: SvgPicture.asset('assets/icon/common/optimized/message.svg', fit: BoxFit.fill),
                ),
                
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              data['subject'],
                              style: const TextStyle(overflow: TextOverflow.ellipsis, fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black)
                            ),
                          ),
                          Text(data['createTime'], style: const TextStyle(color: Color(0xFF999999), fontSize: 14))
                        ],
                      ),
                      
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        child: Text(data['content'], style: const TextStyle(overflow: TextOverflow.ellipsis, color: Color(0xFF999999), fontSize: 14)),
                      )
                      
                    ],
                  )
                )
                
              ],
            ),
          )
        );
      },
    );
  }
}