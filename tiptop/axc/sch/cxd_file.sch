/*
================================================================================
檔案代號:cxd_file
檔案名稱:库存入项期初开账资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table cxd_file
(
cxd01       varchar2(40) NOT NULL,   /*料件编号                               */
cxd02       number(5) NOT NULL,      /*年度                                   */
cxd03       number(5) NOT NULL,      /*期别                                   */
cxd04       number(5) NOT NULL,      /*顺序                                   */
cxd05       date,                    /*单据日期                               */
cxd06       varchar2(20),            /*单据号码                               */
cxd07       number(5),               /*项次                                   */
cxd08       number(15,3),            /*期末数量                               */
cxd09       number(20,6),            /*期末金额                               */
cxd091      number(20,6),            /*期末数量-材料                          */
cxd092      number(20,6),            /*期末数量-人工                          */
cxd093      number(20,6),            /*期末数量-制费                          */
cxd094      number(20,6),            /*期末数量-加工                          */
cxd095      number(20,6),            /*期末金额-其他                          */
cxd10       number(15,3),            /*No Use                                 */
cxdacti     varchar2(1),             /*资料有效码                             */
cxduser     varchar2(10),            /*资料所有者                             */
cxdgrup     varchar2(10),            /*资料所有部门                           */
cxdmodu     varchar2(10),            /*资料更改者                             */
cxddate     date,                    /*最近更改日                             */
cxd010      varchar2(1) DEFAULT ' ' NOT NULL, /*成本计算类型*/
cxd011      varchar2(40) DEFAULT ' ' NOT NULL, /*类别代号(批次号/专案号/利润 */
cxd096      number(20,6) DEFAULT '0',/*期末金额-制费三                        */
cxd097      number(20,6) DEFAULT '0',/*期末金额-制费四                        */
cxd098      number(20,6) DEFAULT '0',/*期末金额-制费五                        */
cxdlegal    varchar2(10) NOT NULL,   /*所属法人                               */
cxdorig     varchar2(10),            /*资料建立部门                           */
cxdoriu     varchar2(10)             /*资料建立者                             */
);

alter table cxd_file add  constraint cxd_pk primary key  (cxd01,cxd010,cxd011,cxd02,cxd03,cxd04) enable validate;
grant select on cxd_file to tiptopgp;
grant update on cxd_file to tiptopgp;
grant delete on cxd_file to tiptopgp;
grant insert on cxd_file to tiptopgp;
grant index on cxd_file to public;
grant select on cxd_file to ods;
