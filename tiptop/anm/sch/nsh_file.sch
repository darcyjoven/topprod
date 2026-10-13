/*
================================================================================
檔案代號:nsh_file
檔案名稱:账号对象资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table nsh_file
(
nsh01       varchar2(20) DEFAULT ' ' NOT NULL, /*银行编号*/
nsh02       varchar2(30) DEFAULT ' ' NOT NULL, /*银行帐号*/
nsh03       varchar2(1) DEFAULT ' ' NOT NULL, /*账号对象*/
nsh04       varchar2(10),            /*对象代号                               */
nsh05       varchar2(40),            /*对象简称                               */
nsh06       varchar2(20),            /*税号/身份证号                          */
nsh07       varchar2(80),            /*户名                                   */
nsh08       varchar2(1),             /*入账通知                               */
nsh09       varchar2(10),            /*连络人(一)                             */
nsh10       varchar2(10),            /*连络人(二)                             */
nsh11       varchar2(10),            /*连络人(三)                             */
nsh12       varchar2(40),            /*连络电话(一)                           */
nsh13       varchar2(40),            /*连络电话(二)                           */
nsh14       varchar2(40),            /*传真号码                               */
nsh15       varchar2(80)             /*e-mail                                 */
);

alter table nsh_file add  constraint nsh_pk primary key  (nsh01,nsh02,nsh03) enable validate;
grant select on nsh_file to tiptopgp;
grant update on nsh_file to tiptopgp;
grant delete on nsh_file to tiptopgp;
grant insert on nsh_file to tiptopgp;
grant index on nsh_file to public;
grant select on nsh_file to ods;
