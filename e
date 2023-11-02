
class TabletLogIn extends StatefulWidget {
  const TabletLogIn({
    super.key,
  });

  @override
  State<TabletLogIn> createState() => _TabletLogInState();
}

class _TabletLogInState extends State<TabletLogIn> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  // final TextEditingController _phonenumberController = TextEditingController();

  void login() async {
    final String identifier = _usernameController.text;
    final String password = _passwordController.text;
    SnackBarHelper snacky = SnackBarHelper(context);

    if (password.isEmpty && identifier.isEmpty) {
      print("Please Enter Details to Log In");
      _formKey.currentState?.reset();
      snacky.showSnackBar("Please Enter Details to Log In", isError: true);
      return;
    } else if (password.isEmpty) {
      print("Please Enter Password");
      snacky.showSnackBar("Please Enter Password", isError: true);
    } else if (identifier.isEmpty) {
      print("Please Enter either Username or phone number");
      snacky.showSnackBar("Please Enter either Username or phone number",
          isError: true);
    } else {
      try {
        // Check if the username exists
        final QuerySnapshot usersByUsername = await FirebaseFirestore.instance
            .collection('users')
            .where('username', isEqualTo: identifier)
            .where('password', isEqualTo: password)
            .get();
        _usernameController.clear();
        _passwordController.clear();

        if (usersByUsername.docs.isNotEmpty) {
          // Successfully logged in with username, navigate to the dashboard page
          _formKey.currentState?.reset();
          print("Logged in successfully with username");
          snacky.showSnackBar("Logged in successfully", isError: false);
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const MobileScaffold()));
          _usernameController.clear();
          _passwordController.clear();
        } else {
          // Username was not found, so check with phone number
          final QuerySnapshot usersByPhone = await FirebaseFirestore.instance
              .collection('users')
              .where('phone', isEqualTo: identifier)
              .where('password', isEqualTo: password)
              .get();
          _usernameController.clear();
          _passwordController.clear();

          if (usersByPhone.docs.isNotEmpty) {
            // Successfully logged in with phone number, navigate to the dashboard page
            _formKey.currentState?.reset();
            print("Logged in successfully with phone number");
            snacky.showSnackBar("Logged in successfully", isError: false);
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const MobileScaffold()));
            _usernameController.clear();
            _passwordController.clear();
          } else {
            // No matching user found with the provided credentials
            print("Invalid Login details");
            snacky.showSnackBar("Invalid Login details", isError: true);
            _usernameController.clear();
            _passwordController.clear();
          }
        }
      } on FirebaseException catch (e) {
        // Handle database query errors
        print('Error: $e');
        snacky.showSnackBar(e.toString(), isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return 
    Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 1),
              Padding(
                padding: const EdgeInsets.all(8.0)
                    .add(const EdgeInsets.symmetric(vertical: 40)),
                child: Image.asset('assets/mavunohub_logo.png',
                    width: 250, height: 150),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  // Wrap the row with Center
                  child: Text(
                    'Welcome back, Log in to continue',
                    style: TextStyle(
                      fontFamily: 'Gilmer',
                      fontSize: 17,
                      color: Theme.of(context).colorScheme.onBackground,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  Container(
                    width: 400,
                    child: Column(children: [
                      Material(
                        child: FormText(
                          prefix: Icons.account_circle_rounded,
                          title: 'Username or PhoneNumber',
                          text: 'Username or PhoneNumber',
                          controller: _usernameController,
                          validator: (value) {
                            if (value == null) {
                              return 'Please Enter Username';
                            }
                            return null;
                          },
                        ),
                      ),
                      PassWord(
                        title: 'Enter Password',
                        text: 'Enter Password',
                        controller: _passwordController,
                      ),
                    ]),
                  ),
                ],
              ),
              FormButton(
                text: 'Log In',
                action: login,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  // Wrap the row with Center
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center, // Center the row horizontally
                    children: [
                      Text(
                        'Don\'t have an Account?',
                        style: TextStyle(
                          fontFamily: 'Gilmer',
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onBackground,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignUp()));
                        },
                        child: Text(
                          ' Sign Up',
                          style: TextStyle(
                            fontFamily: 'Gilmer',
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.tertiary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(flex: 1),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ForgotPassword()));
                },
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(
                    fontFamily: 'Gilmer',
                    fontSize: 15,
                    color: Theme.of(context).colorScheme.tertiary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const Spacer(flex: 1),
            ],
          ),
        ),
  
    );
  }
}
