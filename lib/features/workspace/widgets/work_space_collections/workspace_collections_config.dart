/// Static data used by the workspace collections panel.
abstract final class WorkspaceCollectionsConfig {
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
    'Ask AI (Ctrl+Alt+P)',
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
