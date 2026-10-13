/*
================================================================================
檔案代號:lnm_file
檔案名稱:费用设置信息档
檔案目的:
上游檔案:
下游檔案:
檔案類型:P
多語系檔案:N
============.========================.==========================================
*/
create table lnm_file
(
lnm01       varchar2(10) DEFAULT ' ' NOT NULL, /*费用明细编号*/
lnm02       varchar2(10),            /*no use 原门店编号                      */
lnm03       varchar2(10) DEFAULT ' ' NOT NULL, /*楼栋编号*/
lnm04       varchar2(10) DEFAULT ' ' NOT NULL, /*楼层编号*/
lnm05       varchar2(10) DEFAULT ' ' NOT NULL, /*产品分类*/
lnm06       varchar2(4) DEFAULT ' ' NOT NULL, /*年份*/
lnm07       varchar2(2) DEFAULT ' ' NOT NULL, /*月份*/
lnm08       number(20,2),            /*费用标准                               */
lnm09       number(10),              /*人数                                   */
lnm10       number(20,2),            /*费用合计                               */
lnm11       number(20,2),            /*保底金额                               */
lnm12       varchar2(1),             /*确认码                                 */
lnm13       varchar2(10),            /*审核人                                 */
lnm14       date,                    /*审核日期                               */
lnm15       varchar2(50),            /*备注                                   */
lnm16       date,                    /*应付帐日                               */
lnmacti     varchar2(1),             /*资料有效码                             */
lnmcrat     date,                    /*资料创建日                             */
lnmdate     date,                    /*最近更改日                             */
lnmgrup     varchar2(10),            /*资料所有群                             */
lnmlegal    varchar2(10) NOT NULL,   /*所属法人                               */
lnmmodu     varchar2(10),            /*资料更改者                             */
lnmuser     varchar2(10),            /*资料所有者                             */
lnmoriu     varchar2(10),            /*资料建立者                             */
lnmorig     varchar2(10),            /*资料建立部门                           */
lnmstore    varchar2(10) DEFAULT ' ' NOT NULL /*门店编号*/
);

alter table lnm_file add  constraint lnm_pk primary key  (lnm01,lnmstore,lnm03,lnm04,lnm05,lnm06,lnm07) enable validate;
grant select on lnm_file to tiptopgp;
grant update on lnm_file to tiptopgp;
grant delete on lnm_file to tiptopgp;
grant insert on lnm_file to tiptopgp;
grant index on lnm_file to public;
grant select on lnm_file to ods;
