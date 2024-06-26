// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_project/core/utilts/widgets/custom_text_form_field.dart';
import 'package:team_project/core/utilts/widgets/show_toast_widget.dart';
import 'package:team_project/helpers/extentions.dart';
import 'package:team_project/view/sign_up/presentation/view/widgets/upload_profile_image.dart';
import '../../../../../helpers/spacing.dart';
import '../../../../../routing/routing.dart';
import '../../../../../theming/colors.dart';
import '../../../../sign_in/presentation/view/widgets/custom_button.dart';
import '../../view_model/sign_up/cubit.dart';
import '../../view_model/sign_up/states.dart';

class SignUnCard extends StatefulWidget {
  const SignUnCard({
    super.key,
  });

  @override
  State<SignUnCard> createState() => _SignUnCardState();
}

class _SignUnCardState extends State<SignUnCard> {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();

  final phoneController = TextEditingController();

  final otpController = TextEditingController();

  final passwordController = TextEditingController();

  final confirmPasswordController = TextEditingController();

  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignUpCubit, SignUpStates>(
      listener: (context, state) {
        if (state is SignUpSuccessState) {
          print(state.signUpModel.message);
          context.pushReplacementNamed(Routes.welcomeSignUpScreen);
        }
      },
      builder: (context, state) {
        var cubit = SignUpCubit.get(context);
        return Positioned(
            top: 160.h,
            left: 44.w,
            right: 43.w,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColor.secondaryColor,
                  width: 8,
                ),
                color: AppColor.mainColor,
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
                  child: Form(
                    key: formKey,
                    child: Column(children: [
                      verticalSpace(15),
                      const UploadUserProfilePic(),
                      verticalSpace(20),
                      AppTextFormField(
                        controller: emailController,
                        type: TextInputType.emailAddress,
                        hintText: 'Email',
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: AppColor.secondaryColor,
                        ),
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return "please enter your email address";
                          }
                          return null;
                        },
                      ),
                      verticalSpace(20),
                      AppTextFormField(
                        controller: nameController,
                        type: TextInputType.text,
                        hintText: 'Name',
                        prefixIcon: Icon(
                          Icons.person_outline,
                          color: AppColor.secondaryColor,
                        ),
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return "please enter your name ";
                          }
                          return null;
                        },
                      ),
                      verticalSpace(16),
                      AppTextFormField(
                        controller: phoneController,
                        type: TextInputType.phone,
                        hintText: 'Phone',
                        prefixIcon: Icon(
                          Icons.phone,
                          color: AppColor.secondaryColor,
                        ),
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return "please enter your phone ";
                          }
                          return null;
                        },
                      ),
                      verticalSpace(16),
                      AppTextFormField(
                        controller: otpController,
                        type: TextInputType.number,
                        hintText: 'OTP Code',
                        prefixIcon: Icon(
                          Icons.qr_code_2,
                          color: AppColor.secondaryColor,
                        ),
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return "please enter the OTP that sent to your email ";
                          }
                          return null;
                        },
                      ),
                      verticalSpace(16),
                      AppTextFormField(
                          prefixIcon: Icon(
                            Icons.lock_outline_rounded,
                            color: AppColor.secondaryColor,
                          ),
                          type: TextInputType.visiblePassword,
                          hintText: 'Password',
                          controller: passwordController,
                          isObscureText: cubit.obSecureText,
                          suffixIcon: IconButton(
                            onPressed: () {
                              cubit.changePasswordVisibility();
                            },
                            icon: cubit.suffixIcon,
                          ),
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return "please enter your password";
                            } else if (confirmPasswordController.text !=
                                passwordController.text) {
                              return "Password and confirm password didn't match ";
                            }
                            return null;
                          }),
                      verticalSpace(16),
                      AppTextFormField(
                        controller: confirmPasswordController,
                        type: TextInputType.visiblePassword,
                        hintText: 'Confirm Password',
                        prefixIcon: Icon(
                          Icons.lock_outline_rounded,
                          color: AppColor.secondaryColor,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            cubit.changeConfirmPasswordVisibility();
                          },
                          icon: cubit.confirmSuffixIcon,
                        ),
                        isObscureText: cubit.confirmObSecureText,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return "please enter your password confirmation";
                          } else if (confirmPasswordController.text !=
                              passwordController.text) {
                            return "Password and confirm password didn't match ";
                          }
                          return null;
                        },
                        onSubmit: (value) {
                          if (formKey.currentState!.validate()) {
                            cubit.userSignUp(
                              email: emailController.text,
                              name: nameController.text,
                              phone: phoneController.text,
                              otp: otpController.text,
                              password: passwordController.text,
                              confirmPassword: confirmPasswordController.text,
                            );
                          }
                        },
                      ),
                      verticalSpace(27),
                      state is! SignUpLoadingState
                          ? AppTextButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  if (cubit.profilePic == null) {
                                    showToast(
                                      text: "image is required",
                                      states: ToastStates.ERROR,
                                    );
                                  } else {
                                    cubit.userSignUp(
                                      email: emailController.text,
                                      name: nameController.text,
                                      phone: phoneController.text,
                                      otp: otpController.text,
                                      password: passwordController.text,
                                      confirmPassword:
                                          confirmPasswordController.text,
                                    );
                                  }
                                }
                              },
                              buttonText: 'Sign up',
                              textStyle: TextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColor.mainColor,
                              ))
                          : Center(
                              child: CircularProgressIndicator(
                                color: AppColor.secondaryColor,
                              ),
                            ),
                      verticalSpace(20),
                    ]),
                  )),
            ));
      },
    );
  }
}
