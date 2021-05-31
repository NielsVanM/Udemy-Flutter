import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/product.dart';
import 'package:shop/providers/products_provider.dart';

class ProductFormScreen extends StatefulWidget {
  static const routeName = "/add_edit_product/";

  const ProductFormScreen({Key key}) : super(key: key);

  @override
  _ProductFormScreenState createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _imageUrlController = TextEditingController();

  FocusNode _imageFocusNode = FocusNode();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Product product;

  bool _hasSetTextEditingValues = false;
  bool _isLoading = false;

  void _updateImage() {
    if (!_imageFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void _saveForm() async {
    if (_formKey.currentState.validate())
      _formKey.currentState.save();
    else
      return;
    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<Products>(context, listen: false).addOrUpdate(product);
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    } catch (e) {
      await showDialog<Null>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text("An error occured"),
          content: Text(
              "Something went wrong while saving your product. Please try again."),
          actions: [
            SimpleDialogOption(
              child: Text("Dismiss"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      );

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    _imageFocusNode.addListener(_updateImage);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (!_hasSetTextEditingValues) {
      product = ModalRoute.of(context).settings.arguments as Product;

      if (product == null) {
        product = Product(
          id: null,
          title: "",
          description: "",
          price: 0,
          imageUrl: "",
        );
      }

      _nameController.text = product.title;
      _descriptionController.text = product.description;
      _priceController.text = product.price.toString();
      _imageUrlController.text = product.imageUrl;

      _hasSetTextEditingValues = true;
    }

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _imageUrlController.dispose();
    _imageFocusNode.removeListener(_updateImage);
    _imageFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            product == null ? "Add New Product " : "Editing ${product.title}"),
        actions: [
          IconButton(icon: Icon(Icons.save), onPressed: _saveForm),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(labelText: "Product Name"),
                        textInputAction: TextInputAction.next,
                        controller: _nameController,
                        onSaved: (val) =>
                            product = product.copyWith(title: val),
                        validator: (val) {
                          if (val.isEmpty) {
                            return "This field cannot be empty";
                          }

                          return null;
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: "Price"),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        controller: _priceController,
                        onSaved: (val) => product =
                            product.copyWith(price: double.parse(val)),
                        validator: (val) {
                          if (val.isEmpty) {
                            return "This field cannot be empty";
                          }

                          if (double.tryParse(val) == null) {
                            return "Please enter a valid number";
                          }

                          if (double.parse(val) <= 0) {
                            return "The price must be above zero";
                          }

                          return null;
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: "Description"),
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                        controller: _descriptionController,
                        onSaved: (val) =>
                            product = product.copyWith(description: val),
                        validator: (val) {
                          if (val.isEmpty) {
                            return "This field cannot be empty";
                          }

                          if (val.length < 10) {
                            return "The description should be longer than 10 characters";
                          }

                          return null;
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            margin: EdgeInsets.only(top: 8, right: 10),
                            child: _imageUrlController.text == ""
                                ? Icon(Icons.wallpaper_outlined)
                                : FittedBox(
                                    child: Image.network(
                                      _imageUrlController.text,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration:
                                  InputDecoration(labelText: "Image URL"),
                              controller: _imageUrlController,
                              textInputAction: TextInputAction.done,
                              focusNode: _imageFocusNode,
                              onEditingComplete: _updateImage,
                              onFieldSubmitted: (_) => _saveForm(),
                              onSaved: (val) =>
                                  product = product.copyWith(imageUrl: val),
                              validator: (val) {
                                if (val.isEmpty) {
                                  return "This field cannot be empty";
                                }

                                if (!val.startsWith('http') &&
                                    !val.startsWith('https')) {
                                  return "Please enter a valid URL";
                                }

                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

// Expanded(
//   child: TextFormField(
//     decoration: InputDecoration(labelText: 'Image URL'),
//     keyboardType: TextInputType.url,
//     textInputAction: TextInputAction.done,
//     controller: _imageUrlController,
//     onEditingComplete: () {
//       setState(() {});
//     },
//   )
// ),
