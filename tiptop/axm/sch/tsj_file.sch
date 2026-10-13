/*
================================================================================
檔案代號:tsj_file
檔案名稱:调拨申请单/采购单抛转单别设置档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tsj_file
(
tsj01       varchar2(10) NOT NULL,   /*需求营运中心                           */
tsj02       varchar2(5) NOT NULL,    /*杂发单别                               */
tsj03       varchar2(5),             /*出货单别                               */
tsj04       varchar2(5),             /*采购单别                               */
tsj05       varchar2(10),            /*付款条件                               */
tsj06       varchar2(6),             /*价格条件                               */
tsj07       varchar2(10),            /*送货地点                               */
tsj08       varchar2(10),            /*采购员                                 */
tsj09       varchar2(10),            /*采购部门                               */
tsj10       varchar2(4),             /*税种                                   */
tsj11       number(9,4),             /*税率                                   */
tsj12       varchar2(4),             /*币种                                   */
tsj13       number(20,10),           /*汇率                                   */
tsjacti     varchar2(1)              /*资料有效否                             */
);

alter table tsj_file add  constraint tsj_pk primary key  (tsj01) enable validate;
grant select on tsj_file to tiptopgp;
grant update on tsj_file to tiptopgp;
grant delete on tsj_file to tiptopgp;
grant insert on tsj_file to tiptopgp;
grant index on tsj_file to public;
grant select on tsj_file to ods;
