/*
================================================================================
檔案代號:luk_file
檔案名稱:待抵单单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table luk_file
(
luk01       varchar2(20) DEFAULT ' ' NOT NULL, /*待抵单号*/
luk02       date,                    /*单据日期                               */
luk03       date,                    /*立账日期                               */
luk04       varchar2(1) DEFAULT ' ' NOT NULL, /*来源类型*/
luk05       varchar2(20),            /*来源单号                               */
luk06       varchar2(10),            /*商户编号                               */
luk07       varchar2(20),            /*摊位编号                               */
luk08       varchar2(20),            /*合约编号                               */
luk09       number(5),               /*合同版本号                             */
luk10       number(20,6),            /*待抵金额                               */
luk11       number(20,6),            /*已冲金额                               */
luk12       number(20,6),            /*已退金额                               */
luk13       varchar2(10),            /*业务人员                               */
luk14       varchar2(10),            /*部门编号                               */
luk15       varchar2(255),           /*备注                                   */
lukacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
lukcond     date,                    /*审核日期                               */
lukconf     varchar2(1) NOT NULL,    /*确认码                                 */
lukcont     varchar2(8),             /*审核时间                               */
lukconu     varchar2(10),            /*审核人                                 */
lukcrat     date,                    /*资料创建日                             */
lukdate     date,                    /*最近更改日                             */
lukgrup     varchar2(10),            /*资料所有群                             */
luklegal    varchar2(10) NOT NULL,   /*法人                                   */
lukmksg     varchar2(1) NOT NULL,    /*是否签核                               */
lukmodu     varchar2(10),            /*资料更改者                             */
lukorig     varchar2(10),            /*资料建立部门                           */
lukoriu     varchar2(10),            /*资料建立者                             */
lukplant    varchar2(10) NOT NULL,   /*门店编号                               */
lukuser     varchar2(10),            /*资料所有者                             */
luk16       varchar2(20)             /*财务单号                               */
);

alter table luk_file add  constraint luk_pk primary key  (luk01) enable validate;
grant select on luk_file to tiptopgp;
grant update on luk_file to tiptopgp;
grant delete on luk_file to tiptopgp;
grant insert on luk_file to tiptopgp;
grant index on luk_file to public;
grant select on luk_file to ods;
