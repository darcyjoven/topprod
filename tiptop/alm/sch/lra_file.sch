/*
================================================================================
檔案代號:lra_file
檔案名稱:会员换赠设定单头档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lra_file
(
lra01       varchar2(20) DEFAULT ' ' NOT NULL, /*会员换赠方案编号*/
lra02       varchar2(40),            /*会员换赠说明                           */
lra03       varchar2(10),            /*审核人                                 */
lra04       date,                    /*审核日期                               */
lra05       varchar2(255),           /*备注                                   */
lraconf     varchar2(1) DEFAULT ' ' NOT NULL, /*审核否*/
lradate     date,                    /*最近更改日                             */
lragrup     varchar2(10),            /*资料所有群                             */
lramodu     varchar2(10),            /*资料更改者                             */
lraorig     varchar2(10),            /*资料建立部门                           */
lraoriu     varchar2(10),            /*资料建立者                             */
lrapos      varchar2(1) DEFAULT ' ' NOT NULL, /*已传POS否*/
lrauser     varchar2(10),            /*资料所有者                             */
lraacti     varchar2(1) DEFAULT ' ' NOT NULL /*资料有效码*/
);

alter table lra_file add  constraint lra_pk primary key  (lra01) enable validate;
grant select on lra_file to tiptopgp;
grant update on lra_file to tiptopgp;
grant delete on lra_file to tiptopgp;
grant insert on lra_file to tiptopgp;
grant index on lra_file to public;
grant select on lra_file to ods;
