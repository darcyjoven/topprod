/*
================================================================================
檔案代號:lrg_file
檔案名稱:换物单单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lrg_file
(
lrg01       varchar2(20) DEFAULT ' ' NOT NULL, /*积分换物单编号*/
lrg02       varchar2(20) DEFAULT ' ' NOT NULL, /*赠品编号*/
lrg03       number(12) DEFAULT '0' NOT NULL, /*需兑换积分*/
lrg04       number(12) DEFAULT '1' NOT NULL, /*兑换份数*/
lrg05       number(12) DEFAULT '0' NOT NULL, /*总兑换积分*/
lrglegal    varchar2(10) NOT NULL,   /*所属法人                               */
lrgplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
lrg06       varchar2(4),             /*单位                                   */
lrg07       number(15,3) DEFAULT '0' NOT NULL, /*数量*/
lrg08       number(5) DEFAULT '0' NOT NULL, /*方案项次*/
lrg09       number(20,6) DEFAULT '0' NOT NULL, /*需兑换累计消费额*/
lrg10       number(20,6) DEFAULT '0' NOT NULL /*总兑换金额*/
);

alter table lrg_file add  constraint lrg_pk primary key  (lrg01,lrg08) enable validate;
grant select on lrg_file to tiptopgp;
grant update on lrg_file to tiptopgp;
grant delete on lrg_file to tiptopgp;
grant insert on lrg_file to tiptopgp;
grant index on lrg_file to public;
grant select on lrg_file to ods;
