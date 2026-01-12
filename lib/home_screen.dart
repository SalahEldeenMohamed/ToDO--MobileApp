import 'package:flutter/material.dart';
import 'package:todo_app/app_colors.dart';
import 'package:todo_app/settings/settings_tab.dart';
import 'package:todo_app/task_list/add_task_bottom_sheet.dart';
import 'package:todo_app/task_list/task_list_tab.dart';

import 'l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'home_screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        /// toolbarHeight: MediaQuery.of(context).size.height*0.15,
        title: Text(AppLocalizations.of(context)!.title,
            style: Theme
                .of(context)
                .textTheme
                .titleLarge),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(
                  Icons.list,
                  color: selectedIndex == 0
                      ? AppColors.primaryColor
                      : Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    selectedIndex = 0;
                  });
                },
              ),
              const SizedBox(width: 40), // مساحة للـ FAB
              IconButton(
                icon: Icon(
                  Icons.settings,
                  color: selectedIndex == 1
                      ? AppColors.primaryColor
                      : Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    selectedIndex = 1;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            addTaskBottomSheet();
          },
          child: Icon(Icons.add, size: 30, color: AppColors.whiteColor),
          backgroundColor: AppColors.primaryColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(35),
              side: BorderSide(
                  color: AppColors.whiteColor,
                  width: 4
              )
          )
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Column(
        children: [
          Container(
            color: AppColors.primaryColor,
            width: double.infinity,
            height: 80,
          ),
          Expanded(child: tabs[selectedIndex])
        ],
      ),
    );
  }

  void addTaskBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) => AddTaskBottomSheet()
    );
  }

  List<Widget> tabs = [TaskListTab(), SettingsTab()];
}


