/*
================================================================================
檔案代號:aess_file
檔案名稱:合并财报现金变动码维护作业
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table aess_file
(
aess00      varchar2(5) DEFAULT ' ' NOT NULL, /*帐套*/
aess01      varchar2(10) DEFAULT ' ' NOT NULL, /*公司编号*/
aess02      varchar2(10) DEFAULT ' ' NOT NULL, /*集团代号*/
aess03      varchar2(4) DEFAULT ' ' NOT NULL, /*來源公司現金變動碼*/
aess04      varchar2(40),            /*说明                                   */
aess05      varchar2(2),             /*來源公司現金變動碼分類                 */
aess06      varchar2(4),
aess07      varchar2(1) DEFAULT ' ' NOT NULL, /*再衡量汇率类型*/
aess08      varchar2(1) DEFAULT ' ' NOT NULL, /*换算汇率类型*/
aessacti    varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
aessdate    date,                    /*最近更改日                             */
aessgrup    varchar2(10),            /*资料所有群                             */
aessmodu    varchar2(10),            /*资料更改者                             */
aessorig    varchar2(10),            /*资料建立部门                           */
aessoriu    varchar2(10),            /*资料建立者                             */
aessuser    varchar2(10)             /*资料所有者                             */
);

alter table aess_file add  constraint aess_pk primary key  (aess00,aess01,aess02,aess03) enable validate;
grant select on aess_file to tiptopgp;
grant update on aess_file to tiptopgp;
grant delete on aess_file to tiptopgp;
grant insert on aess_file to tiptopgp;
grant index on aess_file to public;
grant select on aess_file to ods;
