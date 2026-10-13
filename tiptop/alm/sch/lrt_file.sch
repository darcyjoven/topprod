/*
================================================================================
檔案代號:lrt_file
檔案名稱:开卡维护单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lrt_file
(
lrt01       varchar2(20) DEFAULT ' ' NOT NULL, /*单据编号*/
lrt02       number(5) DEFAULT '0' NOT NULL, /*项次*/
lrt03       varchar2(20),            /*卡种                                   */
lrt04       varchar2(30),            /*开始卡号                               */
lrt05       varchar2(30),            /*结束卡号                               */
lrtlegal    varchar2(10) NOT NULL,   /*所属法人                               */
lrtplant    varchar2(10) NOT NULL    /*所属营运中心                           */
);

alter table lrt_file add  constraint lrt_pk primary key  (lrt01,lrt02) enable validate;
grant select on lrt_file to tiptopgp;
grant update on lrt_file to tiptopgp;
grant delete on lrt_file to tiptopgp;
grant insert on lrt_file to tiptopgp;
grant index on lrt_file to public;
grant select on lrt_file to ods;
