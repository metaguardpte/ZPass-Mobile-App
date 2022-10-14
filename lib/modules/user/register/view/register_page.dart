import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:zpass/base/base_provider.dart';
import 'package:zpass/generated/l10n.dart';
import 'package:zpass/modules/user/register/register_provider.dart';
import 'package:zpass/modules/user/register/widgets/register_basic_information.dart';
import 'package:zpass/modules/user/register/widgets/register_protocol_checkbox.dart';
import 'package:zpass/modules/user/register/widgets/register_secret_key.dart';
import 'package:zpass/modules/user/register/widgets/register_setup_password.dart';
import 'package:zpass/modules/user/register/widgets/register_stepper.dart';
import 'package:zpass/routers/fluro_navigator.dart';
import 'package:zpass/util/toast_utils.dart';
import 'package:zpass/widgets/custom_scroll_behavior.dart';
import 'package:zpass/widgets/load_image.dart';
import 'package:zpass/widgets/zpass_button_gradient.dart';

enum RegisterType {
  personal,
  business,
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key, this.type = RegisterType.personal}) : super(key: key);
  final RegisterType? type;
  @override
  RegisterState createState() => RegisterState();

}

class RegisterState extends ProviderState<RegisterPage, RegisterProvider> {
  int get _stepCount => widget.type == RegisterType.personal ? 3 : 4;
  final PageController _controller = PageController();
  List<Widget> _contentWidgets = [];
  final List<String> _titles = [S.current.registerTitleCreate, S.current.registerTitlePassword, S.current.registerTitleSecret];
  final List<String> _planTypes = [S.current.registerPlanTypePilot];

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  void initState() {
    super.initState();
    _contentWidgets = _buildContentWidgets();
  }

  @override
  Widget buildContent(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buildAppbarTitle(),
        centerTitle: true,
        leading: _buildBackBtn(),
      ),
      body: Container(
        color: const Color(0xFFF3F5F8),
        alignment: Alignment.center,
        child: Column(
          children: [
            Selector<RegisterProvider, int>(
              builder: (_, index, __) {
                return RegisterStepper(count: _stepCount, index: index,);
              },
              selector: (_, provider) => provider.stepIndex,
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: CustomScrollBehavior(),
                child: PageView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _controller,
                  itemCount: _stepCount,
                  itemBuilder: (BuildContext context, int index) {
                    return _contentWidgets[index];
                  },
                ),
              ),
            ),
            _buildBottomView(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppbarTitle() {
    return Selector<RegisterProvider, int>(
        builder: (_, index, __) {
          final String title = _titles[index];
           return Text(title,
               style: const TextStyle(
                 color: Color(0xFF16181A),
                 fontSize: 17,
                 fontWeight: FontWeight.w500,
               ),
           );
        },
        selector: (_, provider) => provider.stepIndex,
    );
  }

  Widget _buildBackBtn() {
    return IconButton(onPressed: _onBackTap, icon: const LoadAssetImage("ic_back_black", width: 30, height: 16,));
  }

  List<Widget> _buildContentWidgets() {
    return [
      RegisterBasicInformation(provider: provider),
      const RegisterSetupPassword(),
      const RegisterSecretKey(),
    ];
  }

  Widget _buildBottomView() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(bottom: 16, top: 10),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            _buildProtocol(),
            _buildButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildProtocol() {
    return Selector<RegisterProvider, int>(
      builder: (_, index, __) {
        bool visible = index < 1;
        return Visibility(
          visible: visible,
          child: RegisterProtocolCheckbox(
              onChange: (value) => provider.protocolChecked = value,
          ),
        );
      },
      selector: (_, provider) => provider.stepIndex,
    );
  }

  Widget _buildButton() {
    return Selector<RegisterProvider, Tuple2<bool, int>>(
      builder: (_, tuple, __) {
        final int index = tuple.item2;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          child: ZPassButtonGradient(
            text: index == _stepCount - 1 ? S.current.btnFinish : S.current.btnNext,
            startColor: const Color(0xFF5273FE),
            endColor: const Color(0xFF4342FF),
            height: 46,
            width: double.infinity,
            borderRadius: 23,
            loading: tuple.item1,
            onPress: _nextStep,
          ),
        );
      },
      selector: (_, provider) => Tuple2(provider.loading, provider.stepIndex),
    );
  }

  void _nextStep() async {
    if (provider.stepIndex == 0) {
      final result = await _doCheckEmailVerifyCode();
      if (!result) return;
    } else if (provider.stepIndex == 1) {

    } else if (provider.stepIndex == 2) {

    }
    provider.stepIndex++;
    _controller.nextPage(duration: const Duration(milliseconds: 350), curve: Curves.linear);
  }

  void _previousStep() {
    provider.stepIndex--;
    _controller.previousPage(duration: const Duration(milliseconds: 350), curve: Curves.linear);
  }

  _onBackTap() {
    if (provider.stepIndex == 0) {
      NavigatorUtils.goBack(context);
      return;
    }
    _previousStep();
  }

  Future<bool> _doCheckEmailVerifyCode() async {
    if (provider.emailVerifyCode.isEmpty || provider.emailVerifyCode.length < 6) {
      Toast.show(S.current.emailVerifyCodeHint);
      return Future.value(false);
    }
    if (!provider.protocolChecked) {
      Toast.show(S.current.registerProtocolNotCheck);
      return Future.value(false);
    }
    final error = (await provider.doCheckEmailVerifyCode()) ?? "";
    if (error.isNotEmpty) {
      Toast.show(error);
    }
    return Future.value(error.isEmpty);
  }

  @override
  RegisterProvider prepareProvider() {
    return RegisterProvider();
  }

}