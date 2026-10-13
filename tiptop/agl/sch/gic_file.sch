/*
================================================================================
檔案代號:gic_file
檔案名稱:销货预算明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table gic_file
(
gic011      varchar2(10) NOT NULL,   /*预算编号                               */
gic012      varchar2(10) NOT NULL,   /*客户编号                               */
gic013      varchar2(10) NOT NULL,   /*产品类型编号                           */
gic014      varchar2(10) NOT NULL,   /*地区编号                               */
gic015      varchar2(10) NOT NULL,   /*部门编号                               */
gic016      varchar2(10) NOT NULL,   /*业务员编号                             */
gic017      number(5) NOT NULL,      /*预算销售年度                           */
gic02       number(5) NOT NULL,      /*预算销售期别                           */
gic03       number(15,3),            /*预算销量                               */
gic04       number(20,6),            /*预算销售单价                           */
gic05       varchar2(4),             /*币种                                   */
gic06       number(20,10),           /*汇率                                   */
gicacti     varchar2(1),             /*资料有效码                             */
gicuser     varchar2(10),            /*资料所有者                             */
gicgrup     varchar2(10),            /*资料所有部门                           */
gicmodu     varchar2(10),            /*资料更改者                             */
gicdate     date,                    /*最近更改日                             */
gicorig     varchar2(10),            /*资料建立部门                           */
gicoriu     varchar2(10)             /*资料建立者                             */
);

alter table gic_file add  constraint gic_pk primary key  (gic011,gic012,gic013,gic014,gic015,gic016,gic017,gic02) enable validate;
grant select on gic_file to tiptopgp;
grant update on gic_file to tiptopgp;
grant delete on gic_file to tiptopgp;
grant insert on gic_file to tiptopgp;
grant index on gic_file to public;
grant select on gic_file to ods;
