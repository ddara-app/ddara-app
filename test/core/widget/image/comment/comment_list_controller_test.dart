import 'dart:async';

import 'package:ddara/core/widget/image/comment/comment_list_controller.dart';
import 'package:ddara/core/widget/image/comment/photo_comment.dart';
import 'package:flutter_test/flutter_test.dart';

PhotoComment comment(String content, {CommentSendStatus? status}) {
  return PhotoComment(
    nickname: 'me',
    content: content,
    timeLabel: 'now',
    isMine: true,
    sendStatus: status ?? CommentSendStatus.sent,
  );
}

/// 콜백을 전부 기본값(아무것도 하지 않음)으로 채운 컨트롤러.
/// 각 테스트는 검증할 콜백만 넘긴다.
CommentListController buildController({
  List<PhotoComment> initial = const [],
  Future<List<PhotoComment>?> Function()? onLoad,
  Future<PhotoComment?> Function(String content)? onSubmit,
  Future<PhotoComment?> Function(PhotoComment comment, String content)? onEdit,
  Future<bool> Function(PhotoComment comment)? onDelete,
  Future<bool> Function(PhotoComment comment)? onReport,
  Future<bool> Function(PhotoComment comment)? onBlock,
  void Function()? onAdded,
  void Function()? onReloaded,
}) {
  return CommentListController(
    initialComments: initial,
    onLoadComments: onLoad ?? () async => null,
    onSubmitComment: onSubmit ?? (_) async => null,
    onEditComment: onEdit ?? (_, _) async => null,
    onDeleteComment: onDelete ?? (_) async => false,
    onReportComment: onReport ?? (_) async => false,
    onBlockComment: onBlock ?? (_) async => false,
    onCommentAdded: onAdded,
    onListReloaded: onReloaded,
  );
}

void main() {
  group('등록 (낙관적)', () {
    test('전송 즉시 목록에 sending 댓글이 붙고, 성공하면 서버 댓글로 교체된다', () async {
      final gate = Completer<PhotoComment?>();
      final controller = buildController(onSubmit: (_) => gate.future);
      addTearDown(controller.dispose);

      final submitted = controller.submit(
        content: '안녕',
        nickname: 'me',
        profileImageUrl: null,
        justNowLabel: '방금 전',
      );
      // 서버 응답 전 — 이미 목록에 보인다.
      expect(controller.comments, hasLength(1));
      expect(controller.comments.single.sendStatus, CommentSendStatus.sending);
      expect(controller.hasPending, isTrue);

      gate.complete(comment('안녕'));
      await submitted;

      expect(controller.comments, hasLength(1));
      expect(controller.comments.single.sendStatus, CommentSendStatus.sent);
      expect(controller.hasPending, isFalse);
    });

    test('실패(null)하면 failed 로 남아 재전송할 수 있다', () async {
      final controller = buildController(onSubmit: (_) async => null);
      addTearDown(controller.dispose);

      await controller.submit(
        content: '안녕',
        nickname: 'me',
        profileImageUrl: null,
        justNowLabel: '방금 전',
      );

      expect(controller.comments.single.sendStatus, CommentSendStatus.failed);
      expect(controller.hasPending, isTrue);
    });

    test('콜백이 예외를 던져도 failed 로 되돌리고 예외를 그대로 올린다', () async {
      final controller = buildController(
        onSubmit: (_) async => throw StateError('network'),
      );
      addTearDown(controller.dispose);

      await expectLater(
        controller.submit(
          content: '안녕',
          nickname: 'me',
          profileImageUrl: null,
          justNowLabel: '방금 전',
        ),
        throwsStateError,
      );
      expect(controller.comments.single.sendStatus, CommentSendStatus.failed);
    });

    test('임시 댓글은 넘겨받은 작성자·시각 표기를 그대로 쓴다', () async {
      final controller = buildController(onSubmit: (_) async => null);
      addTearDown(controller.dispose);

      await controller.submit(
        content: '안녕',
        nickname: '나',
        profileImageUrl: 'https://example.com/a.png',
        justNowLabel: '방금 전',
      );

      final pending = controller.comments.single;
      expect(pending.nickname, '나');
      expect(pending.timeLabel, '방금 전');
      expect(pending.profileImageUrl, 'https://example.com/a.png');
      expect(pending.isMine, isTrue);
    });

    test('낙관적 댓글이 붙으면 onCommentAdded 가 한 번 불린다', () async {
      var added = 0;
      final controller = buildController(
        onSubmit: (_) async => comment('안녕'),
        onAdded: () => added++,
      );
      addTearDown(controller.dispose);

      await controller.submit(
        content: '안녕',
        nickname: 'me',
        profileImageUrl: null,
        justNowLabel: '방금 전',
      );

      // 서버 응답으로 교체될 때 다시 부르면 스크롤이 두 번 튄다.
      expect(added, 1);
    });
  });

  group('재전송', () {
    test('failed 댓글만 다시 보낸다', () async {
      final failed = comment('안녕', status: CommentSendStatus.failed);
      var calls = 0;
      final controller = buildController(
        initial: [failed],
        onSubmit: (_) async {
          calls++;
          return comment('안녕');
        },
      );
      addTearDown(controller.dispose);

      await controller.retry(failed);
      expect(calls, 1);
      expect(controller.comments.single.sendStatus, CommentSendStatus.sent);
    });

    test('이미 전송 중인 댓글은 무시한다', () async {
      final sending = comment('안녕', status: CommentSendStatus.sending);
      var calls = 0;
      final controller = buildController(
        initial: [sending],
        onSubmit: (_) async {
          calls++;
          return comment('안녕');
        },
      );
      addTearDown(controller.dispose);

      await controller.retry(sending);
      expect(calls, 0);
    });
  });

  group('조회 병합', () {
    test('서버 목록으로 갈아끼우되 아직 서버에 없는 댓글은 뒤에 남긴다', () async {
      final failed = comment('실패한 댓글', status: CommentSendStatus.failed);
      final controller = buildController(
        initial: [comment('옛 댓글'), failed],
        onLoad: () async => [comment('서버1'), comment('서버2')],
      );
      addTearDown(controller.dispose);

      await controller.reload();

      expect(
        controller.comments.map((c) => c.content),
        ['서버1', '서버2', '실패한 댓글'],
      );
      // 참조가 유지돼야 재전송 대상을 그대로 찾을 수 있다.
      expect(identical(controller.comments.last, failed), isTrue);
    });

    test('조회 실패(null)면 기존 목록을 그대로 둔다', () async {
      final controller = buildController(
        initial: [comment('옛 댓글')],
        onLoad: () async => null,
      );
      addTearDown(controller.dispose);

      await controller.reload();

      expect(controller.comments.map((c) => c.content), ['옛 댓글']);
      expect(controller.isLoading, isFalse);
    });

    test('조회 중이면 다시 조회하지 않는다', () async {
      final gate = Completer<List<PhotoComment>?>();
      var calls = 0;
      final controller = buildController(
        onLoad: () {
          calls++;
          return gate.future;
        },
      );
      addTearDown(controller.dispose);

      final first = controller.reload();
      expect(controller.isLoading, isTrue);
      await controller.reload();
      expect(calls, 1);

      gate.complete(const []);
      await first;
    });

    test('목록을 갈아끼우면 세대가 오르고 onListReloaded 가 불린다', () async {
      var reloaded = 0;
      final controller = buildController(
        onLoad: () async => [comment('서버1')],
        onReloaded: () => reloaded++,
      );
      addTearDown(controller.dispose);

      final before = controller.generation;
      await controller.reload();

      expect(controller.generation, before + 1);
      expect(reloaded, 1);
    });
  });

  group('수정·삭제·신고·차단', () {
    test('수정에 성공하면 목록을 갱신하고 true 를 돌려준다', () async {
      final target = comment('원본');
      final controller = buildController(
        initial: [target],
        onEdit: (_, content) async =>
            target.copyWith(content: content, isEdited: true),
      );
      addTearDown(controller.dispose);

      expect(await controller.applyEdit(target, '고침'), isTrue);
      expect(controller.comments.single.content, '고침');
      expect(controller.comments.single.isEdited, isTrue);
    });

    test('수정에 실패하면 false 를 돌려주고 목록을 건드리지 않는다', () async {
      final target = comment('원본');
      final controller = buildController(
        initial: [target],
        onEdit: (_, _) async => null,
      );
      addTearDown(controller.dispose);

      expect(await controller.applyEdit(target, '고침'), isFalse);
      expect(controller.comments.single.content, '원본');
    });

    test('수정 요청 중에는 다음 수정을 막는다', () async {
      final gate = Completer<PhotoComment?>();
      final target = comment('원본');
      var calls = 0;
      final controller = buildController(
        initial: [target],
        onEdit: (_, _) {
          calls++;
          return gate.future;
        },
      );
      addTearDown(controller.dispose);

      final first = controller.applyEdit(target, '고침');
      expect(await controller.applyEdit(target, '또 고침'), isFalse);
      expect(calls, 1);

      gate.complete(null);
      await first;
    });

    test('수정 콜백이 예외를 던져도 가드가 풀려 다음 수정이 막히지 않는다', () async {
      final target = comment('원본');
      var calls = 0;
      final controller = buildController(
        initial: [target],
        onEdit: (_, _) async {
          calls++;
          throw StateError('network');
        },
      );
      addTearDown(controller.dispose);

      await expectLater(controller.applyEdit(target, '고침'), throwsStateError);
      await expectLater(controller.applyEdit(target, '고침'), throwsStateError);
      expect(calls, 2);
    });

    test('삭제·신고는 성공했을 때만 목록에서 뺀다', () async {
      final target = comment('대상');
      final rejecting = buildController(initial: [target]);
      addTearDown(rejecting.dispose);

      await rejecting.delete(target);
      await rejecting.report(target);
      expect(rejecting.comments, hasLength(1));

      final accepting = buildController(
        initial: [target],
        onDelete: (_) async => true,
      );
      addTearDown(accepting.dispose);

      await accepting.delete(target);
      expect(accepting.comments, isEmpty);
    });

    test('전송 실패 댓글 치우기는 API 를 부르지 않고 목록에서만 뺀다', () {
      final failed = comment('실패', status: CommentSendStatus.failed);
      var deleteCalls = 0;
      final controller = buildController(
        initial: [failed],
        onDelete: (_) async {
          deleteCalls++;
          return true;
        },
      );
      addTearDown(controller.dispose);

      controller.discard(failed);

      expect(controller.comments, isEmpty);
      expect(deleteCalls, 0);
    });

    test('차단에 성공하면 목록을 재조회한다', () async {
      final target = comment('대상');
      var loads = 0;
      final controller = buildController(
        initial: [target],
        onBlock: (_) async => true,
        onLoad: () async {
          loads++;
          return const [];
        },
      );
      addTearDown(controller.dispose);

      await controller.block(target);

      expect(loads, 1);
      expect(controller.comments, isEmpty);
    });

    test('차단에 실패하면 재조회하지 않는다', () async {
      final target = comment('대상');
      var loads = 0;
      final controller = buildController(
        initial: [target],
        onBlock: (_) async => false,
        onLoad: () async {
          loads++;
          return const [];
        },
      );
      addTearDown(controller.dispose);

      await controller.block(target);

      expect(loads, 0);
      expect(controller.comments, hasLength(1));
    });
  });
}
