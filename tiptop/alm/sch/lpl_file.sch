/*
================================================================================
檔案代號:lpl_file
檔案名稱:会员销售资料单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table lpl_file
(
lpl01       varchar2(30) DEFAULT ' ' NOT NULL, /*会员卡号*/
lpl02       date DEFAULT sysdate NOT NULL, /*销售日期*/
lpl03       varchar2(20),            /*摊位编号                               */
lpl04       varchar2(10),            /*商户编号                               */
lpl05       varchar2(40) DEFAULT ' ' NOT NULL, /*产品编号*/
lpl06       varchar2(4) DEFAULT ' ' NOT NULL, /*单位*/
lpl07       number(15,3) DEFAULT '0' NOT NULL, /*数量*/
lpl08       number(20,6) DEFAULT '0' NOT NULL, /*金额*/
lpl09       number(5) DEFAULT '0' NOT NULL, /*项次*/
lpllegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
lplplant    varchar2(10) DEFAULT ' ' NOT NULL /*营运中心*/
);

create        index lpl_01 on lpl_file (lpl01,lpl02,lpl09,lplplant);
alter table lpl_file add  constraint lpl_pk primary key  (lpl01,lpl02,lpl09,lplplant) enable validate;
grant select on lpl_file to tiptopgp;
grant update on lpl_file to tiptopgp;
grant delete on lpl_file to tiptopgp;
grant insert on lpl_file to tiptopgp;
grant index on lpl_file to public;
grant select on lpl_file to ods;
