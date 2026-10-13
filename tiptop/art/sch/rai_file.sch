/*
================================================================================
檔案代號:rai_file
檔案名稱:满额促销单身档(一)
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rai_file
(
rai01       varchar2(10) DEFAULT ' ' NOT NULL, /*制定机构*/
rai02       varchar2(20) DEFAULT ' ' NOT NULL, /*促销单号*/
rai03       number(5) DEFAULT '0' NOT NULL, /*项次*/
rai04       number(20,6) DEFAULT '0' NOT NULL, /*满额金额*/
rai05       number(5,2),             /*折扣率                                 */
rai06       number(20,6) DEFAULT '0' NOT NULL, /*折让额*/
rai07       varchar2(1) DEFAULT 'N' NOT NULL, /*会员促销方式*/
rai08       number(5,2),             /*会员折扣率                             */
rai09       number(20,6) DEFAULT '0' NOT NULL, /*会员折让额*/
raiacti     varchar2(1) DEFAULT 'Y' NOT NULL, /*有效否*/
railegal    varchar2(10) DEFAULT ' ' NOT NULL, /*法人别*/
raiplant    varchar2(10) DEFAULT ' ' NOT NULL, /*所属营运中心*/
rai10       number(20,6) DEFAULT '0' NOT NULL /*折让基数*/
);

alter table rai_file add  constraint rai_pk primary key  (rai01,rai02,rai03,raiplant) enable validate;
grant select on rai_file to tiptopgp;
grant update on rai_file to tiptopgp;
grant delete on rai_file to tiptopgp;
grant insert on rai_file to tiptopgp;
grant index on rai_file to public;
grant select on rai_file to ods;
