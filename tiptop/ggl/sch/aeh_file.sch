/*
================================================================================
檔案代號:aeh_file
檔案名稱:科目各核算項目餘額檔
檔案目的:科目各核算項組合統計檔
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table aeh_file
(
aeh00       varchar2(5) DEFAULT ' ' NOT NULL, /*帐套*/
aeh01       varchar2(24) DEFAULT ' ' NOT NULL, /*科目编号*/
aeh02       varchar2(10) DEFAULT ' ' NOT NULL, /*部门编号*/
aeh03       varchar2(10) DEFAULT ' ' NOT NULL, /*项目编号*/
aeh04       varchar2(30) DEFAULT ' ' NOT NULL, /*核算项-1*/
aeh05       varchar2(30) DEFAULT ' ' NOT NULL, /*核算项-2*/
aeh06       varchar2(30) DEFAULT ' ' NOT NULL, /*核算项-3*/
aeh07       varchar2(30) DEFAULT ' ' NOT NULL, /*核算项-4*/
aeh08       varchar2(4) DEFAULT ' ' NOT NULL, /*预算编号*/
aeh09       number(5) DEFAULT '0' NOT NULL, /*会计年度*/
aeh10       number(5) DEFAULT '0' NOT NULL, /*期别*/
aeh11       number(20,6) DEFAULT '0' NOT NULL, /*借方金额*/
aeh12       number(20,6) DEFAULT '0' NOT NULL, /*贷方金额*/
aeh13       number(5),               /*借方笔数                               */
aeh14       number(5),               /*贷方笔数                               */
aeh15       number(20,6) DEFAULT '0' NOT NULL, /*原币借方金额*/
aeh16       number(20,6) DEFAULT '0' NOT NULL, /*原币贷方金额*/
aeh17       varchar2(4) DEFAULT ' ' NOT NULL, /*币种*/
aeh31       varchar2(30) DEFAULT ' ' NOT NULL, /*核算项-5*/
aeh32       varchar2(30) DEFAULT ' ' NOT NULL, /*核算项-6*/
aeh33       varchar2(30) DEFAULT ' ' NOT NULL, /*核算项-7*/
aeh34       varchar2(30) DEFAULT ' ' NOT NULL, /*核算项-8*/
aeh35       varchar2(30) DEFAULT ' ' NOT NULL, /*核算项-9*/
aeh36       varchar2(30) DEFAULT ' ' NOT NULL, /*核算项-10*/
aeh37       varchar2(30) DEFAULT ' ' NOT NULL, /*核算項-關系人*/
aehlegal    varchar2(10) DEFAULT ' ' NOT NULL /*所属法人*/
);

alter table aeh_file add  constraint aeh_pk primary key  (aeh00,aeh01,aeh02,aeh03,aeh04,aeh05,aeh06,aeh07,aeh08,aeh09,aeh10,aeh17,aeh31,aeh32,aeh33,aeh34,aeh35,aeh36,aeh37) enable validate;
grant select on aeh_file to tiptopgp;
grant update on aeh_file to tiptopgp;
grant delete on aeh_file to tiptopgp;
grant insert on aeh_file to tiptopgp;
grant index on aeh_file to public;
grant select on aeh_file to ods;
