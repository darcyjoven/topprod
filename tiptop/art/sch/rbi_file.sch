/*
================================================================================
檔案代號:rbi_file
檔案名稱:满额促销变更第一单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rbi_file
(
rbi01       varchar2(10) DEFAULT ' ' NOT NULL, /*制定机构*/
rbi02       varchar2(20) DEFAULT ' ' NOT NULL, /*促销单号*/
rbi03       number(5) DEFAULT '0' NOT NULL, /*异动序号*/
rbi04       number(5) DEFAULT '0' NOT NULL, /*序号*/
rbi05       varchar2(1) DEFAULT ' ' NOT NULL, /*资料类型:0初始,1修改*/
rbi06       number(5) DEFAULT '0' NOT NULL, /*组别*/
rbi07       number(20,6) DEFAULT '0' NOT NULL, /*满额条件*/
rbi08       number(5,2),             /*折扣率%                                */
rbi09       number(20,6) DEFAULT '0' NOT NULL, /*折让价*/
rbi10       varchar2(1) DEFAULT 'N' NOT NULL, /*会员促销方式*/
rbi11       number(5,2),             /*会员折扣率%                            */
rbi12       number(20,6) DEFAULT '0' NOT NULL, /*会员折让价*/
rbiacti     varchar2(1) DEFAULT 'Y' NOT NULL, /*有效否*/
rbilegal    varchar2(10) DEFAULT ' ' NOT NULL, /*法人别*/
rbiplant    varchar2(10) DEFAULT ' ' NOT NULL, /*所属营运中心*/
rbi13       number(20,6) DEFAULT '0' NOT NULL /*折让基数*/
);

alter table rbi_file add  constraint rbi_pk primary key  (rbi01,rbi02,rbi03,rbi04,rbi05,rbi06,rbiplant) enable validate;
grant select on rbi_file to tiptopgp;
grant update on rbi_file to tiptopgp;
grant delete on rbi_file to tiptopgp;
grant insert on rbi_file to tiptopgp;
grant index on rbi_file to public;
grant select on rbi_file to ods;
