/*
================================================================================
檔案代號:lrc_file
檔案名稱:会员换赠设定第二单身档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lrc_file
(
lrc01       varchar2(20) DEFAULT ' ' NOT NULL, /*会员换赠方案编号*/
lrc02       number(5) DEFAULT '0' NOT NULL, /*项次*/
lrc03       varchar2(2) DEFAULT ' ' NOT NULL, /*资料类型*/
lrc04       varchar2(40) DEFAULT ' ' NOT NULL, /*代码*/
lrc05       varchar2(4),             /*单位                                   */
lrcacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
lrcdate     date,                    /*最近更改日                             */
lrcgrup     varchar2(10),            /*资料所有群                             */
lrcorig     varchar2(10),            /*资料建立部门                           */
lrcoriu     varchar2(10),            /*资料建立者                             */
lrcuser     varchar2(10),            /*资料所有者                             */
lrcmodu     varchar2(10)             /*资料更改者                             */
);

alter table lrc_file add  constraint lrc_pk primary key  (lrc01,lrc02,lrc03,lrc04) enable validate;
grant select on lrc_file to tiptopgp;
grant update on lrc_file to tiptopgp;
grant delete on lrc_file to tiptopgp;
grant insert on lrc_file to tiptopgp;
grant index on lrc_file to public;
grant select on lrc_file to ods;
