/*
================================================================================
檔案代號:bwc_file
檔案名稱:保税工单盘点单身资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table bwc_file
(
bwc01       varchar2(20) NOT NULL,   /*标签编号                               */
bwc02       number(5) NOT NULL,      /*序号　　　　　　　　　                 */
bwc03       varchar2(40),            /*料件编号                               */
bwc04       number(5),               /*作业序号                               */
bwc05       number(15,3),            /*盘存数量                               */
                                     /*庫存單位                               */
bwc011      number(5) NOT NULL,      /*盘点年度                               */
bwcplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
bwclegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table bwc_file add  constraint bwc_pk primary key  (bwc01,bwc011,bwc02) enable validate;
grant select on bwc_file to tiptopgp;
grant update on bwc_file to tiptopgp;
grant delete on bwc_file to tiptopgp;
grant insert on bwc_file to tiptopgp;
grant index on bwc_file to public;
grant select on bwc_file to ods;
