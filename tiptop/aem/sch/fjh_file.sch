/*
================================================================================
檔案代號:fjh_file
檔案名稱:设备系统单据性质档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table fjh_file
(
fjhslip     varchar2(5) NOT NULL,    /*单别                                   */
fjhdesc     varchar2(80),            /*单据名称                               */
fjhauno     varchar2(1),             /*自动编号否 (y/n)                       */
fjhkind     varchar2(1),             /*编号方式                               */
fjhconf     varchar2(1),             /*立即审核                               */
fjhprit     varchar2(1),             /*立即打印                               */
fjhtype     varchar2(2),             /*单据性质                               */
fjhacti     varchar2(1),             /*资料有效码                             */
fjhuser     varchar2(10),            /*资料所有者                             */
fjhgrup     varchar2(10),            /*资料所有部门                           */
fjhmodu     varchar2(10),            /*资料更改者                             */
fjhdate     date,                    /*最近更改日                             */
fjhorig     varchar2(10),            /*资料建立部门                           */
fjhoriu     varchar2(10)             /*资料建立者                             */
);

alter table fjh_file add  constraint fjh_pk primary key  (fjhslip) enable validate;
grant select on fjh_file to tiptopgp;
grant update on fjh_file to tiptopgp;
grant delete on fjh_file to tiptopgp;
grant insert on fjh_file to tiptopgp;
grant index on fjh_file to public;
grant select on fjh_file to ods;
