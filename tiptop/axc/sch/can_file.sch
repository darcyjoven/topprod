/*
================================================================================
檔案代號:can_file
檔案名稱:当月销货收入金额调整资料
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table can_file
(
can01       varchar2(40) NOT NULL,   /*料号                                   */
can02       number(5) NOT NULL,      /*年度                                   */
can03       number(5) NOT NULL,      /*月份                                   */
can04       varchar2(20) NOT NULL,   /*参考单号                               */
can05       varchar2(255),           /*备注                                   */
can06       number(20,6) NOT NULL,   /*当月销货收入调整金额                   */
can07       varchar2(1),             /*No Use                                 */
can08       varchar2(1),             /*No Use                                 */
can09       varchar2(1),             /*No Use                                 */
can10       varchar2(1),             /*No Use                                 */
canacti     varchar2(1),             /*资料有效码                             */
canuser     varchar2(10),            /*资料所有者                             */
cangrup     varchar2(10),            /*资料所有部门                           */
canmodu     varchar2(10),            /*资料更改者                             */
candate     date,                    /*最近更改日                             */
canlegal    varchar2(10) NOT NULL,   /*所属法人                               */
canoriu     varchar2(10),            /*资料建立者                             */
canorig     varchar2(10)             /*资料建立部门                           */
);

alter table can_file add  constraint can_pk primary key  (can01,can02,can03,can04) enable validate;
grant select on can_file to tiptopgp;
grant update on can_file to tiptopgp;
grant delete on can_file to tiptopgp;
grant insert on can_file to tiptopgp;
grant index on can_file to public;
grant select on can_file to ods;
