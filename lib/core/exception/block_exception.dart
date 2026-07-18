sealed class BlockException implements Exception {}

/// 400 — userId 누락 또는 자기 자신 차단.
class InvalidBlockInputException extends BlockException {}

/// 404 — 차단 대상 유저 없음.
class BlockTargetNotFoundException extends BlockException {}
