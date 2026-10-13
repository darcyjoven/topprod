/*
================================================================================
檔案代號:lqy_file
檔案名稱:换物变更设定单身档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lqy_file
(
lqy01       varchar2(20) DEFAULT ' ' NOT NULL, /*兑换方案代码*/
lqy02       number(20) DEFAULT '0' NOT NULL, /*积分达*/
lqy03       varchar2(40) DEFAULT ' ' NOT NULL, /*赠品编号*/
lqy04       varchar2(4) DEFAULT ' ' NOT NULL, /*单位*/
lqy05       number(15,3) DEFAULT '0' NOT NULL, /*数量*/
lqy06       number(5) DEFAULT '0' NOT NULL, /*项次*/
lqy07       number(20,6) DEFAULT '0' NOT NULL, /*累计消费额*/
lqy08       varchar2(10) DEFAULT ' ' NOT NULL, /*制订营运中心*/
lqy09       number(5) DEFAULT '0' NOT NULL, /*兑换方案版本号*/
lqylegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
lqyplant    varchar2(10) DEFAULT ' ' NOT NULL, /*所属营运中心*/
lqy00       varchar2(1) DEFAULT ' ' NOT NULL, /*兑换来源*/
                                     /*0.积分换物, 1.累计消费额换物           */
lqy10       varchar2(20) DEFAULT ' ' NOT NULL /*卡种代号*/
);

alter table lqy_file add  constraint lqy_pk primary key  (lqy00,lqy01,lqy02,lqy03,lqy07,lqy08,lqy09,lqy10,lqyplant) enable validate;
grant select on lqy_file to tiptopgp;
grant update on lqy_file to tiptopgp;
grant delete on lqy_file to tiptopgp;
grant insert on lqy_file to tiptopgp;
grant index on lqy_file to public;
grant select on lqy_file to ods;
