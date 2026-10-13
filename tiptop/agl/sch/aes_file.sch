/*
================================================================================
檔案代號:aes_file
檔案名稱:母公司现金流量表维护作业
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table aes_file
(
aes01       varchar2(4) DEFAULT ' ' NOT NULL, /*现金异动码*/
aes02       varchar2(100),           /*说明                                   */
aes03       varchar2(2),             /*变动分类                               */
aes05       number(5),               /*行序                                   */
aesacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
aesdate     date,                    /*最近更改日                             */
aesgrup     varchar2(10),            /*资料所有群                             */
aesmodu     varchar2(10),            /*资料更改者                             */
aesorig     varchar2(10),            /*资料建立部门                           */
aesoriu     varchar2(10),            /*资料建立者                             */
aesuser     varchar2(10)             /*资料所有者                             */
);

alter table aes_file add  constraint aes_pk primary key  (aes01) enable validate;
grant select on aes_file to tiptopgp;
grant update on aes_file to tiptopgp;
grant delete on aes_file to tiptopgp;
grant insert on aes_file to tiptopgp;
grant index on aes_file to public;
grant select on aes_file to ods;
