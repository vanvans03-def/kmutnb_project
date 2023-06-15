import 'package:flutter/material.dart';
import 'package:kmutnb_project/features/auth/screens/login_screen.dart';
import 'package:kmutnb_project/features/auth/services/auth_service.dart';

import '../components/components.dart';
import '../components/under_part.dart';
import '../widgets/widgets.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = '/SignUpScreen';
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
  }

  void signUpUser() {
    authService.signUpUser(
      context: context,
      email: _emailController.text,
      password: _passwordController.text,
      name: _nameController.text,
    );
  }

  Future<void> registerGoogle() async {
    final user = await GoogleSignInApi.login();

    // ignore: use_build_context_synchronously

    authService.registerUserOauth(
      context: context,
      email: user!.email,
      password: '',
      name: user.displayName.toString(),
      id: user.id,
      image: user.photoUrl.toString(),
      token: user.serverAuthCode.toString(),
    );
  }

  final AuthService authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: size.width,
          height: size.height,
          child: SingleChildScrollView(
            child: Stack(
              children: [
                const Upside(
                  imgUrl: "assets/images/register.png",
                ),
                const PageTitleBar(title: 'สร้างบัญชีใหม่'),
                Padding(
                  padding: const EdgeInsets.only(top: 320.0),
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RoundedIcon(
                              imageUrl: "assets/images/facebook.png",
                              onTap: registerGoogle,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            RoundedIcon(
                              imageUrl: "assets/images/google.jpg",
                              onTap: registerGoogle,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "หรือสร้างบัญชีใหม่ด้วยอีเมล",
                          style: TextStyle(
                              color: Colors.grey,
                              fontFamily: 'OpenSans',
                              fontSize: 13,
                              fontWeight: FontWeight.w600),
                        ),
                        Form(
                          child: Column(
                            children: [
                              RoundedInputField(
                                controller: _emailController,
                                hintText: "อีเมล",
                                icon: Icons.email,
                                validator: (value) {},
                              ),
                              RoundedInputField(
                                controller: _nameController,
                                hintText: "ชื่อ นามสกุล",
                                icon: Icons.person,
                                validator: (value) {},
                              ),
                              RoundedPasswordField(
                                controller: _passwordController,
                                validator: (value) {},
                              ),
                              RoundedButton(
                                  text: 'สร้างบัญชี',
                                  press: () {
                                    signUpUser();
                                  }),
                              const SizedBox(
                                height: 10,
                              ),
                              UnderPart(
                                title: "พร้อมใช้งานแล้วหรือยัง?",
                                navigatorText: "เข้าใช้งานที่นี้",
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginScreen()));
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
