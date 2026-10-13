/*
================================================================================
檔案代號:rda_file
檔案名稱:要货模板基本资料档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table rda_file
(
rda01       varchar2(20) NOT NULL,   /*要货模板编号                           */
rda02       varchar2(120),           /*模板名称                               */
rda03       number(5),               /*要货到货天数                           */
rda04       varchar2(40) NOT NULL,   /*商品编号                               */
rdaacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
rdacond     date DEFAULT sysdate,    /*审核日期                               */
rdaconf     varchar2(1) DEFAULT ' ' NOT NULL, /*审核否*/
rdacont     varchar2(8),             /*审核时间                               */
rdaconu     varchar2(10),            /*审核人员                               */
rdadate     date,                    /*最近更改日                             */
rdagrup     varchar2(10),            /*资料所有群                             */
rdamodu     varchar2(10),            /*资料更改者                             */
rdaorig     varchar2(10),            /*资料建立部门                           */
rdaoriu     varchar2(10),            /*资料建立者                             */
rdauser     varchar2(10)             /*资料所有者                             */
);

alter table rda_file add  constraint rda_pk primary key  (rda01,rda04) enable validate;
grant select on rda_file to tiptopgp;
grant update on rda_file to tiptopgp;
grant delete on rda_file to tiptopgp;
grant insert on rda_file to tiptopgp;
grant index on rda_file to public;
grant select on rda_file to ods;
