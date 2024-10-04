part of 'common.dart';

class ShimmerList extends StatelessWidget {
  const ShimmerList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(Constant.padding),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                width: 200.0.w,
                height: 20.0.sp,
                color: Colors.white,
              ),
            ),
            SizedBox(height: Constant.padding),
            Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                width: 300.0.w,
                height: 16.0.sp,
                color: Colors.white,
              ),
            ),
            SizedBox(height: Constant.padding * 2),
          ],
        );
      },
    );
  }
}
