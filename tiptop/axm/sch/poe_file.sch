/*
================================================================================
檔案代號:poe_file
檔案名稱:客户产品接单流程文件
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table poe_file
(
poe01       varchar2(10) NOT NULL,   /*客户编号                               */
poe02       varchar2(10) NOT NULL,   /*产品分类码                             */
poe03       varchar2(40) NOT NULL,   /*产品编号                               */
poe04       varchar2(8),             /*内部流程代码                           */
poe05       varchar2(5),             /*缺省采购单单别                         */
poeacti     varchar2(1),             /*资料有效码                             */
poeuser     varchar2(10),            /*资料所有者                             */
poegrup     varchar2(10),            /*资料所有群                             */
poemodu     varchar2(10),            /*资料更改者                             */
poedate     date,                    /*最近更改日                             */
poeorig     varchar2(10),            /*资料建立部门                           */
poeoriu     varchar2(10)             /*资料建立者                             */
);

alter table poe_file add  constraint poe_pk primary key  (poe01,poe02,poe03) enable validate;
grant select on poe_file to tiptopgp;
grant update on poe_file to tiptopgp;
grant delete on poe_file to tiptopgp;
grant insert on poe_file to tiptopgp;
grant index on poe_file to public;
grant select on poe_file to ods;
