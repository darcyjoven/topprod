/*
================================================================================
檔案代號:aza_file
檔案名稱:整体管理系统参数档
檔案目的:
上游檔案:
下游檔案:
檔案類型:P
多語系檔案:N
============.========================.==========================================
*/
create table aza_file
(
aza01       varchar2(1) NOT NULL,    /*KEY VALUE (0)                          */
aza02       varchar2(1),             /*会计期间                               */
                                     /*會計期間: 1.12 /2.13                   */
aza03       varchar2(1),             /*多营运中心环境                         */
                                     /*多工廠環境: (Y/N)                      */
aza04       varchar2(1),             /*多币种                                 */
                                     /*多幣別: (Y/N)                          */
aza05       varchar2(1),             /*是否使用制造管理系统                   */
                                     /*是否使用製造管理系統: (Y/N)            */
aza06       varchar2(1),             /*是否使用总帐管理系统                   */
                                     /*是否使用總帳管理系統: (Y/N)            */
aza07       varchar2(1),             /*是否使用应收帐款管理系统               */
                                     /*是否使用應收帳款管理系統: (Y/N)        */
aza08       varchar2(1),             /*是否使用项目管理系统                   */
                                     /*是否使用專案管理系統: (Y/N)            */
aza09       varchar2(1),             /*有LOTUS NOTES                          */
                                     /*No use                                 */
aza10       varchar2(1),             /*是否使用售后服务分析:                  */
                                     /*是否使用售後服務分析: (Y/N)            */
aza11       varchar2(1),             /*是否使用条码管理                       */
                                     /*是否使用條碼管理: (Y/N)                */
aza12       varchar2(1),             /*是否使用应付帐款管理系统               */
                                     /*是否使用應付帳款管理系統: (Y/N)        */
aza13       varchar2(1),             /*是否使用决策支持管理系统               */
                                     /*是否使用決策支援管理系統: (Y/N)        */
aza14       varchar2(1),             /*是否使用财务规划系统                   */
                                     /*是否使用財務規劃系統: (Y/N)            */
aza15       varchar2(1),             /*是否使用质量管理系统                   */
                                     /*是否使用品質管理系統: (Y/N)            */
aza16       varchar2(1),             /*是否使用固定资产管理系统               */
                                     /*是否使用固定資產管理系統: (Y/N)        */
aza17       varchar2(4),             /*记账本位币                             */
                                     /*本國幣別(NT$)                          */
aza18       varchar2(1),             /*程序运行时间记录方式                   */
                                     /*程式執行時間記錄方式                   */
                                     /* 1. 不記錄                             */
                                     /* 2. 每次詳細記錄                       */
                                     /* 3. 每天彙總記錄                       */
                                     /* 4. 每月彙總記錄                       */
aza19       varchar2(1),             /*汇率采用                               */
                                     /*匯率採用(1)月平均匯率(2)每日匯率       */
aza20       varchar2(1),             /*当前整体管理系统是否可放给             */
                                     /*目前整體管理系統是否可放給使用者使用   */
                                     /*正確值 'Y' OR 'N'                      */
                                     /*Y: 正常使用                            */
                                     /*N: 僅供使用者列印查詢                  */
                                     /*   不可作檔案的新增,修改,查詢,刪除     */
aza21       varchar2(1),             /*是否以逻辑方式检查营利事业             */
                                     /*是否以邏輯方式檢查營利事業統一編號(Y/N)*/
aza22       varchar2(1),             /*是否隐藏无权限的功能按键               */
                                     /*No Use                                 */
aza23       varchar2(1),             /*签核流程是否与EasyFlow串联             */
                                     /*簽核流程是否與EasyFlow串聯             */
aza24       varchar2(1),             /*报表输出至PDF-Logo位置                 */
                                     /*'1':Left                               */
                                     /*'2':Right                              */
aza25       varchar2(1),             /*是否使用防伪税控接口系统               */
                                     /*是否使用防偽稅控接口系統(Y/N) for 大陸版*/
aza26       varchar2(1),             /*使用功能别                             */
                                     /*0':ROC                                 */
                                     /*'1':The West                           */
                                     /*'2':China                              */
aza27       varchar2(1),             /*是否使用海关合约系统                   */
                                     /*是否使用海關合同系統(Y/N)  #No.A047    */
aza28       varchar2(1),             /*料件编号自动编码否                     */
                                     /*料件編號自動編碼否(Y/N)        #No.A086*/
aza29       varchar2(1),             /*客户编号自动编码否                     */
                                     /*客戶編號自動編碼否(Y/N)        #No.A086*/
aza30       varchar2(1),             /*供应商编号自动编码否                   */
                                     /*供應商編號自動編碼否(Y/N)      #No.A086*/
aza31       varchar2(1),             /*固定资产编号自动编码否                 */
                                     /*固定資產編號自動編碼否(Y/N)    #No.A086*/
aza32       varchar2(1),             /*是否显示除错信息                       */
                                     /*是否顯示除錯訊息(Y/N)          #No.8996*/
aza33       number(10),              /*闲置时间几秒                           */
                                     /*閒置時間幾秒                   #No.8996*/
aza34       number(10),              /*最大单身笔数                           */
                                     /*單身最大筆數設定               #No.7862*/
aza35       varchar2(1),             /*启动闲置处理                           */
                                     /*是否使用閒置設定                       */
aza36       varchar2(1),             /*闲置用户处理方式                       */
                                     /*超過閒置時間的處理方式                 */
                                     /* 1:只警告                              */
                                     /* 2:警告後強制結束作業                  */
aza37       number(10),              /*警告信息停留秒数                       */
                                     /*警告訊息停留秒數                       */
aza38       number(5),               /*最大动态开窗查询笔数                   */
                                     /*No Use                                 */
aza39       varchar2(1),             /*是否允许用户隐藏单身字段               */
aza40       varchar2(1),             /*是否使用集团间销售预测                 */
                                     /*是否使用集團間銷售預測                 */
azauser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
azagrup     varchar2(10),            /*资料所有群                             */
                                     /*資料所有群                             */
azamodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
azadate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
aza41       varchar2(1),             /*单别位数设置(全系統)                   */
aza42       varchar2(1),             /*单号位数设置(全系統）                  */
aza43       varchar2(1),             /*金额字段格式                           */
aza44       varchar2(1),             /*使用多语言功能                         */
aza45       varchar2(1),             /*缺省语言别                             */
aza46       varchar2(1),             /*是否使用进项防伪税控接口系             */
aza47       varchar2(1),             /*是否使用销项防伪税控接口系             */
aza48       varchar2(1),             /*使用国家会计标准                       */
aza49       varchar2(1),             /*No Use                                 */
aza50       varchar2(1),             /*是否使用流通配销功能                   */
aza51       varchar2(1),             /*是否使用集团帐务中心                   */
aza52       varchar2(1),             /*应收系统                               */
aza53       varchar2(1),             /*应付系统                               */
aza54       number(5) DEFAULT '0',   /*每一单据相关文件最大笔数               */
aza55       number(10) DEFAULT '0',  /*相关文件单一夹档允许最大 siz           */
aza56       varchar2(1),             /*Excel开启方式                          */
                                     /*'1':IE Plugin Excel                    */
                                     /*'2':Client Excel                       */
aza57       varchar2(1),             /*报表输出与Express集成                  */
aza58       varchar2(255),           /*TIPTOP 主机内部IP                      */
aza59       varchar2(255),           /*TIPTOP 主机外部IP                      */
aza60       varchar2(1),             /*使用料件申请作业                       */
aza61       varchar2(1),             /*使用客户申请作业                       */
aza62       varchar2(1),             /*使用厂商申请作业                       */
aza63       varchar2(1),             /*使用多帐套功能                         */
aza64       varchar2(1),             /*质量控制系统是否与SPC集成              */
aza65       varchar2(1),             /*与SPC集成时,QC单是否自动审核           */
aza66       varchar2(1),             /*报表打印资料超过缺省字段长             */
aza67       varchar2(1) DEFAULT 'n', /*待办事项与Production Portal集成        */
aza68       varchar2(255),           /*Production Portal SOAP服务网址         */
aza69       varchar2(1),             /*集团代收                               */
                                     /*FOR內部帳戶                            */
aza70       varchar2(1),             /*集团代付                               */
                                     /*FOR內部帳戶                            */
aza71       varchar2(1),             /*是否与GPM集成                          */
aza72       varchar2(1),             /*是否与EasyFlowGP集成('Y':是, 'N':      */
aza81       varchar2(5),             /*主财务帐套                             */
aza82       varchar2(5),             /*主管理帐套                             */
aza75       varchar2(1),             /*是否与eB-Online集成                    */
aza76       varchar2(30),            /*eB-Online DB Name                      */
aza73       varchar2(1) DEFAULT 'N' NOT NULL, /*使用网络银行*/
aza74       varchar2(10),            /*招商银行接口银行编码                   */
aza77       varchar2(1),             /*当与eB-Online集成时,单据是否间         */
aza83       number(5) DEFAULT '0' NOT NULL, /*使用执行process的最大数*/
aza84       number(5) DEFAULT '5',   /*限制报表执行的session数                */
aza85       varchar2(1),             /*是否与 MDM 整合                        */
aza86       varchar2(255),           /*MDM SOAP 服务网址                      */
aza78       varchar2(10),            /*汇丰银行接口银行编码                   */
aza90       varchar2(1),             /*是否与MES整合                          */
aza91       varchar2(1) DEFAULT 'd', /*Production Portal                      */
aza92       varchar2(1) DEFAULT 'N' NOT NULL, /*使用料件承认申请单*/
aza93       varchar2(1) DEFAULT 'N' NOT NULL, /*使用CR报表资料功能*/
aza88       varchar2(1) DEFAULT 'N' NOT NULL,
aza89       varchar2(1) DEFAULT 'Y', /*No Use                                 */
aza94       varchar2(1) DEFAULT 'N' NOT NULL, /*总机构汇总报缴*/
azaorig     varchar2(10),            /*资料建立部门                           */
azaoriu     varchar2(10),            /*资料建立者                             */
aza95       varchar2(1) DEFAULT 'N' NOT NULL,
aza96       varchar2(1) DEFAULT 'N', /*当与MES整合时,退料单是否从MES          */
aza100      number(5) DEFAULT '0',
aza101      varchar2(1) DEFAULT 'N' NOT NULL,
aza102      varchar2(1) DEFAULT 'N' NOT NULL,
aza103      varchar2(1) DEFAULT 'N' NOT NULL,
aza104      varchar2(1) DEFAULT 'N' NOT NULL,
aza97       varchar2(1) DEFAULT 'N' NOT NULL,
aza98       number(5) DEFAULT '0',
aza99       varchar2(1) DEFAULT 'N' NOT NULL,
aza107      varchar2(1) DEFAULT 'N' NOT NULL, /*　*/
aza108      varchar2(5),             /*　                                     */
aza123      varchar2(1) DEFAULT 'N' NOT NULL, /*是否與CRM整合*/
aza109      varchar2(1) DEFAULT 'N' NOT NULL, /*流通会员编号自动编码*/
aza121      varchar2(1) DEFAULT 'N' NOT NULL, /*是否与PLM整合*/
aza122      varchar2(1) DEFAULT '1' NOT NULL, /*PLM整合产品别*/
azaud01     varchar2(255),           /*自订字段                               */
azaud02     varchar2(40),            /*自订字段                               */
azaud03     varchar2(40),            /*自订字段                               */
azaud04     varchar2(40),            /*自订字段                               */
azaud05     varchar2(40),            /*自订字段                               */
azaud06     varchar2(255),           /*自订字段                               */
azaud07     number(15,3),            /*自订字段                               */
azaud08     number(15,3),            /*自订字段                               */
azaud09     number(15,3),            /*自订字段                               */
azaud10     number(10),              /*自订字段                               */
azaud11     number(10),              /*自订字段                               */
azaud12     number(10),              /*自订字段                               */
azaud13     date,                    /*自订字段                               */
azaud14     date,                    /*自订字段                               */
azaud15     date,                    /*自订字段                               */
aza110      varchar2(1) DEFAULT 'N' NOT NULL, /*场地编号自动编码*/
aza111      varchar2(1) DEFAULT 'N' NOT NULL, /*摊位编号自动编码*/
aza112      varchar2(1) DEFAULT 'N' NOT NULL, /*商户编号自动编码*/
aza113      varchar2(1) DEFAULT 'Y' NOT NULL, /*使用商户预登记*/
aza124      varchar2(1) DEFAULT 'Y' NOT NULL, /*报表TITLE是否呈现营运中心*/
aza125      varchar2(1) DEFAULT 'N' NOT NULL, /*客户厂商简称保持一致*/
aza126      varchar2(1) DEFAULT 'N' NOT NULL, /*客户厂商简称修改是否更新历 */
aza105      varchar2(1) DEFAULT ' ' NOT NULL, /*单号位数设定(盘点单编码)*/
aza106      varchar2(1) DEFAULT ' ' NOT NULL, /*自动编号方式(盘点单编码)*/
aza127      varchar2(1) DEFAULT 'N' NOT NULL,
aza128      varchar2(10),
aza115      varchar2(1) DEFAULT ' ' NOT NULL, /*库存单据理由码必输*/
aza131      varchar2(1) DEFAULT 'N' NOT NULL, /*是否与M-Barcode整合*/
aza132      varchar2(1) DEFAULT 'N' NOT NULL /*是否整合家俱业功能*/
);

alter table aza_file add  constraint aza_pk primary key  (aza01) enable validate;
grant select on aza_file to tiptopgp;
grant update on aza_file to tiptopgp;
grant delete on aza_file to tiptopgp;
grant insert on aza_file to tiptopgp;
grant index on aza_file to public;
grant select on aza_file to ods;
