/*
================================================================================
檔案代號:ads_file
檔案名稱:客戶庫存調整單頭檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ads_file
(
ads01       varchar2(20) NOT NULL,   /*库存调整档                             */
ads02       date,                    /*异动日期                               */
ads03       varchar2(10),            /*客户编号                               */
ads04       varchar2(10),            /*员工编号                               */
ads05       varchar2(10),            /*部门编号                               */
ads06       varchar2(255),           /*备注                                   */
ads07       varchar2(1),             /*状况码                                 */
adsmksg     varchar2(1),             /*是否签核                               */
adssign     varchar2(4),             /*签核等级                               */
adsdays     number(5),               /*签核完成天数                           */
adsprit     number(5),               /*签核有先等级                           */
adssseq     number(5),               /*已签核顺序                             */
adssmax     number(5),               /*应签核顺序                             */
adsconf     varchar2(1),             /*审核                                   */
adspost     varchar2(1),             /*过帐否                                 */
adsprsw     number(5),               /*打印次数                               */
adsacti     varchar2(1),             /*有效否                                 */
adsuser     varchar2(10),            /*建档人员                               */
adsgrup     varchar2(10),            /*建档部门                               */
adsmodu     varchar2(10),            /*最后更改人员                           */
adsdate     date,                    /*最后更改日期                           */
adsorig     varchar2(10),            /*资料建立部门                           */
adsoriu     varchar2(10)             /*资料建立者                             */
);

alter table ads_file add  constraint ads_pk primary key  (ads01) enable validate;
grant select on ads_file to tiptopgp;
grant update on ads_file to tiptopgp;
grant delete on ads_file to tiptopgp;
grant insert on ads_file to tiptopgp;
grant index on ads_file to public;
grant select on ads_file to ods;
