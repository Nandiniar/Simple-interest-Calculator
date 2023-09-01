
import "package:flutter/material.dart";

void main(){
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title:"Simple Interest Calculator App",
      home : SIForm(),
      // to apply primary color to our app we  use theme attribute or property in MaterialApp
       // theme: ThemeData.dark().copyWith(
      theme: ThemeData.dark().copyWith(
          appBarTheme:AppBarTheme(
            backgroundColor: Colors.indigoAccent,
          ),
    )
    )
  );
}

class SIForm extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
  return _SIFormState();
  }

}

class _SIFormState extends State<SIForm>{

  var _formKey =GlobalKey<FormState>();
  final _minimumPadding =5.0;
  var _currencies=['Rupees','Dollars','Pounch'];
  var _currentItemSelected ='Rupees';

  TextEditingController principalController=TextEditingController();// This is for Principal
  TextEditingController roiController=TextEditingController();// This is for rate of interest
  TextEditingController termController=TextEditingController();// this is for term

 var displayResult ='';
  @override
  Widget build(BuildContext context) {
TextStyle? textStyle =Theme.of(context).textTheme.headline6;//here headline is a kind of textstyle

    return Scaffold(
     // resizeToAvoidBottomInset: false,// it is used to resolve the problem of bottom overflowed by 89 pixels
      //backgroundColor: CupertinoColors.label,
     appBar :AppBar(
       //backgroundColor: Colors.indigo,
      // accentColor : Colors.indigoAccent,
       title:Text("Simple Interest Calculator",style :TextStyle(fontSize :20.00),
       )
     ) ,
      body :Form (// in place of form we can use container also
      //  margin :EdgeInsets.all(_minimumPadding * 2), // form doesnot contain the margin
        // so in place of margin we use padding which in case of container is not required
        key:_formKey,// using this we will get current status of form
        child : Padding(
          padding : EdgeInsets.all(_minimumPadding * 2),
        child:ListView(// in case of Column if we use ListView then our problem of small screen could be resolved
          // now all the elements will be the part of listview not column
          children :<Widget>[

getImageAsset(),
            Padding(
              padding :EdgeInsets.only(top : _minimumPadding, bottom: _minimumPadding),
              child :TextFormField(
                style : textStyle,
              keyboardType: TextInputType.number,
              controller : principalController,
                 // controller : roiController,
                  validator : (value){
                    if(value!.isEmpty){
                      return 'Please enter principal amount';
                    }
                  },
              decoration : InputDecoration(
                labelText: 'Principal',
                labelStyle :textStyle,
                errorStyle: TextStyle(
                  color : Colors.yellowAccent,
                  fontSize:15.0,
                ),
                hintText :'Enter Principal e.g. 12000',
                border :OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0)
                )
              )
            ),
            ),


           Padding(
             padding: EdgeInsets.only(top:_minimumPadding,bottom:_minimumPadding),
             child:TextFormField(
                keyboardType: TextInputType.number,
                style: textStyle,
                 controller : roiController,
                 validator : (value){
                   if(value!.isEmpty){
                     return 'Please enter Rate of Interest';
                   }
                 },
                /* validator: (value) {
                   if (value!.isEmpty) {
                     return 'Please enter phone number';
                   }
                   return null;
                 },*/
                decoration : InputDecoration(
                    labelText: 'Rate of Interest',

                    errorStyle: TextStyle(
                      color : Colors.yellowAccent,
                      fontSize:15.0,
                    ),
                    hintText :'In Percent',
                    labelStyle : textStyle,
                    border :OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)
                    )
                )
            ),
           ),
            Padding(
              padding :EdgeInsets.only(top : _minimumPadding,bottom : _minimumPadding),
           child: Row(
              children:<Widget>[
               Expanded(child :TextFormField(
                    keyboardType: TextInputType.number,
                    style : textStyle,
                    controller: termController,
                 validator : (value){
                   if(value!.isEmpty){
                     return 'Please enter time';
                   }
                 },
                    decoration : InputDecoration(
                        labelText: 'Term',
                        hintText :'Time in years',
                        errorStyle: TextStyle(
                          color : Colors.yellowAccent,
                          fontSize:15.0,
                        ),
                        labelStyle : textStyle,
                        border :OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)
                        )
                    ),
                ),
               ),
                Container(width : _minimumPadding *5,),// This is done to add some space between the two rows i.e
                // between Term and rupees
                Expanded(child :DropdownButton<String>(
                  items : _currencies.map((String abc){

                    return DropdownMenuItem<String>(

                      value : abc,
                      child : Text(abc),
                    );
                  }).toList(),
                  onChanged :(newValueSelected){
                    setState(() {
                      this._currentItemSelected=newValueSelected!;
                    });
                  },
                  value : _currentItemSelected,


                ),

                ),
              ]
            )
            ),
           Padding (
             padding :EdgeInsets.only(bottom : _minimumPadding,top : _minimumPadding),
             child : Row(


              children:<Widget>[
                Expanded(
            child : ElevatedButton(

                child: Text("Calculate",style : textStyle),
                style: ElevatedButton.styleFrom(
                  primary: Colors.indigo, // Background color
                  onPrimary: Colors.amber, // Text Color (Foreground color)
                ),
          onPressed: (){
            // action
            setState(() {
    if(_formKey.currentState!.validate()) {// this means  if userinput is valid then only calculate the total return
      this.displayResult =
          _calculateTotalReturns(); // we have called the function
    }
            });
          }

      ),

    ),
Expanded(
                child : ElevatedButton(

                    child: Text("Reset",style : textStyle),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black, // Background color
                      onPrimary: Colors.amber, // Text Color (Foreground color)
                    ),
                    onPressed: (){
                      setState(() {

                          _reset();

                      });
                    }
                ),
    ),
              ]
            ),
           ),
            Padding(
              padding : EdgeInsets.all(_minimumPadding *2),
              child :Text(
                this.displayResult,style: textStyle,
              ),
            ),

          ],

        )
      )
      )
    );
  }
  Widget getImageAsset(){

    AssetImage assetImage = AssetImage('images/WhatsApp Image 2023-08-30 at 13.02.30.jpeg');
    Image image = Image(image: assetImage, width: 125.0,height: 125.0,);

    return Container(child: image,margin :EdgeInsets.all(_minimumPadding * 10),);
  }
String _calculateTotalReturns(){
    double principal =double.parse(principalController.text);// we have done this because prinicipal was in string
// so we cannnot string value in double so that' s why we parse double
  double roi=double.parse(roiController.text);
  double terms =double.parse(termController.text);

  double totalAmountPayable = principal + (principal * roi * terms) /100;
  String result ='After $terms years ,your investment will be worth worth $totalAmountPayable $_currentItemSelected ';
  return result;
}
void _reset(){
    principalController.text=" ";
    roiController.text=" ";
    termController.text=" ";
    displayResult='';
    _currentItemSelected = _currencies[0];
}
}

