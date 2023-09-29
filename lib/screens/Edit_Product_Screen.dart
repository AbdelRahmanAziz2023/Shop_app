import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/module/Product_Provider.dart';
import 'package:shop/module/Products_Provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = 'editProduct';

  const EditProductScreen({Key? key}) : super(key: key);

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final priceFocusNode = FocusNode();
  final descriptionFocusNode = FocusNode();
  final imageUrlFocusNode = FocusNode();
  final imageUrlController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  var editedProduct = Product(
    id: '',
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  );
  var initialValue = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  var isInit = true;
  var isLoading = false;

  @override
  void initState() {
    super.initState();
    imageUrlFocusNode.addListener(updateImageUrl);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isInit) {
      final productId = ModalRoute.of(context)!.settings.arguments as String?;
      if (productId != null) {
        editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        initialValue = {
          'title': editedProduct.title,
          'description': editedProduct.description,
          'price': editedProduct.price.toString(),
          'imageUrl': '',
        };
        imageUrlController.text = editedProduct.imageUrl;
      }
      isInit = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    imageUrlFocusNode.removeListener(updateImageUrl);
    priceFocusNode.dispose();
    descriptionFocusNode.dispose();
    imageUrlFocusNode.dispose();
    imageUrlController.dispose();
  }

  void updateImageUrl() {
    if (!imageUrlFocusNode.hasFocus) {
      if ((!imageUrlController.text.startsWith('http') ||
              !imageUrlController.text.startsWith('https')) ||
          (!imageUrlController.text.endsWith('.png') ||
              !imageUrlController.text.endsWith('.jpg') ||
              !imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> saveForm() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    formKey.currentState!.save();
    setState(() {
      isLoading = true;
    });
    if (editedProduct.id.isNotEmpty) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(editedProduct.id, editedProduct);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(editedProduct);
      } catch (e) {
        print('error 3');
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('An error occurred'),
            content: const Text('Something went wrong'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Ok'),
              )
            ],
          ),
        );
      }
    }
    setState(() {
      isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Product',
          style: TextStyle(fontFamily: 'Anton', fontSize: 30),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: saveForm,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                  key: formKey,
                  child: ListView(
                    children: [
                      TextFormField(
                        initialValue: initialValue['title'],
                        decoration: const InputDecoration(labelText: 'Title'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(priceFocusNode);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please provide a value';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          editedProduct = Product(
                            id: editedProduct.id,
                            title: value!,
                            description: editedProduct.description,
                            price: editedProduct.price,
                            imageUrl: editedProduct.imageUrl,
                            isFavorite: editedProduct.isFavorite,
                          );
                        },
                      ),
                      TextFormField(
                        initialValue: initialValue['price'],
                        decoration: const InputDecoration(labelText: 'Price'),
                        textInputAction: TextInputAction.next,
                        focusNode: priceFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(descriptionFocusNode);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a price';
                          }
                          if (double.tryParse(value!) == null) {
                            return 'Please enter valid price';
                          }
                          if (double.parse(value!) <= 0) {
                            return 'Please enter price >0';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          editedProduct = Product(
                              id: editedProduct.id,
                              title: editedProduct.title,
                              description: editedProduct.description,
                              price: double.parse(value!),
                              imageUrl: editedProduct.imageUrl,
                              isFavorite: editedProduct.isFavorite);
                        },
                      ),
                      TextFormField(
                        initialValue: initialValue['description'],
                        decoration:
                            const InputDecoration(labelText: 'Description'),
                        maxLines: 3,
                        focusNode: descriptionFocusNode,
                        keyboardType: TextInputType.multiline,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter description';
                          }
                          if (value!.length < 10) {
                            return 'Should be at least 10 characters long';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          editedProduct = Product(
                              id: editedProduct.id,
                              title: editedProduct.title,
                              description: value!,
                              price: editedProduct.price,
                              imageUrl: editedProduct.imageUrl,
                              isFavorite: editedProduct.isFavorite);
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            margin: const EdgeInsets.only(top: 10, right: 10),
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey),
                            ),
                            child: imageUrlController.text.isEmpty
                                ? const Text('Enter a URL')
                                : FittedBox(
                                    child: Image.network(
                                      imageUrlController.text,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: imageUrlController,
                              decoration:
                                  const InputDecoration(labelText: 'Image URL'),
                              keyboardType: TextInputType.url,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter image url';
                                }
                                // else if (!value.startsWith('http') ||
                                //         !value.startsWith('https')||
                                //     !value.endsWith('.png') ||
                                //         !value.endsWith('.jpg')||
                                //         !value.endsWith('.jpeg')) {
                                // return 'Invalid Url';
                                // }
                                return null;
                              },
                              onSaved: (value) {
                                editedProduct = Product(
                                    id: editedProduct.id,
                                    title: editedProduct.title,
                                    description: editedProduct.description,
                                    price: editedProduct.price,
                                    imageUrl: value!,
                                    isFavorite: editedProduct.isFavorite);
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  )),
            ),
    );
  }
}
