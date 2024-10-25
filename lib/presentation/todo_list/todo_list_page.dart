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
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey.shade400,
        actions: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return TodoListAddPage();
                  }));
                },
                icon: const Icon(
                  Icons.assignment_add,
                  size: 30,
                  color: Colors.black45,
                )),
          )
        ],
      ),
      body: const SingleChildScrollView(
        child: Column(
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
      ),
    );
  }
}
