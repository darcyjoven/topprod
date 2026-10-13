/*
================================================================================
檔案代號:log_file
檔案名稱:Trigger Log 资料明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table log_file
(
tab         varchar2(8),             /*档案编号                               */
key1        varchar2(20),            /*资料编号一                             */
key2        varchar2(20),            /*资料编号三                             */
key3        varchar2(20),            /*资料编号二                             */
key4        varchar2(20),            /*资料编号四                             */
key5        varchar2(20),            /*No Use                                 */
col         varchar2(8),             /*字段                                   */
ldate       date,                    /*异动日期                               */
luser       varchar2(6),             /*异动人员                               */
ltype       varchar2(3),             /*类型                                   */
old_val     varchar2(20),            /*更改前资料                             */
new_val     varchar2(20)             /*更改后资料                             */
);

create        index log_03 on log_file (ldate);
create        index log_01 on log_file (key1);
create        index log_02 on log_file (col);
grant select on log_file to tiptopgp;
grant update on log_file to tiptopgp;
grant delete on log_file to tiptopgp;
grant insert on log_file to tiptopgp;
grant index on log_file to public;
grant select on log_file to ods;
