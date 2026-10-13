/*
================================================================================
檔案代號:gag_file
檔案名稱:流程定义单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table gag_file
(
gag01       varchar2(10) NOT NULL,   /*流程編號                               */
gag02       number(5) NOT NULL,      /*项次                                   */
gag03       varchar2(20),            /*程序编号                               */
gag04       varchar2(1),             /*功能類型                               */
                                     /*功能類型(I.新增 U.更改 D.刪除 Y.審核   */
                                     /*         S.過帳 V.作廢                 */
gag05       varchar2(1),             /*通知設置                               */
                                     /*通知設置(0.不通知 1.即時通知 2.批次通知)*/
gag06       varchar2(250),           /*Mail收件者清單                         */
                                     /*Mail收件者清單 (MIME格式) 依據 gag11   */
gag07       varchar2(250),           /*Mail副本清單                           */
                                     /*Mail副本清單 (MIME格式)                */
gag08       varchar2(255),           /*信息內容                               */
                                     /*信息內容(應該要包含程序編號與功能類型) */
gag09       varchar2(20),            /*建议运行程序编号                       */
gag10       varchar2(1),             /*等級                                   */
                                     /*等級(A.緊急 B.重要 C.一般 D.通知 E.紀錄)*/
gag11       varchar2(80),            /*指定處理人員                           */
                                     /*指定處理人員 (其E-mail寫入gag06)       */
gag12       number(5),               /*处理天数                               */
gag13       varchar2(250),           /*逾期處理時的Mail通知清單               */
                                     /*逾期處理時的Mail通知清單(以分號隔開)   */
gag14       varchar2(1),             /*寄送mail条件                           */
gag15       varchar2(1),             /*建议运行功能                           */
                                     /*Suggest Executing Function (0. Not Assign, 1. Query, 2. Insert)*/
gag16       varchar2(1),             /*No Use                                 */
gag17       varchar2(200)            /*条件内容                               */
);

create unique index gag_02 on gag_file (gag03,gag04,gag14,gag17);
alter table gag_file add  constraint gag_pk primary key  (gag01,gag02) enable validate;
grant select on gag_file to tiptopgp;
grant update on gag_file to tiptopgp;
grant delete on gag_file to tiptopgp;
grant insert on gag_file to tiptopgp;
grant index on gag_file to public;
grant select on gag_file to ods;
