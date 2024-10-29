import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerTodoItem extends StatelessWidget {
  const ShimmerTodoItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TodoSkeleton(),
            TodoSkeleton(),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Skelton(width: 184, height: 150),
            Skelton(width: 184, height: 150),
          ],
        ),
      ],
    );
  }
}

class ShimmerCarousel extends StatelessWidget {
  const ShimmerCarousel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[900]!,
      highlightColor: Colors.grey[100]!,
      child: const Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Skelton(
                height: 170,
                width: 30,
              ),
              Skelton(
                height: 170,
                width: 320,
              ),
              Skelton(
                height: 170,
                width: 30,
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Skelton(width: 8, height: 8),
              SizedBox(
                width: 8,
              ),
              Skelton(width: 8, height: 8),
              SizedBox(
                width: 8,
              ),
              Skelton(width: 8, height: 8),
              SizedBox(
                width: 8,
              ),
              Skelton(width: 8, height: 8),
              SizedBox(
                width: 8,
              ),
              Skelton(width: 8, height: 8),
            ],
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}

class TodoSkeleton extends StatelessWidget {
  const TodoSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[900]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: 184,
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.black.withOpacity(0.04),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 150),
            // Title Skeleton
            Skelton(width: 50, height: 10),
            Divider(),
            // Description Skeleton (3 lines of text)
            Skelton(width: 90, height: 9),
            SizedBox(height: 6),
            Skelton(width: 110, height: 9),
            SizedBox(height: 6),
            Skelton(width: 100, height: 9),
            Divider(),
            Row(
              children: [
                Skelton(width: 10, height: 10),
                SizedBox(
                  width: 7,
                ),
                Skelton(width: 110, height: 9),
              ],
            ),
            SizedBox(height: 6),
            Row(
              children: [
                Skelton(width: 10, height: 10),
                SizedBox(
                  width: 7,
                ),
                Skelton(width: 110, height: 9),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Skelton(width: 20, height: 20),
                    SizedBox(
                      width: 7,
                    ),
                    Skelton(width: 20, height: 9),
                  ],
                ),
                Row(
                  children: [
                    Skelton(width: 20, height: 20),
                    SizedBox(
                      width: 7,
                    ),
                    Skelton(width: 20, height: 9),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Skelton extends StatelessWidget {
  const Skelton({
    super.key,
    required this.width,
    required this.height,
  });

  final double width, height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.black.withOpacity(0.08),
      ),
    );
  }
}
