/*
================================================================================
檔案代號:bra_file
檔案名稱:制程产品结构资料单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table bra_file
(
bra01       varchar2(40) DEFAULT ' ' NOT NULL, /*主件料件代号*/
bra011      varchar2(10) DEFAULT ' ' NOT NULL, /*工艺编号*/
bra012      varchar2(10) DEFAULT ' ' NOT NULL, /*工艺段号*/
bra013      number(5) DEFAULT '0' NOT NULL, /*工艺序*/
bra014      varchar2(1),             /*标准产品BOM                            */
bra02       varchar2(20),            /*最后工程变异单单号                     */
bra03       date,                    /*最近工程变异日期                       */
bra04       varchar2(10),            /*组合模式参考代号                       */
bra05       date,                    /*发放日期                               */
bra06       varchar2(20) DEFAULT ' ' NOT NULL, /*特性代码*/
bra07       varchar2(1),             /*配方否                                 */
bra08       varchar2(10) DEFAULT ' ' NOT NULL, /*资料来源*/
bra09       number(10),              /*抛转次数                               */
bra10       varchar2(1) DEFAULT ' ' NOT NULL, /*状态码*/
braacti     varchar2(1),             /*资料有效码                             */
bradate     date,                    /*最近更改日                             */
bragrup     varchar2(10),            /*资料所有群                             */
bramodu     varchar2(10),            /*资料更改者                             */
braorig     varchar2(10),            /*资料建立部门                           */
braoriu     varchar2(10),            /*资料建立者                             */
brauser     varchar2(10)             /*资料所有者                             */
);

alter table bra_file add  constraint bra_pk primary key  (bra01,bra06,bra011,bra012,bra013) enable validate;
grant select on bra_file to tiptopgp;
grant update on bra_file to tiptopgp;
grant delete on bra_file to tiptopgp;
grant insert on bra_file to tiptopgp;
grant index on bra_file to public;
grant select on bra_file to ods;
