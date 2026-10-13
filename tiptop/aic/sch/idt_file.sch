/*
================================================================================
檔案代號:idt_file
檔案名稱:ICD母子批号关联档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table idt_file
(
idt01       varchar2(24) DEFAULT ' ' NOT NULL, /*母批号*/
idt02       varchar2(24) DEFAULT ' ' NOT NULL, /*子批号*/
idtacti     varchar2(1) DEFAULT 'Y' NOT NULL, /*资料有效码*/
idtdate     date,                    /*最近更改日                             */
idtgrup     varchar2(10),            /*资料所有群                             */
idtmodu     varchar2(10),            /*资料更改者                             */
idtorig     varchar2(10),            /*资料建立部门                           */
idtoriu     varchar2(10),            /*资料建立者                             */
idtuser     varchar2(10)             /*资料所有者                             */
);

alter table idt_file add  constraint idt_pk primary key  (idt01,idt02) enable validate;
grant select on idt_file to tiptopgp;
grant update on idt_file to tiptopgp;
grant delete on idt_file to tiptopgp;
grant insert on idt_file to tiptopgp;
grant index on idt_file to public;
grant select on idt_file to ods;
