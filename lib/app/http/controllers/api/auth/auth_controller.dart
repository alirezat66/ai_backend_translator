import 'dart:math';

import 'package:ai_translator/app/email/verification_mail.dart';
import 'package:ai_translator/database/mongo/mongo_connection.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:vania/vania.dart';

class AuthController extends Controller {
  Future<Response> signUp(Request request) async {
    request.validate({
      'first_name': 'required|max_length:20|min_length:2',
      'last_name': 'required|max_length:20',
      'email': 'required|email',
      'password': 'required|min_length:6',
    }, {
      'first_name.required': 'The first name is required',
      'first_name.max_length': 'The first name must be less than 20 characters',
      'first_name.min_length': 'The first name must be at least 2 characters',
      'last_name.required': 'The last name is required',
      'last_name.max_length': 'The last name must be less than 20 characters',
      'email.required': 'Email is required',
      'email.email': 'Email is not valid',
      'password.required': 'Password is required',
      'password.min': 'Password must be at least 6 characters',
    });

    var data = await MongoConnection()
        .db
        .collection('users')
        .findOne(where.eq('email', request.input('email')));

    if (data != null) {
      // we should check if user is activated or not

      if (data['activation_status'] != 'deActivated') {
        return Response.json({'message': 'Email already exists'}, 400);
      } else {
        return otp(request);
      }
    } else {
      Map<String, dynamic> newUser = {
        'first_name': request.input('first_name'),
        'last_name': request.input('last_name'),
        'email': request.input('email'),
        'password': Hash().make(request.input('password').toString()),
        'created_at': DateTime.now(),
        'updated_at': DateTime.now(),
        'activation_status': 'deActivated',
      };

      await MongoConnection().db.collection('users').insert(newUser);

      return await otp(request);
    }
  }

  Future<Response> login(Request request) async {
    request.validate({
      'email': 'required|email',
      'password': 'required',
    }, {
      'email.required': 'The email is required',
      'email.email': 'The email is not valid',
      'password.required': 'The password is required',
    });

    var user = await MongoConnection()
        .db
        .collection('users')
        .findOne(where.eq('email', request.input('email')));
    print(user);
    if (user == null) {
      return Response.json({'message': 'User name or password is wrong'}, 404);
    }

    if (!Hash().verify(request.input('password'), user['password'])) {
      return Response.json({'message': 'Email or password is wrong'}, 401);
    }
    if (user['activation_status'] == 'deActivate') {
      return Response.json({'message': 'User is not active'}, 401);
    } else if (user['activation_status'] == 'suspend' ||
        user['activation_status'] == 'block') {
      return Response.json(
          {'message': 'User is blocked, please call to admin!'}, 403);
    }
    // If you have guard and multi access like user and admin you can pass the guard Auth().guard('admin')

    final userAsUser = {
      'id': user['_id'],
      '_id': user['_id'],
      'first_name': user['first_name'],
      'last_name': user['last_name'],
      'email': user['email'],
      'created_at': user['created_at'] is DateTime
          ? (user['created_at'] as DateTime).toString()
          : user['created_at']?.toString() ?? '',
      'updated_at': user['updated_at'] is DateTime
          ? (user['updated_at'] as DateTime).toString()
          : user['updated_at']?.toString() ?? '',
    };
    Map<String, dynamic> token = await Auth().login(userAsUser).createToken(
        expiresIn: Duration(days: 30),
        withRefreshToken: true,
        customToken: true);
    print(token);
    return Response.json(token);
  }

  Future<Response> refreshToken(Request request) {
    final newToken = Auth().createTokenByRefreshToken(
        request.header('Authorization')!,
        expiresIn: Duration(days: 30));
    return Response.json(newToken);
  }
  Future<Response> otp(Request request) async {
    request.validate({
      'email': 'required|email',
    }, {
      'email.required': 'The email is required',
      'email.email': 'The email is not valid',
    });
    var user = await MongoConnection()
        .db
        .collection('users')
        .findOne(where.eq('email', request.input('email')));
    if (user != null) {
      if (user['activation_status'] == 'deActivated') {
        Random rnd = Random();
        int otp = rnd.nextInt(999999 - 111111);
        print(otp);
        await Cache.put(request.input('email'), otp.toString(),
            duration: Duration(minutes: 3));
        try {
          VerificationEmail(
                  to: request.input('email'),
                  otp: otp,
                  subject: 'expense Verification code')
              .send();
        } catch (e) {
          print(e);
        }
        return Response.json({
          'message': 'We will send otp to this email if mail exist! send',
        });
      } else {
        return Response.json({
          'message': 'We will send otp to this email if mail exist! not send1'
        });
      }
    } else {
      return Response.json({
        'message': 'We will send otp to this email if mail exist! not send2'
      });
    }
  }

  Future<Response> verifyOtp(Request request) async {
    request.validate({
      'email': 'required|email',
      'otp': 'required',
    }, {
      'email.required': 'The email is required',
      'email.email': 'The email is not valid',
      'otp.required': 'The otp is required',
    });
    Map<String, dynamic>? user = await MongoConnection()
        .db
        .collection('users')
        .findOne(where.eq('email', request.input('email')));
    final String otp = request.input('otp').toString();
    final otpValueInCache = await Cache.get(request.input('email'));
    if (otpValueInCache == null) {
      return Response.json({'message': 'OTP expired'}, 400);
    }
    final otpValue = otpValueInCache.toString();
    if (user == null) {
      return Response.json({'message': 'User not found'});
    }
    if (otpValue == otp) {
      Cache.delete('otp');
      await MongoConnection().db.collection('users').update(
            where.eq('email', request.input('email')),
            modify.set('activation_status', 'activate'),
          );
      return Response.json({'message': 'OTP verified successfully'});
    } else {
      return Response.json(
        {'message': 'Invalid OTP'},
        400,
      );
    }
  }
}

final AuthController authController = AuthController();
