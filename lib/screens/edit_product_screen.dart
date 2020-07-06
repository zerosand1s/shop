import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/products_provider.dart';

import '../providers/single_product_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _isInit = true;
  var _isLoading = false;
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };

  SingleProductProvider _newOrEditedProduct = SingleProductProvider(
    id: null,
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  );

  void _updateImageUrl() {
    if (!_imageFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void _saveOrUpdateProduct() async {
    final isFormValid = _form.currentState.validate();

    if (!isFormValid) {
      return;
    }
    _form.currentState.save();

    setState(() {
      _isLoading = true;
    });

    if (_newOrEditedProduct.id != null) {
      Provider.of<ProductsProvider>(context, listen: false)
          .updateProduct(_newOrEditedProduct.id, _newOrEditedProduct);
    } else {
      try {
        await Provider.of<ProductsProvider>(context, listen: false)
            .addProduct(_newOrEditedProduct);
      } catch (err) {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error!'),
            content: Text('Something went wrong. Please try again later.'),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });

        Navigator.of(context).pop();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _imageFocusNode.addListener(_updateImageUrl);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;

      if (productId != null) {
        _newOrEditedProduct =
            Provider.of<ProductsProvider>(context, listen: false)
                .findById(productId);
        _initValues = {
          'title': _newOrEditedProduct.title,
          'description': _newOrEditedProduct.description,
          'price': _newOrEditedProduct.price.toString(),
          // 'imageUrl': _newOrEditedProduct.imageUrl,
          'imageUrl': ''
        };
        _imageUrlController.text = _newOrEditedProduct.imageUrl;
      }
    }
    _isInit = false;
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageFocusNode.removeListener(_updateImageUrl);
    _imageFocusNode.dispose();
    _imageUrlController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _newOrEditedProduct.id != null ? 'Edit Product' : 'Add Product',
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Title'),
                      initialValue: _initValues['title'],
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (value) =>
                          FocusScope.of(context).requestFocus(_priceFocusNode),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter valid title';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _newOrEditedProduct = SingleProductProvider(
                          id: _newOrEditedProduct.id,
                          isFavorite: _newOrEditedProduct.isFavorite,
                          title: value,
                          description: _newOrEditedProduct.description,
                          price: _newOrEditedProduct.price,
                          imageUrl: _newOrEditedProduct.imageUrl,
                        );
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Price'),
                      initialValue: _initValues['price'],
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (value) => FocusScope.of(context)
                          .requestFocus(_descriptionFocusNode),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter valid price';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter valid amount';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Price amount should be more than 0';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _newOrEditedProduct = SingleProductProvider(
                          id: _newOrEditedProduct.id,
                          isFavorite: _newOrEditedProduct.isFavorite,
                          title: _newOrEditedProduct.title,
                          description: _newOrEditedProduct.description,
                          price: double.parse(value),
                          imageUrl: _newOrEditedProduct.imageUrl,
                        );
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Description'),
                      initialValue: _initValues['description'],
                      maxLines: 3,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter valid description';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _newOrEditedProduct = SingleProductProvider(
                          id: _newOrEditedProduct.id,
                          isFavorite: _newOrEditedProduct.isFavorite,
                          title: _newOrEditedProduct.title,
                          description: value,
                          price: _newOrEditedProduct.price,
                          imageUrl: _newOrEditedProduct.imageUrl,
                        );
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(top: 10, right: 10),
                          decoration: BoxDecoration(
                              border: Border.all(width: 1), color: Colors.grey),
                          child: _imageUrlController.text.isEmpty
                              ? Text('Enter image URL')
                              : FittedBox(
                                  child: Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Image URL'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            focusNode: _imageFocusNode,
                            onFieldSubmitted: (value) => _saveOrUpdateProduct(),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter image url';
                              }
                              if (!value.startsWith('http') ||
                                  !value.startsWith('https')) {
                                return 'Please enter valid image url';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _newOrEditedProduct = SingleProductProvider(
                                id: _newOrEditedProduct.id,
                                isFavorite: _newOrEditedProduct.isFavorite,
                                title: _newOrEditedProduct.title,
                                description: _newOrEditedProduct.description,
                                price: _newOrEditedProduct.price,
                                imageUrl: value,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 20,
                      margin: EdgeInsets.only(top: 75),
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: RaisedButton(
                        onPressed: _saveOrUpdateProduct,
                        color: Theme.of(context).accentColor,
                        child: Text(
                          'Save',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
