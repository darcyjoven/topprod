/*
================================================================================
檔案代號:bxa_file
檔案名稱:保税委外加工海关核准文号档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table bxa_file
(
bxa01       varchar2(30) NOT NULL,   /*核准文号                               */
bxa02       varchar2(40) DEFAULT ' ' NOT NULL, /*申请料号*/
bxa03       varchar2(120),           /*品名                                   */
bxa04       varchar2(120),           /*规格                                   */
bxa05       varchar2(10),            /*加工厂商                               */
bxa06       date,                    /*起始日期                               */
bxa07       date,                    /*截止日期                               */
bxa08       number(15,3),            /*核准加工数量                           */
bxa09       number(15,3),            /*已核销数量                             */
bxa10       varchar2(255),           /*备注                                   */
bxaacti     varchar2(1)              /*有效码                                 */
);

alter table bxa_file add  constraint bxa_pk primary key  (bxa01,bxa02) enable validate;
grant select on bxa_file to tiptopgp;
grant update on bxa_file to tiptopgp;
grant delete on bxa_file to tiptopgp;
grant insert on bxa_file to tiptopgp;
grant index on bxa_file to public;
grant select on bxa_file to ods;
