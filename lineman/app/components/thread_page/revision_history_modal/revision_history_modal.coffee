angular.module('loomioApp').factory 'RevisionHistoryModal', ->
  templateUrl: 'generated/components/thread_page/revision_history_modal/revision_history_modal.html'
  controller: ($scope, discussion, CurrentUser, Records) ->
    $scope.discussion = discussion
    
    Records.versions.fetchByDiscussion($scope.discussion.key)

    $scope.threadTitle = (version) ->
      $scope.discussion.attributeForVersion('title', version)

    $scope.threadDescription = (version) ->
      $scope.discussion.attributeForVersion('description', version)

    $scope.versionIsCurrent = (version) ->
      version.id == _.max(_.pluck($scope.discussion.versions(), 'id'))

    $scope.versionIsOriginal = (version) ->
      version.id == _.min(_.pluck($scope.discussion.versions(), 'id'))

    return