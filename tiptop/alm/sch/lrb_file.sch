/*
================================================================================
檔案代號:lrb_file
檔案名稱:会员换赠设定第一单身档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lrb_file
(
lrb01       varchar2(20) DEFAULT ' ' NOT NULL, /*会员换赠方案编号*/
lrb02       number(5) DEFAULT '0' NOT NULL, /*项次*/
lrb03       varchar2(20),            /*卡种编号                               */
lrb04       varchar2(30),            /*卡种名称                               */
lrb05       varchar2(10),            /*纪念日编号                             */
lrb06       varchar2(1) DEFAULT ' ' NOT NULL, /*日期类型*/
lrb07       number(5),               /*最多可选品种个数                       */
lrb08       varchar2(1) DEFAULT ' ' NOT NULL, /*允许重复换赠*/
lrbacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
lrbdate     date,                    /*最近更改日                             */
lrbgrup     varchar2(10),            /*资料所有群                             */
lrbmodu     varchar2(10),            /*资料更改者                             */
lrborig     varchar2(10),            /*资料建立部门                           */
lrboriu     varchar2(10),            /*资料建立者                             */
lrbuser     varchar2(10)             /*资料所有者                             */
);

alter table lrb_file add  constraint lrb_pk primary key  (lrb01,lrb02) enable validate;
grant select on lrb_file to tiptopgp;
grant update on lrb_file to tiptopgp;
grant delete on lrb_file to tiptopgp;
grant insert on lrb_file to tiptopgp;
grant index on lrb_file to public;
grant select on lrb_file to ods;
