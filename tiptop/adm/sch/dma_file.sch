/*
================================================================================
檔案代號:dma_file
檔案名稱:类型代码档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table dma_file
(
dma01       varchar2(6) NOT NULL,    /*类型代码                               */
dma02       varchar2(80),            /*类型说明                               */
dmaacti     varchar2(1),             /*资料有效码                             */
dmauser     varchar2(10),            /*资料所有者                             */
dmagrup     varchar2(10),            /*资料所有群                             */
dmamodu     varchar2(10),            /*资料更改者                             */
dmadate     date,                    /*最近更改日                             */
dmaorig     varchar2(10),            /*资料建立部门                           */
dmaoriu     varchar2(10)             /*资料建立者                             */
);

alter table dma_file add  constraint dma_pk primary key  (dma01) enable validate;
grant select on dma_file to tiptopgp;
grant update on dma_file to tiptopgp;
grant delete on dma_file to tiptopgp;
grant insert on dma_file to tiptopgp;
grant index on dma_file to public;
grant select on dma_file to ods;
