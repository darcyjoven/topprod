/*
================================================================================
檔案代號:rxf_file
檔案名稱:代收/退款档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rxf_file
(
rxf00       varchar2(1) DEFAULT ' ' NOT NULL, /*单据类型*/
rxf01       varchar2(20) DEFAULT ' ' NOT NULL, /*代收/退款单号*/
rxf02       date,                    /*单据日期                               */
rxf03       varchar2(10),            /*订货营运中心                           */
rxf04       varchar2(20),            /*出货单号/销退单号                      */
rxf05       number(20,6) DEFAULT '0' NOT NULL, /*订单总额*/
rxf06       number(20,6) DEFAULT '0' NOT NULL, /*订金金额*/
rxf07       number(20,6) DEFAULT '0' NOT NULL, /*应收金额*/
rxf08       number(20,6) DEFAULT '0' NOT NULL, /*已收金额*/
rxf09       varchar2(10),            /*代收人员                               */
rxf10       varchar2(10),            /*部门编号                               */
rxf11       varchar2(20),            /*POS单号                                */
rxf12       varchar2(20),            /*账款编号                               */
rxf13       varchar2(255),           /*备注                                   */
rxfacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
rxfcond     date,                    /*审核日期                               */
rxfconf     varchar2(1) DEFAULT ' ' NOT NULL, /*确认码*/
rxfcont     varchar2(8),             /*审核时间                               */
rxfconu     varchar2(10),            /*审核人员                               */
rxfcrat     date,                    /*资料创建日                             */
rxfdate     date,                    /*最近更改日                             */
rxfgrup     varchar2(10),            /*资料所有群                             */
rxflegal    varchar2(10) NOT NULL,   /*所属法人                               */
rxfmodu     varchar2(10),            /*资料更改者                             */
rxforig     varchar2(10),            /*资料建立部门                           */
rxforiu     varchar2(10),            /*资料建立者                             */
rxfplant    varchar2(10) DEFAULT ' ' NOT NULL, /*所属营运中心*/
rxfuser     varchar2(10)             /*资料所有者                             */
);

create unique index rxf_01 on rxf_file (rxf01);
alter table rxf_file add  constraint rxf_pk primary key  (rxf00,rxf01) enable validate;
grant select on rxf_file to tiptopgp;
grant update on rxf_file to tiptopgp;
grant delete on rxf_file to tiptopgp;
grant insert on rxf_file to tiptopgp;
grant index on rxf_file to public;
grant select on rxf_file to ods;
