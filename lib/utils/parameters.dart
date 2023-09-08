// state parameters

const int IS_DEFAULT_STATE = 2;
const int IS_CORRECT_STATE = 1;
const int IS_ERROR_STATE = 0;
const int IS_ERROR_FORMAT_STATE = 3;

const int IS_PROJECTS_PAGE = 0;
const int IS_PERSONAL_PAGE = 1;
const int IS_NOTIFY_PAGE = 2;
const int IS_EVENT_PAGE = 3;
const int IS_QUEST_PAGE = 4;

const int IS_SUBMIT = 0;
const int IS_DOING = 3;
const int IS_OPENING = 1;
const int IS_CLOSING = 2;

// notification type
const int STAFF_RECIEVE_MISSION = 0;
const int STAFF_COMPLETE_MISSION = 1;
const int MANAGER_APPROVE_PROGRESS = 2;
const int MISSION_IS_DELETED = 3;
const int MISSION_CHANGE_STAFF = 4;
const int MISSION_IS_OPEN = 5;




String manager = "Manager";

String staffRecieveMission({required String nameMission, required String description}) {
  String notify = "Bạn đã nhận được nhiệm vụ \"$nameMission\" với mô tả:\"$description\"";

  return "${notify.substring(0, 50)}...";
}