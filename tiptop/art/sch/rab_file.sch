/*
================================================================================
檔案代號:rab_file
檔案名稱:一般促销资料单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rab_file
(
rab01       varchar2(10) DEFAULT ' ' NOT NULL, /*制定机构*/
rab02       varchar2(20) DEFAULT ' ' NOT NULL, /*促销单号*/
rab03       varchar2(20) DEFAULT ' ' NOT NULL, /*活动代码*/
rab04       varchar2(1) DEFAULT ' ' NOT NULL, /*是否会员专享*/
rab05       varchar2(1) DEFAULT ' ' NOT NULL, /*是否参与收券*/
rab06       varchar2(1) DEFAULT ' ' NOT NULL, /*是否参加积分*/
rab07       varchar2(1) DEFAULT ' ' NOT NULL, /*是否参加满额促销*/
rab08       varchar2(1) DEFAULT ' ' NOT NULL, /*是否参加返券促销*/
rab09       varchar2(1) DEFAULT ' ' NOT NULL, /*是否参加联盟卡折扣*/
rab10       varchar2(1) DEFAULT ' ' NOT NULL, /*是否参加会员卡折扣*/
rab11       varchar2(255),           /*备注                                   */
rab900      varchar2(1) DEFAULT ' ' NOT NULL, /*状况码 0:开立 1:已核准 9:作废 */
rabacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
rabcond     date,                    /*审核日期                               */
rabconf     varchar2(1) DEFAULT ' ' NOT NULL, /*确认码*/
rabcont     varchar2(8),             /*审核时间                               */
rabconu     varchar2(10),            /*审核人员                               */
rabcrat     date,                    /*资料创建日                             */
rabdate     date,                    /*最近更改日                             */
rabdays     number(5),               /*签核完成天数                           */
rabgrup     varchar2(10),            /*资料所有部门                           */
rablegal    varchar2(10) DEFAULT ' ' NOT NULL, /*法人别*/
rabmksg     varchar2(1) DEFAULT ' ' NOT NULL, /*是否签核*/
rabmodu     varchar2(10),            /*资料更改者                             */
raborig     varchar2(10),            /*资料建立部门                           */
raboriu     varchar2(10),            /*资料建立者                             */
rabplant    varchar2(10) DEFAULT ' ' NOT NULL, /*所属营运中心*/
rabprit     number(5),               /*签核优先等级                           */
rabsign     varchar2(4),             /*签核等级                               */
rabsmax     number(5),               /*应签核顺序                             */
rabsseq     number(5),               /*已签核顺序                             */
rabuser     varchar2(10),            /*资料所有者                             */
rab901      date,                    /*发布日期                               */
rab902      varchar2(8)              /*發佈時間                               */
);

alter table rab_file add  constraint rab_pk primary key  (rab01,rab02,rabplant) enable validate;
grant select on rab_file to tiptopgp;
grant update on rab_file to tiptopgp;
grant delete on rab_file to tiptopgp;
grant insert on rab_file to tiptopgp;
grant index on rab_file to public;
grant select on rab_file to ods;
