/*
================================================================================
檔案代號:bog_file
檔案名稱:固定属性变更单头档
檔案目的:固定属性变更单头档 双档单头
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table bog_file
(
bog01       varchar2(20) DEFAULT ' ' NOT NULL, /*变更单号*/
bog02       date DEFAULT sysdate NOT NULL, /*变更日期*/
bog03       varchar2(1) DEFAULT ' ' NOT NULL, /*审核码 y-审核 n-未审核 x-作废*/
bog04       varchar2(1) DEFAULT ' ' NOT NULL, /*发放码 y-发放,n-未发放*/
bog05       date,                    /*发放日期                               */
bog06       varchar2(80),            /*备注                                   */
bogacti     varchar2(1),             /*资料有效码                             */
bogdate     date,                    /*资料更改日期                           */
boggrup     varchar2(10),            /*资料所属群组                           */
bogmodu     varchar2(10),            /*资料更改者                             */
boguser     varchar2(10),            /*资料所有者                             */
bogoriu     varchar2(10),            /*资料建立者                             */
bogorig     varchar2(10)             /*资料建立部门                           */
);

alter table bog_file add  constraint bog_pk primary key  (bog01) enable validate;
grant select on bog_file to tiptopgp;
grant update on bog_file to tiptopgp;
grant delete on bog_file to tiptopgp;
grant insert on bog_file to tiptopgp;
grant index on bog_file to public;
grant select on bog_file to ods;
