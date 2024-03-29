import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';
import './../../../models/app_state_model.dart';
import '../../../resources/api_provider.dart';

class ReviewsPage extends StatefulWidget {
  final int productId;
  ReviewsPage({Key? key, required this.productId}) : super(key: key);
  @override
  _ReviewsPageState createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  Map reviewData = Map<String, dynamic>();
  final apiProvider = ApiProvider();
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController reviewController = new TextEditingController();
  AppStateModel appStateModel = AppStateModel();
  bool showRatingError = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  var rating = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text(appStateModel.blocks.localeText.reviews),
        ),
        body: ListView(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Text(appStateModel.blocks.localeText.whatIsYourRate + '?',
                        style: Theme.of(context).textTheme.caption!.copyWith(
                            // fontWeight: FontWeight.w600
                            )),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                        child: SmoothStarRating(
                      rating: rating,
                      size: 30,
                      filledIconData: Icons.star,
                      halfFilledIconData: Icons.star_half,
                      defaultIconData: Icons.star_border,
                      starCount: 5,
                      allowHalfRating: true,
                      color: Colors.orange,
                      borderColor: Colors.orange,
                      spacing: 2.0,
                      onRatingChanged: (value) {
                        setState(() {
                          rating = value;
                        });
                      },
                    )),
                    if (rating == 0.0 && showRatingError)
                      Text(appStateModel.blocks.localeText.whatIsYourRate,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2!
                              .copyWith(color: Theme.of(context).errorColor))
                    else
                      Container(),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: TextFormField(
                              maxLength: 1000,
                              maxLines: 8,
                              controller: reviewController,
                              decoration: InputDecoration(
                                alignLabelWithHint: true,
                                labelText: appStateModel.blocks.localeText.yourReview,
                                errorMaxLines: 1,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return appStateModel.blocks.localeText.pleaseEnterMessage;
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    if(appStateModel.blocks.user.id == 0)
                    Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                            labelText: appStateModel.blocks.localeText.name,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return appStateModel.blocks.localeText.pleaseEnter + ' ${appStateModel.blocks.localeText.name.toLowerCase()}';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: appStateModel.blocks.localeText.email,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return appStateModel.blocks.localeText.pleaseEnter + ' ${appStateModel.blocks.localeText.email.toLowerCase()}';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          child: Text(appStateModel.blocks.localeText.submit),
                          onPressed: () async {
                            setState(() {
                              showRatingError = true;
                            });
                            if (_formKey.currentState!.validate() &&
                                rating != 0.0) {
                              _formKey.currentState!.save();
                              reviewData["author"] = nameController.text;
                              reviewData["email"] = emailController.text;
                              reviewData["comment"] = reviewController.text;
                              reviewData['rating'] = rating.toString();
                              reviewData['_wp_unfiltered_html_comment'] = appStateModel.blocks.nonce.unfilteredHtmlComment.toString();
                              reviewData['comment_post_ID'] =
                                  widget.productId.toString();
                              apiProvider.postWihoutUserLocation(
                                  '/wp-comments-post.php', reviewData);
                              nameController.clear();
                              emailController.clear();
                              reviewController.clear();
                              setState(() {
                                showRatingError = false;
                              });
                              _thankYouMessage();
                            }
                          },
                        ),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom))
                  ],
                ),
              ),
            )
          ],
        ));
  }

  void _thankYouMessage() {
    showDialog(builder: (context) => AlertDialog(
      content: Text(appStateModel.blocks.localeText.thankYouForYourReview),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
          child: Text(appStateModel.blocks.localeText.ok),
          //color: const Color(0xFF1BC0C5),
        ),
      ],
    ), context: context,
    );
  }
}
