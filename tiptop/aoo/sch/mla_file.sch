/*
================================================================================
檔案代號:mla_file
檔案名稱:报表转发人员单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table mla_file
(
mla01       varchar2(10) NOT NULL,   /*报表编号                               */
                                     /*報表代號                               */
mla02       varchar2(4),             /*优先等级                               */
                                     /*優先等級                               */
mla03       number(5),               /*查阅完成天数                           */
                                     /*查閱完成天數                           */
mlaacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
mlauser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
mlagrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
mlamodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
mladate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
mlaorig     varchar2(10),            /*资料建立部门                           */
mlaoriu     varchar2(10)             /*资料建立者                             */
);

alter table mla_file add  constraint mla_pk primary key  (mla01) enable validate;
grant select on mla_file to tiptopgp;
grant update on mla_file to tiptopgp;
grant delete on mla_file to tiptopgp;
grant insert on mla_file to tiptopgp;
grant index on mla_file to public;
grant select on mla_file to ods;
