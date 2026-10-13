/*
================================================================================
檔案代號:slc_file
檔案名稱:成品尺寸表档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table slc_file
(
slc01       varchar2(10) DEFAULT ' ' NOT NULL, /*制单号*/
slc02       varchar2(20) DEFAULT ' ' NOT NULL, /*款式号*/
slc03       date,                    /*制定日期                               */
slc04       varchar2(20),            /*版单号                                 */
slc05       number(15,3),            /*缩率(直)                               */
slc06       number(15,3),            /*缩率(横)                               */
slc07       varchar2(10),            /*客户                                   */
slc08       number(15,3),            /*件数                                   */
slc09       varchar2(10),            /*尺寸                                   */
slcconf     varchar2(1),             /*资料有效码                             */
slcdate     date,                    /*资料更改日期                           */
slcgrup     varchar2(10),            /*资料所属群组                           */
slcmodu     varchar2(10),            /*资料更改者                             */
slcuser     varchar2(10),            /*资料用户                               */
slcoriu     varchar2(10),            /*资料建立者                             */
slcorig     varchar2(10)             /*资料建立部门                           */
);

alter table slc_file add  constraint slc_pk primary key  (slc01,slc02) enable validate;
grant select on slc_file to tiptopgp;
grant update on slc_file to tiptopgp;
grant delete on slc_file to tiptopgp;
grant insert on slc_file to tiptopgp;
grant index on slc_file to public;
grant select on slc_file to ods;
