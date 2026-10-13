/*
================================================================================
檔案代號:lna_file
檔案名稱:商户预登记资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lna_file
(
lna01       varchar2(20) DEFAULT ' ' NOT NULL, /*预登记单号*/
lna02       varchar2(10),            /*来源门店编号                           */
lna03       varchar2(10),            /*预登记商户号                           */
lna04       varchar2(20),            /*商户简称                               */
lna05       varchar2(80),            /*商户全称                               */
lna06       varchar2(1) DEFAULT ' ' NOT NULL, /*企业性质*/
lna07       varchar2(10),            /*主品牌                                 */
lna08       varchar2(10),            /*产地                                   */
lna09       varchar2(60),            /*经营范围                               */
lna10       varchar2(10),            /*no use                                 */
lna11       varchar2(40),            /*总经理                                 */
lna12       varchar2(20),            /*总经理电话                             */
lna13       varchar2(40),            /*经营负责人                             */
lna14       varchar2(20),            /*负责人电话                             */
lna15       varchar2(40),            /*法人代表                               */
lna16       varchar2(20),            /*代表电话                               */
lna17       varchar2(40),            /*经营人                                 */
lna18       varchar2(20),            /*经营人电话                             */
lna19       varchar2(30),            /*电子信箱                               */
lna20       varchar2(30),            /*公司网站                               */
lna21       varchar2(20),            /*传真                                   */
lna22       varchar2(20),            /*代理登记                               */
lna23       number(20,6) DEFAULT '0',/*拟租面积                               */
lna24       varchar2(1) DEFAULT ' ' NOT NULL, /*是否签核*/
lna25       varchar2(1) DEFAULT ' ' NOT NULL, /*签核状态*/
lna26       varchar2(1) DEFAULT ' ' NOT NULL, /*确认码*/
lna27       varchar2(10),            /*审核人                                 */
lna28       date,                    /*审核日期                               */
lna29       varchar2(50),            /*备注                                   */
lnacrat     date,                    /*资料创建日                             */
lnadate     date,                    /*最近更改日                             */
lnagrup     varchar2(10),            /*资料所有群                             */
lnamodu     varchar2(10),            /*资料更改者                             */
lnauser     varchar2(10),            /*资料所有者                             */
lnaoriu     varchar2(10),            /*资料建立者                             */
lnaorig     varchar2(10)             /*资料建立部门                           */
);

alter table lna_file add  constraint lna_pk primary key  (lna01) enable validate;
grant select on lna_file to tiptopgp;
grant update on lna_file to tiptopgp;
grant delete on lna_file to tiptopgp;
grant insert on lna_file to tiptopgp;
grant index on lna_file to public;
grant select on lna_file to ods;
