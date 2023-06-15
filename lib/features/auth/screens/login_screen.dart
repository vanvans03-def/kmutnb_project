import 'package:flutter/material.dart';
import 'package:kmutnb_project/features/auth/components/under_part.dart';
import 'package:kmutnb_project/features/auth/screens/signup_screen.dart';
import 'package:kmutnb_project/features/auth/services/auth_service.dart';
import '../components/components.dart';
import '../widgets/constants.dart';
import '../widgets/widgets.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/LoginScreen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
  }

  void signInGoogle() async {
    final user = await GoogleSignInApi.login();
    // ignore: use_build_context_synchronously
    authService.signInUser(
      context: context,
      email: user!.email,
      password: user.id,
    );
  }

  void signInUser() async {
    authService.signInUser(
      context: context,
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

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
                  imgUrl: "assets/images/login.png",
                ),
                const PageTitleBar(title: 'เข้าสู่ระบบด้วยบัญชีของคุณ'),
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
                              onTap: signInGoogle,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            RoundedIcon(
                              imageUrl: "assets/images/google.jpg",
                              onTap: signInGoogle,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "หรือใช้บัญชีอีเมลของคุณ",
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
                              RoundedPasswordField(
                                controller: _passwordController,
                                validator: (value) {},
                              ),
                              //switchListTile(),
                              RoundedButton(
                                  text: 'เข้าสู่ระบบ',
                                  press: () {
                                    signInUser();
                                  }),
                              const SizedBox(
                                height: 10,
                              ),
                              UnderPart(
                                title: "หากยังไม่มีบัญชี ?",
                                navigatorText: "คลิกที่นี้เพื่อสมัคร",
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SignUpScreen()));
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

switchListTile() {
  return Padding(
    padding: const EdgeInsets.only(left: 50, right: 40),
    child: SwitchListTile(
      dense: true,
      title: const Text(
        'Remember Me',
        style: TextStyle(fontSize: 16, fontFamily: 'OpenSans'),
      ),
      value: true,
      activeColor: kPrimaryColor,
      onChanged: (val) {},
    ),
  );
}
