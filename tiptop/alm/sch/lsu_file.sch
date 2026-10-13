/*
================================================================================
檔案代號:lsu_file
檔案名稱:换券变更设定单头
檔案目的:
上游檔案:
下游檔案:N
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lsu_file
(
lsu00       varchar2(1) DEFAULT ' ' NOT NULL, /*兑换来源*/
                                     /*0.积分换券, 1.累计消费额换券           */
lsu01       varchar2(20) DEFAULT ' ' NOT NULL, /*兑换方案代码*/
lsu02       varchar2(20) DEFAULT ' ' NOT NULL, /*卡种代号*/
lsu03       date,                    /*起始日期                               */
lsu04       date,                    /*终止日期                               */
lsu05       varchar2(1) DEFAULT ' ' NOT NULL, /*返券方式*/
lsu06       varchar2(1) DEFAULT ' ' NOT NULL, /*确认码*/
lsu07       varchar2(10),            /*审核人员                               */
lsu08       date,                    /*审核日期                               */
lsu09       varchar2(50),            /*备注                                   */
lsu10       varchar2(1) DEFAULT ' ' NOT NULL, /*累计消费额方式*/
                                     /*0.消费日当天, 1.会员累计消费额, 2.会员期间累计消费额*/
lsu11       varchar2(10) DEFAULT ' ' NOT NULL, /*制订营运中心*/
lsu12       number(5) DEFAULT '0' NOT NULL, /*兑换方案版本号*/
lsuacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
lsucrat     date,                    /*资料创建日                             */
lsudate     date,                    /*最近更改日                             */
lsugrup     varchar2(10),            /*资料所有群                             */
lsulegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
lsumodu     varchar2(10),            /*资料更改者                             */
lsuorig     varchar2(10),            /*资料建立部门                           */
lsuoriu     varchar2(10),            /*资料建立者                             */
lsuplant    varchar2(10) DEFAULT ' ' NOT NULL, /*所属营运中心*/
lsuuser     varchar2(10),            /*资料所有者                             */
lsu13       varchar2(1) DEFAULT ' ' NOT NULL, /*兑换限制*/
                                     /*1.不限兑换次数, 2.期间限制兑换次数, 3.一天限制兑换次数*/
lsu14       number(5)                /*兑换次数                               */
);

alter table lsu_file add  constraint lsu_pk primary key  (lsu00,lsu01,lsu02,lsu11,lsu12,lsuplant) enable validate;
grant select on lsu_file to tiptopgp;
grant update on lsu_file to tiptopgp;
grant delete on lsu_file to tiptopgp;
grant insert on lsu_file to tiptopgp;
grant index on lsu_file to public;
grant select on lsu_file to ods;
