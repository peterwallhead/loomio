angular.module('loomioApp').factory 'RevisionHistoryModal', ->
  templateUrl: 'generated/components/thread_page/revision_history_modal/revision_history_modal.html'
  controller: ($scope, model, CurrentUser, Records) ->
    $scope.model = model

    switch $scope.model.constructor.singular
      when 'discussion' then Records.versions.fetchByDiscussion($scope.model.key)
      when 'comment'    then Records.versions.fetchByComment($scope.model)

    $scope.header =
      switch $scope.model.constructor.singular
        when 'discussion' then 'revision_history_modal.thread_header'
        when 'comment'    then 'revision_history_modal.comment_header'

    $scope.discussionRevision = ->
      $scope.model.constructor.singular == 'discussion'

    $scope.commentRevision = ->
      $scope.model.constructor.singular == 'comment'

    $scope.threadTitle = (version) ->
      $scope.model.attributeForVersion('title', version)

    $scope.revisionBody = (version) ->
      switch $scope.model.constructor.singular
        when 'discussion' then $scope.model.attributeForVersion('description', version)
        when 'comment'    then $scope.model.attributeForVersion('body', version)

    $scope.threadDetails = (version) ->
      if $scope.versionIsOriginal(version)
        'revision_history_modal.started_by'
      else
        'revision_history_modal.edited_by'

    $scope.versionCreatedAt = (version) ->
      moment(version).format('Do MMMM YYYY, h:mma')

    $scope.versionIsCurrent = (version) ->
      version.id == _.max(_.pluck($scope.model.versions(), 'id'))

    $scope.versionIsOriginal = (version) ->
      version.id == _.min(_.pluck($scope.model.versions(), 'id'))

    return