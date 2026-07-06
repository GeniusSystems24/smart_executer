import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smart_executer/smart_executer.dart';
import 'package:smart_executer_example/features/scenarios/user_list/domain/entities/demo_user.dart';
import 'package:smart_executer_example/shared/application/contracts/demo_http_client.dart';
import 'package:smart_executer_example/shared/domain/models/demo_http_response.dart';
import 'package:smart_pagination/pagination.dart';

/// Coordinates the user-list scenario without owning any widgets.
final class UserListController {
  UserListController({required DemoHttpClient client}) : _client = client {
    paginationCubit = SmartPaginationCubit<DemoUser>(
      request: PaginationRequest(page: 1, pageSize: 10),
      provider: PaginationProvider.future(_fetchUsers),
    );
  }

  final DemoHttpClient _client;
  late final SmartPaginationCubit<DemoUser> paginationCubit;

  Future<List<DemoUser>> _fetchUsers(PaginationRequest request) async {
    final result = await SmartExecuter.execute<DemoHttpResponse<dynamic>>(
      () => _client.get(
        '/users',
        queryParameters: {
          '_page': request.page,
          '_limit': request.pageSize,
        },
      ),
    );

    return result.fold(
      onSuccess: (response) => (response.data as List<dynamic>)
          .map((json) => DemoUser.fromJson(json as Map<String, dynamic>))
          .toList(growable: false),
      onFailure: (exception) => throw exception,
    );
  }

  Future<bool> deleteUser(BuildContext context, DemoUser user) async {
    var succeeded = false;
    await SmartExecuter.run<DemoHttpResponse<dynamic>>(
      request: () => _client.delete('/users/${user.id}'),
      context: context,
      options: ExecuterOptions(
        operationName: 'deleteUser',
        metadata: {'userId': user.id, 'userName': user.name},
      ),
      onSuccess: (_) async {
        paginationCubit.removeWhereEmit((item) => item.id == user.id);
        succeeded = true;
      },
    );
    return succeeded;
  }

  Future<bool> refreshUser(BuildContext context, DemoUser user) async {
    final response = await SmartExecuter.run<DemoHttpResponse<dynamic>>(
      request: () => _client.get('/users/${user.id}'),
      context: context,
      options: ExecuterOptions(
        operationName: 'refreshUser',
        metadata: {'userId': user.id},
      ),
    );

    if (response == null) return false;
    final updatedUser = DemoUser.fromJson(
      response.data as Map<String, dynamic>,
    );
    paginationCubit.updateWhereEmit(
      (item) => item.id == user.id,
      (_) => updatedUser,
    );
    return true;
  }

  void dispose() {
    unawaited(paginationCubit.close());
  }
}
