/*
================================================================================
檔案代號:adu_file
檔案名稱:分销系统参数档-采购单
檔案目的:
上游檔案:
下游檔案:
檔案類型:P
多語系檔案:N
============.========================.==========================================
*/
create table adu_file
(
adu01       varchar2(10) NOT NULL,   /*拨出营运中心                           */
adu02       varchar2(5),             /*采购单别                               */
adu021      varchar2(5),             /*收货单别                               */
adu03       varchar2(10),            /*付款条件                               */
adu04       varchar2(6),             /*价格条件                               */
adu05       varchar2(10),            /*送货地址                               */
adu06       varchar2(10),            /*采购员                                 */
adu07       varchar2(10),            /*采购部门                               */
adu08       varchar2(4),             /*税种                                   */
adu09       number(9,4),             /*税率                                   */
adu10       varchar2(4),             /*币种                                   */
adu11       number(20,10),           /*汇率                                   */
adu12       varchar2(1),             /*No                                     */
adu13       varchar2(1),             /*No                                     */
adu14       varchar2(1),             /*No                                     */
adu15       varchar2(1),             /*No                                     */
aduacti     varchar2(1),             /*资料有效码                             */
aduuser     varchar2(10),            /*资料所有者                             */
adugrup     varchar2(10),            /*资料所有部门                           */
adumodu     varchar2(10),            /*资料更改者                             */
adudate     date,                    /*最近更改日                             */
aduorig     varchar2(10),            /*资料建立部门                           */
aduoriu     varchar2(10)             /*资料建立者                             */
);

alter table adu_file add  constraint adu_pk primary key  (adu01) enable validate;
grant select on adu_file to tiptopgp;
grant update on adu_file to tiptopgp;
grant delete on adu_file to tiptopgp;
grant insert on adu_file to tiptopgp;
grant index on adu_file to public;
grant select on adu_file to ods;
