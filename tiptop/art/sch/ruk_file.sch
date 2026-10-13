/*
================================================================================
檔案代號:ruk_file
檔案名稱:赠品入库/出库单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ruk_file
(
ruk00       varchar2(1) DEFAULT ' ' NOT NULL, /*单据类型1-入库单 2-出库单*/
ruk01       varchar2(20) DEFAULT ' ' NOT NULL, /*赠品入库/出库单*/
ruk02       varchar2(20),            /*来源单号(单号类型为2-出库单            */
ruk04       date,                    /*入库/出库日期                          */
ruk05       varchar2(10),            /*经办人员                               */
ruk06       varchar2(255),           /*備注                                   */
rukacti     varchar2(1),             /*资料有效码                             */
rukcond     date,                    /*审核日期                               */
rukconf     varchar2(1) DEFAULT 'N' NOT NULL, /*审核码Y-以审核N-未审核X-作废*/
rukconu     varchar2(10),            /*审核人员                               */
rukcrat     date,                    /*资料创建日                             */
rukdate     date,                    /*最近更改日                             */
ruklegal    varchar2(10) NOT NULL,   /*所属法人                               */
rukmodu     varchar2(10),            /*资料更改者                             */
rukorig     varchar2(10),            /*资料建立部门                           */
rukoriu     varchar2(10),            /*资料建立者                             */
rukplant    varchar2(10) DEFAULT ' ' NOT NULL, /*所属营运中心*/
rukuser     varchar2(10),            /*资料所有者                             */
ruk03       varchar2(10),            /*供应商                                 */
rukgrup     varchar2(10)             /*资料所有部门                           */
);

alter table ruk_file add  constraint ruk_pk primary key  (ruk00,ruk01,rukplant) enable validate;
grant select on ruk_file to tiptopgp;
grant update on ruk_file to tiptopgp;
grant delete on ruk_file to tiptopgp;
grant insert on ruk_file to tiptopgp;
grant index on ruk_file to public;
grant select on ruk_file to ods;
