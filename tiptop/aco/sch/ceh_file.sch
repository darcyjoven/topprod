/*
================================================================================
檔案代號:ceh_file
檔案名稱:料件归并后资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ceh_file
(
ceh00       varchar2(1) DEFAULT ' ' NOT NULL, /*区分*/
ceh01       varchar2(10) DEFAULT ' ' NOT NULL, /*归并后序号*/
ceh02       varchar2(120),           /*归并后品名                             */
ceh03       varchar2(120),           /*归并后规格                             */
ceh04       varchar2(40),            /*海关商品编号                           */
ceh05       number(20,6),            /*归并后单价                             */
ceh06       varchar2(4),             /*申报计量单位                           */
ceh07       varchar2(4),             /*法定计量单位                           */
ceh08       number(15,6),            /*法定计量转换率                         */
ceh09       varchar2(4),             /*第二法定单位                           */
ceh10       number(15,6),            /*第二法定单位转换率                     */
ceh11       varchar2(40),            /*归并后货号                             */
ceh12       varchar2(4),             /*归并后币种                             */
cehacti     varchar2(1),             /*资料有效码                             */
cehdate     date,                    /*最近更改日                             */
cehgrup     varchar2(10),            /*资料所有部门                           */
cehmodu     varchar2(10),            /*资料更改者                             */
cehuser     varchar2(10),            /*资料所有者                             */
cehorig     varchar2(10),            /*资料建立部门                           */
cehoriu     varchar2(10)             /*资料建立者                             */
);

alter table ceh_file add  constraint ceh_pk primary key  (ceh00,ceh01) enable validate;
grant select on ceh_file to tiptopgp;
grant update on ceh_file to tiptopgp;
grant delete on ceh_file to tiptopgp;
grant insert on ceh_file to tiptopgp;
grant index on ceh_file to public;
grant select on ceh_file to ods;
