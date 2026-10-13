/*
================================================================================
檔案代號:lig_file
檔案名稱:摊位意向协议维护档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lig_file
(
lig01       varchar2(20) DEFAULT ' ' NOT NULL, /*意向協議單號*/
lig02       varchar2(10),            /*楼栋编号                               */
lig03       varchar2(10),            /*楼层编号                               */
lig04       varchar2(20),            /*摊位编号                               */
lig05       varchar2(1) DEFAULT ' ' NOT NULL, /*来源类型*/
lig06       varchar2(20),            /*来源单号                               */
lig07       varchar2(10),            /*商户号                                 */
lig08       varchar2(20),            /*联系电话                               */
lig09       varchar2(10),            /*费用编号                               */
lig10       number(20,6),            /*預定金額                               */
lig11       varchar2(20),            /*费用单编号                             */
lig12       date,                    /*签订日期                               */
lig13       varchar2(10),            /*簽約人                                 */
lig14       varchar2(255),           /*备注                                   */
ligacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
ligcond     date,                    /*审核日期                               */
ligconf     varchar2(1) DEFAULT ' ' NOT NULL, /*确认码*/
ligconu     varchar2(10),            /*审核人                                 */
ligcrat     date,                    /*资料创建日                             */
ligdate     date,                    /*最近更改日                             */
liggrup     varchar2(10),            /*资料所有群                             */
liglegal    varchar2(10) DEFAULT ' ' NOT NULL, /*法人*/
ligmodu     varchar2(10),            /*资料更改者                             */
ligorig     varchar2(10),            /*资料建立部门                           */
ligoriu     varchar2(10),            /*资料建立者                             */
ligplant    varchar2(10) DEFAULT ' ' NOT NULL, /*门店编号*/
liguser     varchar2(10)             /*资料所有者                             */
);

alter table lig_file add  constraint lig_pk primary key  (lig01) enable validate;
grant select on lig_file to tiptopgp;
grant update on lig_file to tiptopgp;
grant delete on lig_file to tiptopgp;
grant insert on lig_file to tiptopgp;
grant index on lig_file to public;
grant select on lig_file to ods;
