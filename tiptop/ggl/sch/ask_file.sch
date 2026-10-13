/*
================================================================================
檔案代號:ask_file
檔案名稱:调整与销除分录底稿单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ask_file
(
ask00       varchar2(5) DEFAULT ' ' NOT NULL, /*帐别*/
ask01       varchar2(20) DEFAULT ' ' NOT NULL, /*凭证编号*/
ask02       number(5) DEFAULT '0' NOT NULL, /*项次*/
ask03       varchar2(24),            /*科目编号                               */
ask04       varchar2(80),            /*摘要                                   */
ask05       varchar2(15),            /*关系人/客户,厂商名称                   */
ask06       varchar2(1) DEFAULT ' ' NOT NULL, /*借贷别*/
ask07       number(20,6) DEFAULT '0' NOT NULL, /*异动金额*/
ask08       varchar2(1),             /*no use                                 */
ask09       varchar2(1),             /*no use                                 */
ask10       varchar2(1),             /*no use                                 */
ask11       varchar2(1),             /*no use                                 */
ask12       varchar2(1),             /*no use                                 */
asklegal    varchar2(10) DEFAULT ' ' NOT NULL /*所属法人*/
);

create        index ask_03 on ask_file (ask00,ask01,ask03,ask06);
create        index ask_02 on ask_file (ask03);
alter table ask_file add  constraint ask_pk primary key  (ask00,ask01,ask02) enable validate;
grant select on ask_file to tiptopgp;
grant update on ask_file to tiptopgp;
grant delete on ask_file to tiptopgp;
grant insert on ask_file to tiptopgp;
grant index on ask_file to public;
grant select on ask_file to ods;
