/*
================================================================================
檔案代號:rxw_file
檔案名稱:联盟卡卡种档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table rxw_file
(
rxw01       varchar2(10) DEFAULT ' ' NOT NULL, /*卡种编号*/
rxw02       varchar2(80),            /*卡种名称                               */
rxw03       number(5,3),             /*手续费率                               */
rxw04       varchar2(24),            /*会计科目                               */
rxw05       varchar2(24),            /*会计科目二                             */
rxw06       varchar2(1),             /*可用于促销付款                         */
rxwacti     varchar2(1),             /*资料有效码                             */
rxwcrat     date,                    /*资料创建日                             */
rxwdate     date,                    /*最近更改日                             */
rxwgrup     varchar2(10),            /*资料所有部门                           */
rxwmodu     varchar2(10),            /*资料更改者                             */
rxwuser     varchar2(10),            /*资料所有者                             */
rxwpos      varchar2(1) DEFAULT '1' NOT NULL /*已传POS否*/
);

alter table rxw_file add  constraint rxw_pk primary key  (rxw01) enable validate;
grant select on rxw_file to tiptopgp;
grant update on rxw_file to tiptopgp;
grant delete on rxw_file to tiptopgp;
grant insert on rxw_file to tiptopgp;
grant index on rxw_file to public;
grant select on rxw_file to ods;
