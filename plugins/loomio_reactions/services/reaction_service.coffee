angular.module('loomioApp').factory 'ReactionService', ->
  new class ReactionService
    updateCommentReactions: (comment, data) ->
      return unless data.comment_id == comment.id
      reactions = comment.discussion().reactions
      reactions[comment.id] = data.reactions
      comment.discussion().update(reactions: reactions)
