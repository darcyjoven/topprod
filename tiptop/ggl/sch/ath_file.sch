/*
================================================================================
檔案代號:ath_file
檔案名稱:合并财报现金异动码维护作业
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ath_file
(
ath00       varchar2(5) DEFAULT ' ' NOT NULL, /*帐别*/
ath01       varchar2(10) DEFAULT ' ' NOT NULL, /*公司编号*/
ath02       varchar2(10) DEFAULT ' ' NOT NULL, /*族群编号*/
ath03       varchar2(4) DEFAULT ' ' NOT NULL, /*来源公司现金异动码*/
ath04       varchar2(40),            /*说明                                   */
ath05       varchar2(2),             /*来源公司现金变动码分类                 */
ath06       varchar2(4),             /*合并后现金异动码                       */
ath07       varchar2(1) DEFAULT ' ' NOT NULL, /*再衡量汇率类型*/
ath08       varchar2(1) DEFAULT ' ' NOT NULL, /*换算汇率类型*/
athacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
athdate     date,                    /*最近更改日                             */
athgrup     varchar2(10),            /*资料所有群                             */
athmodu     varchar2(10),            /*资料更改者                             */
athorig     varchar2(10),            /*资料建立部门                           */
athoriu     varchar2(10),            /*资料建立者                             */
athuser     varchar2(10)             /*资料所有者                             */
);

alter table ath_file add  constraint ath_pk primary key  (ath00,ath01,ath02,ath03) enable validate;
grant select on ath_file to tiptopgp;
grant update on ath_file to tiptopgp;
grant delete on ath_file to tiptopgp;
grant insert on ath_file to tiptopgp;
grant index on ath_file to public;
grant select on ath_file to ods;
