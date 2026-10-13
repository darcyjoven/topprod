/*
================================================================================
檔案代號:rxd_file
檔案名稱:换赠记录档
檔案目的:记录换赠信息
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rxd_file
(
rxd00       varchar2(2) DEFAULT ' ' NOT NULL, /*单据别*/
rxd01       varchar2(20) DEFAULT ' ' NOT NULL, /*单据编号*/
rxd02       varchar2(1) DEFAULT ' ' NOT NULL, /*促销哦类型*/
rxd03       varchar2(20) DEFAULT ' ' NOT NULL, /*促销单号*/
rxd04       number(20,6) DEFAULT '0' NOT NULL, /*满额金额,数量*/
rxd05       number(5) DEFAULT '0' NOT NULL, /*达成数*/
rxdlegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
rxdplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属工厂*/
);

alter table rxd_file add  constraint rxd_pk primary key  (rxd00,rxd01,rxd02,rxd03) enable validate;
grant select on rxd_file to tiptopgp;
grant update on rxd_file to tiptopgp;
grant delete on rxd_file to tiptopgp;
grant insert on rxd_file to tiptopgp;
grant index on rxd_file to public;
grant select on rxd_file to ods;
