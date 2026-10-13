/*
================================================================================
檔案代號:rbr_file
檔案名稱:换增变更资料单身档（一）
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rbr_file
(
rbr01       varchar2(10) DEFAULT ' ' NOT NULL, /*制定机构*/
rbr02       varchar2(20) DEFAULT ' ' NOT NULL, /*促销单号*/
rbr03       number(5) DEFAULT '0' NOT NULL, /*变动序号*/
rbr04       varchar2(1) DEFAULT ' ' NOT NULL, /*促销哦类型*/
rbr05       number(5) DEFAULT '0' NOT NULL, /*序号*/
rbr06       varchar2(1) DEFAULT ' ' NOT NULL, /*资料类型*/
rbr07       number(5) DEFAULT '0' NOT NULL, /*项次*/
rbr08       number(5) DEFAULT '0' NOT NULL, /*组别*/
rbr09       number(15,3) DEFAULT '0' NOT NULL, /*数量*/
rbr10       number(20,6) DEFAULT '0' NOT NULL, /*加价金额*/
rbr11       number(20,6) DEFAULT '0' NOT NULL, /*会员加价金额*/
rbracti     varchar2(1) DEFAULT 'Y' NOT NULL, /*有效否*/
rbrlegal    varchar2(10) DEFAULT ' ' NOT NULL, /*法人别*/
rbrplant    varchar2(10) DEFAULT ' ' NOT NULL /*营运中心编号*/
);

alter table rbr_file add  constraint rbr_pk primary key  (rbr01,rbr02,rbr03,rbr04,rbr05,rbr06,rbr07,rbr08,rbrplant) enable validate;
grant select on rbr_file to tiptopgp;
grant update on rbr_file to tiptopgp;
grant delete on rbr_file to tiptopgp;
grant insert on rbr_file to tiptopgp;
grant index on rbr_file to public;
grant select on rbr_file to ods;
