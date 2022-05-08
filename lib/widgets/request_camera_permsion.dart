import 'package:flutter/material.dart';

class RequestCameraPermision extends StatelessWidget {
  final void Function() _whenButtonPressed;
  const RequestCameraPermision(this._whenButtonPressed, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.camera_alt,
            size: 56,
          ),
          const SizedBox(
            height: 15,
          ),
          const Text(
            "Plese give accese to camera in order to proceed",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 34),
          ),
          const SizedBox(
            height: 15,
          ),
          SizedBox(
            width: 320,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: _whenButtonPressed,
              child: const Text(
                "Grant Permmision",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
