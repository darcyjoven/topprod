/*
================================================================================
檔案代號:gbt_file
檔案名稱:系统账号稽核原则
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gbt_file
(
gbt00       varchar2(1) NOT NULL,    /*key value(0)                           */
gbt01       number(5),               /*口令要求变更依据                       */
gbt02       number(5),               /*口令更新周期 (天)                      */
gbt03       number(5),               /*口令可用次数 (次数)                    */
gbt04       number(5),               /*提前通知天数 (天)                      */
gbt05       number(5),               /*口令最小长度 (字数)                    */
gbt06       varchar2(1),             /*口令复杂度设置1-不可含帐号             */
gbt07       varchar2(1),             /*是否使用Web密码编码功能                */
gbt08       varchar2(1),             /*no use
                                                                                */
gbt09       varchar2(1),             /*no use                                 */
gbtdate     date,                    /*资料更改日                             */
gbtgrup     varchar2(10),            /*资料所有部门                           */
gbtmodu     varchar2(10),            /*资料更改人                             */
gbt10       number(5)                /*允许最大试误次数                       */
);

alter table gbt_file add  constraint gbt_pk primary key  (gbt00) enable validate;
grant select on gbt_file to tiptopgp;
grant update on gbt_file to tiptopgp;
grant delete on gbt_file to tiptopgp;
grant insert on gbt_file to tiptopgp;
grant index on gbt_file to public;
grant select on gbt_file to ods;
