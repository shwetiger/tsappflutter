//@dart=2.9
class NotificationPageObj {
  int id;
  String createdDate;
  String createdDateTimeStr;
  String title;
  int userId;
  String type;
  int refid;
  String content;
  String imageUrl;
  String accountNo;
  int amount;
  String bill;
  int balance;
  String body;
  String bodyValue;
  String category;
  String clickAction;
  String currentdate;
  String currentDateStr;
  String fortime;
  String number;
  String phoneno;
  String requestDate;
  String requestDateStr;
  String sound;
  String state;
  String status;
  String time;
  String transactionNo;
  int odd;
  String guid;
  String messageId;
  String isFirstTopup;
  String percentage;
  String pointWallet;

  NotificationPageObj(
      {this.id,
      this.createdDate,
      this.createdDateTimeStr,
      this.title,
      this.userId,
      this.type,
      this.refid,
      this.content,
      this.imageUrl,
      this.accountNo,
      this.amount,
      this.bill,
      this.balance,
      this.body,
      this.bodyValue,
      this.category,
      this.clickAction,
      this.currentdate,
      this.currentDateStr,
      this.fortime,
      this.number,
      this.phoneno,
      this.requestDate,
      this.requestDateStr,
      this.sound,
      this.state,
      this.status,
      this.time,
      this.transactionNo,
      this.odd,
      this.guid,
      this.messageId,
      this.isFirstTopup,
      this.percentage,
      this.pointWallet});

  NotificationPageObj.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdDate = json['created_date'];
    createdDateTimeStr = json['created_date_time_Str'];
    title = json['title'];
    userId = json['user_id'];
    type = json['type'];
    refid = json['refid'];
    content = json['content'];
    imageUrl = json['imageUrl'];
    accountNo = json['account_no'];
    amount = json['amount'];
    bill = json['bill'];
    balance = json['balance'];
    body = json['body'];
    bodyValue = json['body_value'];
    category = json['category'];
    clickAction = json['click_action'];
    currentdate = json['currentdate'];
    currentDateStr = json['current_date_Str'];
    fortime = json['fortime'];
    number = json['number'];
    phoneno = json['phoneno'];
    requestDate = json['request_date'];
    requestDateStr = json['request_date_Str'];
    sound = json['sound'];
    state = json['state'];
    status = json['status'] == null || json['status'] == "null"
        ? "0"
        : json['status'];
    time = json['time'];
    transactionNo = json['transaction_no'];
    odd = json['odd'];
    guid = json['guid'];
    messageId = json['message_id'];
    isFirstTopup = json['isFirstTopup'];
    percentage = json['percentage'];
    pointWallet = json['pointWallet'];
  }

  Map<String, String> toJson() {
    final Map<String, String> data = new Map<String, String>();
    data['id'] = this.id.toString();
    data['created_date'] = this.createdDate;
    data['created_date_time_Str'] = this.createdDateTimeStr;
    data['title'] = this.title;
    data['user_id'] = this.userId.toString();
    data['type'] = this.type;
    data['refid'] = this.refid.toString();
    data['content'] = this.content;
    data['imageUrl'] = this.imageUrl;
    data['account_no'] = this.accountNo;
    data['amount'] = this.amount.toString();
    data['bill'] = this.bill;
    data['balance'] = this.balance.toString();
    data['body'] = this.body;
    data['body_value'] = this.bodyValue;
    data['category'] = this.category;
    data['click_action'] = this.clickAction;
    data['currentdate'] = this.currentdate;
    data['current_date_Str'] = this.currentDateStr;
    data['fortime'] = this.fortime;
    data['number'] = this.number;
    data['phoneno'] = this.phoneno;
    data['request_date'] = this.requestDate;
    data['request_date_Str'] = this.requestDateStr;
    data['sound'] = this.sound;
    data['state'] = this.state;
    data['status'] = this.status;
    data['time'] = this.time;
    data['transaction_no'] = this.transactionNo;
    data['odd'] = this.odd.toString();
    data['guid'] = this.guid;
    data['message_id'] = this.messageId;
    data['isFirstTopup'] = this.isFirstTopup;
    data['percentage'] = this.percentage;
    data['pointWallet'] = this.pointWallet;
    return data;
  }
}
