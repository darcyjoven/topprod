/*
================================================================================
檔案代號:rua_file
檔案名稱:自动补货单单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rua_file
(
rua01       varchar2(20) DEFAULT ' ' NOT NULL, /*补货建议单号*/
rua02       date,                    /*建议日期                               */
rua03       varchar2(10),            /*建议人员                               */
rua04       number(5,2),             /*建议系数%                              */
rua05       varchar2(255),           /*備注                                   */
rua06       varchar2(20),            /*请购单号                               */
ruaacti     varchar2(1) DEFAULT 'Y' NOT NULL, /*资料有效码*/
ruacond     date,                    /*审核日期                               */
ruaconf     varchar2(1) DEFAULT 'N' NOT NULL, /*确认码*/
ruaconu     varchar2(10),            /*审核人员                               */
ruacrat     date,                    /*资料创建日                             */
ruadate     date,                    /*最近更改日                             */
ruagrup     varchar2(10),            /*资料所有部门                           */
rualegal    varchar2(10) NOT NULL,   /*所属法人                               */
ruamodu     varchar2(10),            /*资料更改者                             */
ruaorig     varchar2(10),            /*资料建立部门                           */
ruaoriu     varchar2(10),            /*资料建立者                             */
ruaplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
ruauser     varchar2(10)             /*资料所有者                             */
);

alter table rua_file add  constraint rua_pk primary key  (rua01) enable validate;
grant select on rua_file to tiptopgp;
grant update on rua_file to tiptopgp;
grant delete on rua_file to tiptopgp;
grant insert on rua_file to tiptopgp;
grant index on rua_file to public;
grant select on rua_file to ods;
