List<Map<String, dynamic>> groupCommentsByParentId(List<dynamic> comments) {
  final groupedComments = <String, Map<String, dynamic>>{};
  final parentComments = <int, Map<String, dynamic>>{}; // Map to store parent comments by ID

  for (final comment in comments) {
    final parentId = comment['parent_comment']; // Use comment ID if parent_comment is null

    // Check if the comment is a parent comment
    final isParentComment = parentId == null;

    // Add the comment to the appropriate group
    if (isParentComment) {
      // Add parent comment data to the map if it's not already present
      if (!groupedComments.containsKey(comment['id'].toString())) {
        groupedComments[comment['id'].toString()] = {
          'parent_id': comment['id'],
          'parent_user': comment['user'],
          'parent_content': comment['content'],
          'parent_date': comment['created_at'],
          'parent_post': comment['post'],
          'parent_comment': comment['parent_comment'],
          'comment_likes': comment['comment_like'],
          'children': <Map<String, dynamic>>[], // Initialize children list
        };
      }
    } else {
      // Add the comment as a child to its parent
      if (parentComments.containsKey(parentId)) {
        parentComments[parentId]!['children'].add({
          'id': comment['id'],
          'user': comment['user'],
          'content': comment['content'],
          'created_at': comment['created_at'],
          'post': comment['post'],
          'parent_comment': comment['parent_comment'],
          'comment_likes': comment['comment_like'],
          // Include other relevant comment data here
        });
      }
    }

    // Store parent comment data for future reference
    if (isParentComment) {
      parentComments[comment['id']] = groupedComments[comment['id'].toString()]!;
    }
  }

  return groupedComments.values.toList();
}
