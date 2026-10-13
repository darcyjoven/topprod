/*
================================================================================
檔案代號:fav_file
檔案名稱:固定资产外送单据单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table fav_file
(
fav01       varchar2(20) NOT NULL,   /*外送单号                               */
fav02       number(5) NOT NULL,      /*项次                                   */
fav03       varchar2(10),            /*财产编号                               */
fav031      varchar2(4),             /*附号                                   */
fav04       number(5),               /*外送数量                               */
fav05       varchar2(20),            /*外送地点                               */
fav06       varchar2(10),            /*外送原因                               */
fav07       number(5),               /*收回数量                               */
fav08       varchar2(1),             /*停用否                                 */
fav09       varchar2(1),             /*No Use                                 */
fav10       varchar2(1),             /*No Use                                 */
favud01     varchar2(255),           /*自订字段-Textedit                      */
favud02     varchar2(40),            /*自订字段-文字                          */
favud03     varchar2(40),            /*自订字段-文字                          */
favud04     varchar2(40),            /*自订字段-文字                          */
favud05     varchar2(40),            /*自订字段-文字                          */
favud06     varchar2(40),            /*自订字段-文字                          */
favud07     number(15,3),            /*自订字段-数值                          */
favud08     number(15,3),            /*自订字段-数值                          */
favud09     number(15,3),            /*自订字段-数值                          */
favud10     number(10),              /*自订字段-整数                          */
favud11     number(10),              /*自订字段-整数                          */
favud12     number(10),              /*自订字段-整数                          */
favud13     date,                    /*自订字段-日期                          */
favud14     date,                    /*自订字段-日期                          */
favud15     date,                    /*自订字段-日期                          */
favlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create unique index fav_02 on fav_file (fav01,fav03,fav031);
alter table fav_file add  constraint fav_pk primary key  (fav01,fav02) enable validate;
grant select on fav_file to tiptopgp;
grant update on fav_file to tiptopgp;
grant delete on fav_file to tiptopgp;
grant insert on fav_file to tiptopgp;
grant index on fav_file to public;
grant select on fav_file to ods;
