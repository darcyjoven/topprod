/*
================================================================================
檔案代號:wsh_file
檔案名稱:easyflow 集成设置档(表单集成字段设置)
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table wsh_file
(
wsh01       varchar2(20) NOT NULL,   /*程序编号                               */
wsh02       varchar2(1) NOT NULL,    /*维护性质                               */
wsh03       number(5) NOT NULL,      /*单身档项次                             */
wsh04       number(5) NOT NULL,      /*字段项次                               */
wsh05       varchar2(20) NOT NULL,   /*字段名称                               */
wsh06       varchar2(20),            /*参考字段 #1                            */
wsh07       varchar2(20),            /*参考字段 #2                            */
wsh08       varchar2(20),            /*参考字段 #3                            */
wsh09       varchar2(20),            /*画面代码                               */
wsh10       varchar2(20),            /*字段代码                               */
wsh11       varchar2(10),            /*No Use                                 */
wsh12       varchar2(10),            /*No Use                                 */
wsh13       varchar2(10),            /*No Use                                 */
wsh14       varchar2(10),            /*No Use                                 */
wsh15       varchar2(10)             /*No Use                                 */
);

alter table wsh_file add  constraint wsh_pk primary key  (wsh01,wsh02,wsh03,wsh04,wsh05) enable validate;
grant select on wsh_file to tiptopgp;
grant update on wsh_file to tiptopgp;
grant delete on wsh_file to tiptopgp;
grant insert on wsh_file to tiptopgp;
grant index on wsh_file to public;
grant select on wsh_file to ods;
