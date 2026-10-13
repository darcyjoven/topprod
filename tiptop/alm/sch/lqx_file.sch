/*
================================================================================
檔案代號:lqx_file
檔案名稱:换物变更设定单头档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lqx_file
(
lqx00       varchar2(1) DEFAULT ' ' NOT NULL, /*兑换来源*/
                                     /*0.积分换物, 1.累计消费额换物           */
lqx01       varchar2(20) DEFAULT ' ' NOT NULL, /*兑换方案代码*/
lqx02       varchar2(20) DEFAULT ' ' NOT NULL, /*卡种代号*/
lqx03       date,                    /*起始日期                               */
lqx04       date,                    /*终止日期                               */
lqx05       varchar2(1) DEFAULT ' ' NOT NULL, /*确认码*/
lqx06       varchar2(10),            /*审核人                                 */
lqx07       date,                    /*审核日期                               */
lqx08       varchar2(50),            /*备注                                   */
lqx09       varchar2(1) DEFAULT ' ' NOT NULL, /*累计消费额方式*/
                                     /*0.消费日当天, 1.会员累计消费额         */
lqx10       varchar2(10) DEFAULT ' ' NOT NULL, /*制订营运中心*/
lqx11       number(5) DEFAULT '0' NOT NULL, /*兑换方案版本号*/
lqx12       varchar2(1) DEFAULT ' ' NOT NULL, /*兑换限制*/
                                     /*1.不限兑换次数, 2.期间限制兑换次数, 3.一天限制兑换次数*/
lqx13       number(5),               /*兑换次数                               */
lqxacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
lqxcrat     date,                    /*资料创建日                             */
lqxdate     date,                    /*最近更改日                             */
lqxgrup     varchar2(10),            /*资料所有群                             */
lqxlegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
lqxmodu     varchar2(10),            /*资料更改者                             */
lqxorig     varchar2(10),            /*资料建立部门                           */
lqxoriu     varchar2(10),            /*资料建立者                             */
lqxplant    varchar2(10) DEFAULT ' ' NOT NULL, /*所属营运中心*/
lqxuser     varchar2(10)             /*资料所有者                             */
);

alter table lqx_file add  constraint lqx_pk primary key  (lqx00,lqx01,lqx02,lqx10,lqx11,lqxplant) enable validate;
grant select on lqx_file to tiptopgp;
grant update on lqx_file to tiptopgp;
grant delete on lqx_file to tiptopgp;
grant insert on lqx_file to tiptopgp;
grant index on lqx_file to public;
grant select on lqx_file to ods;
