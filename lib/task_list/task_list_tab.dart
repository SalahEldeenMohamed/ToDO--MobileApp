import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/auth_user_provider.dart';
import 'package:todo_app/providers/list_provider.dart';
import 'package:todo_app/task_list/task_list_item.dart';

// class TaskListTab extends StatefulWidget {
//   @override
//   State<TaskListTab> createState() => _TaskListTabState();
// }
//
// class _TaskListTabState extends State<TaskListTab> {
//   @override
//   Widget build(BuildContext context) {
//     /// read data one time only => get()
//     /// real time change => snapshots()
//
//     var listProvider = Provider.of<ListProvider>(context);
//     if (listProvider.tasksList.isEmpty) {
//       listProvider.getAllTasksFromFireStore();
//     }
//     return Column(
//       children: [
//         EasyDateTimeLine(
//           initialDate: listProvider.selectDate,
//           onDateChange: (selectedDate) {
//             //`selectedDate` the new date selected.
//             listProvider.changeSelectDate(selectedDate);
//           },
//           headerProps: const EasyHeaderProps(
//             monthPickerType: MonthPickerType.switcher,
//             dateFormatter: DateFormatter.fullDateDMY(),
//           ),
//           dayProps: const EasyDayProps(
//             dayStructure: DayStructure.dayStrDayNum,
//             activeDayStyle: DayStyle(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.all(Radius.circular(8)),
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [Color(0xff3371FF), Color(0xff8426D6)],
//                 ),
//               ),
//             ),
//           ),
//         ),
//         // Expanded(
//         //   child: ListView.builder(
//         //     itemBuilder: (context, index) {
//         //       return TaskListItem(task: listProvider.tasksList[index]);
//         //     },
//         //     itemCount: listProvider.tasksList.length,
//         //   ),
//         // ),
//         Expanded(
//           child: Consumer<ListProvider>(
//             builder: (context, listProvider, child) {
//               return ListView.builder(
//                 itemCount: listProvider.tasksList.length,
//                 itemBuilder: (context, index) {
//                   return TaskListItem(
//                     task: listProvider.tasksList[index],
//                   );
//                 },
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }

class TaskListTab extends StatefulWidget {
  @override
  State<TaskListTab> createState() => _TaskListTabState();
}
class _TaskListTabState extends State<TaskListTab> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthUserProvider>(
          context, listen: false);

      Provider.of<ListProvider>(
        context,
        listen: false,
      ).getAllTasksFromFireStore(authProvider.currentUser!.id!);
    });
  }

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthUserProvider>(context);
    return Column(
      children: [
        Consumer<ListProvider>(
          builder: (context, listProvider, _) {
            return EasyDateTimeLine(
              initialDate: listProvider.selectDate,
              onDateChange: (selectedDate) {
                listProvider.changeSelectDate(
                    selectedDate, authProvider.currentUser!.id!);
              },
              headerProps: const EasyHeaderProps(
                monthPickerType: MonthPickerType.switcher,
                dateFormatter: DateFormatter.fullDateDMY(),
              ),
              dayProps: const EasyDayProps(
                dayStructure: DayStructure.dayStrDayNum,
                activeDayStyle: DayStyle(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xff3371FF), Color(0xff8426D6)],
                    ),
                  ),
                ),
              ),
            );
          },
        ),

        Expanded(
          child: Consumer<ListProvider>(
            builder: (context, listProvider, _) {
              return ListView.builder(
                itemCount: listProvider.tasksList.length,
                itemBuilder: (context, index) {
                  return TaskListItem(
                    task: listProvider.tasksList[index],
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

