import 'package:flutter/material.dart';

import '../../../../core/carbon.dart';

/// Static data used by the workspace collections panel.
abstract final class WorkspaceCollectionsConfig {
  static const branchIcons = <String, IconData>{
    'collections': CIcons.folder,
    'environments': CIcons.globe,
    'documents': CIcons.document,
    'specs': CIcons.code,
    'mocks': CIcons.modelAlt,
    'flows': CIcons.flow,
    'mock-servers': CIcons.dataBase,
    'monitors': CIcons.chartLine,
    'webhooks': CIcons.events,
    'insights': CIcons.chartNetwork,
    'deployed-flows': CIcons.flow,
  };

  static IconData branchIcon(String id) => branchIcons[id] ?? CIcons.folder;

  static const serviceBranches = [
    'Mock servers',
    'Monitors',
    'Webhooks',
    'Insights',
    'Deployed flows',
  ];

  static const requestTypes = <String>{
    'HTTP',
    'GraphQL',
    'AI',
    'MCP',
    'gRPC',
    'WebSocket',
    'Socket.IO',
    'MQTT',
    'Data',
    'Kafka',
  };

  static const addOptions = [
    'Search...',
    'Ask AI',
    'HTTP',
    'GraphQL',
    'AI',
    'MCP',
    'gRPC',
    'WebSocket',
    'Socket.IO',
    'MQTT',
    'Data',
    'Kafka',
    'Collection',
    'Environment',
    'Document',
    'Spec',
    'Mock',
    'Mock Server',
    'Monitor',
    'Webhook',
    'Flow',
    'Dataset',
    'AI Toolset',
  ];

  static const resourceSections = ['Documents', 'Specs', 'Mocks', 'Flows'];
}
