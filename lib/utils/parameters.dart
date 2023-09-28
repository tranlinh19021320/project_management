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
const int IS_REPORT_PAGE = 5;

const int IS_SUBMIT = 0;
const int IS_DOING = 1;
const int IS_CLOSING = 2;
const int IS_COMPLETE = 3;
const int IS_LATE = 4;

// notification type
const int STAFF_RECIEVE_MISSION = 0;
const int STAFF_COMPLETE_MISSION = 1;
const int MANAGER_APPROVE_PROGRESS = 2;
const int MISSION_IS_DELETED = 3;
const int STAFF_RECIEVE_MISSION_FROM_OTHER = 4;
const int MISSION_CHANGE_STAFF = 6;
const int MISSION_IS_OPEN = 5;
const int MISSION_IS_CHANGED = 7;
const int TIME_KEEPING = 8;
// report type
const int UPDATE_REPORT = 9;
const int BUG_REPORT = 10;
const int PRIVATE_REPORT = 11;

String manager = "Manager";

String staffRecieveMission({required String nameMission, required String description}) {
  String notify = "Bạn đã nhận được nhiệm vụ \"$nameMission\" với mô tả:\"$description\"";

  return "${notify.substring(0, 50)}...";
}