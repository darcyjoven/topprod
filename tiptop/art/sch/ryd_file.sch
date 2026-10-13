/*
================================================================================
檔案代號:ryd_file
檔案名稱:款别资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ryd_file
(
ryd01       varchar2(10) DEFAULT ' ' NOT NULL, /*款别编号*/
                                     /*Money No.                              */
                                     /*1:Cash 2:UnionPay Card 3:Check 4:Certificate */
                                     /*5:Certificate 6:Stored-value Card 7:Chong Advance 8:Handwork Virement*/
                                     /*9.Point Instead Of Cash                */
ryd02       varchar2(80),            /*款别名称                               */
ryd03       number(2),               /*No use                                 */
ryd04       varchar2(80),            /*POS款别名称                            */
ryd05       varchar2(20),            /*银行编码                               */
rydacti     varchar2(1),             /*资料有效码                             */
rydcrat     date,                    /*资料创建日                             */
ryddate     date,                    /*最近更改日                             */
rydgrup     varchar2(10),            /*资料所有部门                           */
rydmodu     varchar2(10),            /*资料更改者                             */
ryduser     varchar2(10),            /*资料所有者                             */
rydorig     varchar2(10),            /*资料建立部门                           */
rydoriu     varchar2(10),            /*资料建立者                             */
ryd06       varchar2(40),            /*功能编号                               */
rydpos      varchar2(1) DEFAULT ' ' NOT NULL, /*已传POS否*/
ryd07       varchar2(1) DEFAULT 'Y' NOT NULL, /*是否应用POS钱箱*/
ryd08       varchar2(1) DEFAULT 'Y' NOT NULL, /*是否应用POS销售*/
ryd09       number(20,6) DEFAULT '0',/*POS最大找零金额                        */
ryd10       varchar2(10) DEFAULT ' ' NOT NULL, /*POS款别*/
ryd11       varchar2(1) DEFAULT ' ' NOT NULL, /*是否用于卡*/
ryd12       varchar2(1) DEFAULT ' ' NOT NULL, /*是否用于券*/
ryd13       varchar2(1) DEFAULT ' ' NOT NULL /*是否用于专柜*/
);

alter table ryd_file add  constraint ryd_pk primary key  (ryd01,ryd10) enable validate;
grant select on ryd_file to tiptopgp;
grant update on ryd_file to tiptopgp;
grant delete on ryd_file to tiptopgp;
grant insert on ryd_file to tiptopgp;
grant index on ryd_file to public;
grant select on ryd_file to ods;
