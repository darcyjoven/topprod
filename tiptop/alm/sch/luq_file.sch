/*
================================================================================
檔案代號:luq_file
檔案名稱:终止结算单单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table luq_file
(
luq01       varchar2(20) DEFAULT ' ' NOT NULL, /*结算单号*/
luq02       date,                    /*单据日期                               */
luq03       varchar2(1) DEFAULT ' ' NOT NULL, /*结算类型*/
luq04       varchar2(20),            /*合约编号                               */
luq05       varchar2(10),            /*商户编号                               */
luq06       varchar2(20),            /*摊位编号                               */
luq07       number(20,6),            /*应收金额                               */
luq08       number(20,6),            /*已收金额                               */
luq09       number(20,6),            /*应退金额                               */
luq10       number(20,6),            /*已退金额                               */
luq11       varchar2(10),            /*业务人员                               */
luq12       varchar2(10),            /*部门                                   */
luq13       varchar2(255),           /*备注                                   */
luq14       varchar2(1) DEFAULT ' ' NOT NULL, /*状况码*/
luqacti     varchar2(1) NOT NULL,    /*资料有效码                             */
luqcond     date,                    /*审核日期                               */
luqconf     varchar2(1) NOT NULL,    /*审核否                                 */
luqcont     varchar2(8),             /*审核时间                               */
luqconu     varchar2(10),            /*审核人员                               */
luqcrat     date,                    /*资料创建日                             */
luqdate     date,                    /*最近更改日                             */
luqgrup     varchar2(10),            /*资料所有群                             */
luqlegal    varchar2(10) NOT NULL,   /*法人                                   */
luqmksg     varchar2(1) NOT NULL,    /*是否签核                               */
luqmodu     varchar2(10),            /*资料更改者                             */
luqorig     varchar2(10),            /*资料建立部门                           */
luqoriu     varchar2(10),            /*资料建立者                             */
luqplant    varchar2(10) NOT NULL,   /*门店编号                               */
luquser     varchar2(10)             /*资料所有者                             */
);

alter table luq_file add  constraint luq_pk primary key  (luq01) enable validate;
grant select on luq_file to tiptopgp;
grant update on luq_file to tiptopgp;
grant delete on luq_file to tiptopgp;
grant insert on luq_file to tiptopgp;
grant index on luq_file to public;
grant select on luq_file to ods;
