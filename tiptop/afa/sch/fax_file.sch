/*
================================================================================
檔案代號:fax_file
檔案名稱:固定资产收回单据单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table fax_file
(
fax01       varchar2(20) NOT NULL,   /*收回单号                               */
fax02       number(5) NOT NULL,      /*项次                                   */
fax03       varchar2(20),            /*外送单号                               */
fax04       number(5),               /*外送序号                               */
fax05       varchar2(10),            /*财产编号                               */
fax051      varchar2(4),             /*附号                                   */
fax06       number(5),               /*未收回量                               */
fax07       number(5),               /*收回数量                               */
fax08       varchar2(1),             /*停用否                                 */
fax09       varchar2(1),             /*No Use                                 */
fax10       varchar2(1),             /*No Use                                 */
faxud01     varchar2(255),           /*自订字段-Textedit                      */
faxud02     varchar2(40),            /*自订字段-文字                          */
faxud03     varchar2(40),            /*自订字段-文字                          */
faxud04     varchar2(40),            /*自订字段-文字                          */
faxud05     varchar2(40),            /*自订字段-文字                          */
faxud06     varchar2(40),            /*自订字段-文字                          */
faxud07     number(15,3),            /*自订字段-数值                          */
faxud08     number(15,3),            /*自订字段-数值                          */
faxud09     number(15,3),            /*自订字段-数值                          */
faxud10     number(10),              /*自订字段-整数                          */
faxud11     number(10),              /*自订字段-整数                          */
faxud12     number(10),              /*自订字段-整数                          */
faxud13     date,                    /*自订字段-日期                          */
faxud14     date,                    /*自订字段-日期                          */
faxud15     date,                    /*自订字段-日期                          */
faxlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create unique index fax_02 on fax_file (fax01,fax03,fax04);
alter table fax_file add  constraint fax_pk primary key  (fax01,fax02) enable validate;
grant select on fax_file to tiptopgp;
grant update on fax_file to tiptopgp;
grant delete on fax_file to tiptopgp;
grant insert on fax_file to tiptopgp;
grant index on fax_file to public;
grant select on fax_file to ods;
