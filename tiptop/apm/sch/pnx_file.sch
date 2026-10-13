/*
================================================================================
檔案代號:pnx_file
檔案名稱:集团采购底稿单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table pnx_file
(
pnx01       varchar2(10) NOT NULL,   /*采购中心代码                           */
pnx02       varchar2(1) NOT NULL,    /*资料来源 (1.依各厂抛转的请购           */
pnx03       varchar2(20) NOT NULL,   /*抛转底稿序号 /mrp版本                  */
pnx04       varchar2(10) NOT NULL,   /*需求营运中心                           */
pnx05       varchar2(20) NOT NULL,   /*请购单号  /mrp版本                     */
pnx06       number(5) NOT NULL,      /*请购单项次 /模拟版本序号               */
pnx07       varchar2(40),            /*料件编号                               */
pnx08       date,                    /*请购日期                               */
pnx09       date,                    /*需求日期                               */
pnx10       varchar2(4),             /*单位一                                 */
pnx11       number(20,8),            /*单位一转换率                           */
pnx12       number(15,3),            /*单位一数量                             */
pnx13       varchar2(4),             /*单位二                                 */
pnx14       number(20,8),            /*单位二转换率                           */
pnx15       number(15,3),            /*单位二数量                             */
pnx16       varchar2(4),             /*需求单位                               */
pnx17       number(20,8),            /*需求单位转换率                         */
pnx18       number(15,3),            /*需求单位数量                           */
pnx19       varchar2(1),             /*版本结案                               */
pnx20       number(15,3),            /*已分配数量                             */
pnxplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
pnxlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table pnx_file add  constraint pnx_pk primary key  (pnx01,pnx02,pnx03,pnx04,pnx05,pnx06) enable validate;
grant select on pnx_file to tiptopgp;
grant update on pnx_file to tiptopgp;
grant delete on pnx_file to tiptopgp;
grant insert on pnx_file to tiptopgp;
grant index on pnx_file to public;
grant select on pnx_file to ods;
