import 'package:flutter/material.dart';

import '../../../core/carbon.dart';

/// Sections exposed by the workspace activity rail.
enum WorkspaceSidebarSection { collections, history, environments }

enum WorkspaceAuthType {
  oauth2,
  apiKey,
  basicAuth,
  bearerToken,
  digestAuth,
  hawkAuthentication,
  jwtBearer,
  oauth1,
  akamaiEdgegrid,
  asap,
  awsSignature,
  ntlmAuthentication,
  none,
}

extension WorkspaceAuthTypeX on WorkspaceAuthType {
  String get label => switch (this) {
    WorkspaceAuthType.oauth2 => 'OAuth 2.0',
    WorkspaceAuthType.apiKey => 'API Key',
    WorkspaceAuthType.basicAuth => 'Basic Auth',
    WorkspaceAuthType.bearerToken => 'Bearer Token',
    WorkspaceAuthType.digestAuth => 'Digest Auth',
    WorkspaceAuthType.hawkAuthentication => 'Hawk Authentication',
    WorkspaceAuthType.jwtBearer => 'JWT Bearer',
    WorkspaceAuthType.oauth1 => 'OAuth 1.0',
    WorkspaceAuthType.akamaiEdgegrid => 'Akamai EdgeGrid',
    WorkspaceAuthType.asap => 'ASAP (Atlassian)',
    WorkspaceAuthType.awsSignature => 'AWS Signature',
    WorkspaceAuthType.ntlmAuthentication => 'NTLM Authentication',
    WorkspaceAuthType.none => 'No Auth',
  };
}

enum WorkspaceBodyType { none, json }

@immutable
class WorkspaceKeyValue {
  const WorkspaceKeyValue({
    required this.key,
    required this.value,
    this.enabled = true,
  });

  final String key;
  final String value;
  final bool enabled;

  WorkspaceKeyValue copyWith({String? key, String? value, bool? enabled}) {
    return WorkspaceKeyValue(
      key: key ?? this.key,
      value: value ?? this.value,
      enabled: enabled ?? this.enabled,
    );
  }
}

@immutable
class WorkspaceRequest {
  const WorkspaceRequest({
    required this.id,
    required this.name,
    required this.method,
    required this.url,
    this.queryParams = const [],
    this.headers = const [],
    this.authType = WorkspaceAuthType.none,
    this.bearerToken = '',
    this.bodyType = WorkspaceBodyType.none,
    this.rawBody = '',
  });

  final String id;
  final String name;
  final String method;
  final String url;
  final List<WorkspaceKeyValue> queryParams;
  final List<WorkspaceKeyValue> headers;
  final WorkspaceAuthType authType;
  final String bearerToken;
  final WorkspaceBodyType bodyType;
  final String rawBody;

  WorkspaceRequest copyWith({
    String? id,
    String? name,
    String? method,
    String? url,
    List<WorkspaceKeyValue>? queryParams,
    List<WorkspaceKeyValue>? headers,
    WorkspaceAuthType? authType,
    String? bearerToken,
    WorkspaceBodyType? bodyType,
    String? rawBody,
  }) {
    return WorkspaceRequest(
      id: id ?? this.id,
      name: name ?? this.name,
      method: method ?? this.method,
      url: url ?? this.url,
      queryParams: queryParams ?? this.queryParams,
      headers: headers ?? this.headers,
      authType: authType ?? this.authType,
      bearerToken: bearerToken ?? this.bearerToken,
      bodyType: bodyType ?? this.bodyType,
      rawBody: rawBody ?? this.rawBody,
    );
  }
}

@immutable
class WorkspaceCollection {
  const WorkspaceCollection({required this.name, required this.requests});

  final String name;
  final List<WorkspaceRequest> requests;
}

@immutable
class WorkspaceEnvironment {
  const WorkspaceEnvironment({required this.name, required this.variables});

  final String name;
  final int variables;
}

@immutable
class WorkspaceResponse {
  const WorkspaceResponse({
    required this.statusCode,
    required this.statusMessage,
    required this.timeMs,
    required this.size,
    required this.body,
    required this.headers,
  });

  final int statusCode;
  final String statusMessage;
  final int timeMs;
  final String size;
  final String body;
  final Map<String, String> headers;

  String get statusLabel => '$statusCode $statusMessage';
}

Color workspaceMethodColor(String method, AppThemeTokens tokens) {
  return switch (method.toUpperCase()) {
    'GET' => tokens.supportSuccess,
    'POST' => tokens.supportWarning,
    'PUT' => tokens.supportInfo,
    'DELETE' => tokens.supportError,
    'PATCH' => tokens.linkPrimary,
    _ => tokens.textSecondary,
  };
}

Color workspaceStatusColor(int statusCode, AppThemeTokens tokens) {
  if (statusCode >= 200 && statusCode < 300) return tokens.supportSuccess;
  if (statusCode >= 300 && statusCode < 400) return tokens.supportInfo;
  if (statusCode >= 400 && statusCode < 500) return tokens.supportWarning;
  return tokens.supportError;
}

List<WorkspaceRequest> workspaceSeedRequests() {
  return [
    WorkspaceRequest(
      id: 'req-get-users',
      name: 'Get Users List',
      method: 'GET',
      url: 'https://jsonplaceholder.typicode.com/users',
      authType: WorkspaceAuthType.akamaiEdgegrid,
      queryParams: const [
        WorkspaceKeyValue(key: 'page', value: '1'),
        WorkspaceKeyValue(key: 'limit', value: '10'),
      ],
      headers: const [
        WorkspaceKeyValue(key: 'Accept', value: 'application/json'),
        WorkspaceKeyValue(key: 'Cache-Control', value: 'no-cache'),
      ],
    ),
    WorkspaceRequest(
      id: 'req-create-user',
      name: 'Create User',
      method: 'POST',
      url: 'https://jsonplaceholder.typicode.com/users',
      bodyType: WorkspaceBodyType.json,
      rawBody: '{\n  "name": "Jane Doe",\n  "username": "jdoe"\n}',
    ),
    WorkspaceRequest(
      id: 'req-get-posts',
      name: 'Get Posts',
      method: 'GET',
      url: 'https://jsonplaceholder.typicode.com/posts',
    ),
    WorkspaceRequest(
      id: 'req-delete-post',
      name: 'Delete Post',
      method: 'DELETE',
      url: 'https://jsonplaceholder.typicode.com/posts/1',
    ),
  ];
}

WorkspaceRequest workspaceVaultAuthRequest() {
  return const WorkspaceRequest(
    id: 'hist-vault-auth',
    name: 'Vault Auth',
    method: 'POST',
    url: 'http://127.0.0.1:10534/oauth/token',
  );
}

List<WorkspaceCollection> workspaceSeedCollections(
  List<WorkspaceRequest> requests,
) {
  return [WorkspaceCollection(name: 'Core Services API', requests: requests)];
}

List<WorkspaceEnvironment> workspaceSeedEnvironments() {
  return const [
    WorkspaceEnvironment(name: 'Production', variables: 2),
    WorkspaceEnvironment(name: 'Staging', variables: 1),
  ];
}

WorkspaceResponse workspaceSampleResponse() {
  return const WorkspaceResponse(
    statusCode: 200,
    statusMessage: 'OK',
    timeMs: 142,
    size: '1.8 KB',
    body:
        '[\n'
        '  {\n'
        '    "id": 1,\n'
        '    "name": "Leanne Graham",\n'
        '    "username": "Bret",\n'
        '    "email": "Sincere@april.biz"\n'
        '  },\n'
        '  {\n'
        '    "id": 2,\n'
        '    "name": "Ervin Howell",\n'
        '    "username": "Antonette",\n'
        '    "email": "Shanna@melissa.tv"\n'
        '  }\n'
        ']',
    headers: {
      'content-type': 'application/json; charset=utf-8',
      'server': 'cloudflare',
      'x-powered-by': 'Express',
    },
  );
}
