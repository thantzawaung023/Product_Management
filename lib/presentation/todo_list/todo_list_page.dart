import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:product_management/presentation/todo_add/todo_list_add_page.dart';
import 'package:product_management/presentation/todo_list/widgets/carousel_slider.dart';

class TodoListPage extends ConsumerStatefulWidget {
  const TodoListPage({super.key});

  @override
  TodoListPageState createState() => TodoListPageState();
}

class TodoListPageState extends ConsumerState<TodoListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        actions: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return TodoListAddPage();
                  }));
                },
                icon: Icon(
                  Icons.assignment_add,
                  size: 30,
                  color: Theme.of(context).colorScheme.secondary,
                )),
          )
        ],
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [

                //Carousel Slide
                CustomCarouselSlider(),
                SizedBox(height: 15),

                //To Do List Card
                Padding(
                  padding: EdgeInsets.all(12),
                  child: ToDoList(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
