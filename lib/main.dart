import 'package:flutter/material.dart';
import 'package:flutter_aej_news/resources/ItemModel.dart';
import 'package:flutter_aej_news/resources/api_provider.dart';
import 'package:shimmer/shimmer.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: "AEJ News Project",
      home: Scaffold(
        appBar: AppBar(
          title: Text("News List"),
        ),
        body: NewsList(),
      ),
    );
  }
}

class NewsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ApiProvider().fetchTopIds(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        print(snapshot.data);
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          print("snapshot hasdata");
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              return NewsTileItem(snapshot.data[index]);
            },
          );
        }

        return Container();
      },
    );
  }
}

class NewsTileItem extends StatelessWidget {
  final int id;

  NewsTileItem(this.id);

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<ItemModel>(
      future: ApiProvider().fetchItem(id),
      builder: (BuildContext context, AsyncSnapshot<ItemModel> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingContainerShimmer();
        }

        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return ListTile(
            title: Text(snapshot.data.title),
            subtitle: Text("Score ${snapshot.data.score}"),
            trailing: Column(
              children: <Widget>[
                Icon(Icons.star),
                Text(snapshot.data.descendants.toString())
              ],
            ),
          );
        }

        return Container();
      },
    );
  }
}

class LoadingContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: buildBox(),
          subtitle: buildBox(),
        ),
        Divider(
          height: 8.0,
        )
      ],
    );
  }

  Widget buildBox() {
    return Container(
      color: Colors.grey[200],
      height: 24.0,
      width: 150.0,
      margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
    );
  }
}

class LoadingContainerShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Shimmer.fromColors(
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[100],
      child: LoadingContainer(),
    );
  }
}
