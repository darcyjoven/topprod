/*
================================================================================
檔案代號:imad_file
檔案名稱:申请料件特性基本资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table imad_file
(
imad01      varchar2(40) DEFAULT ' ' NOT NULL, /*料件编号*/
imad02      number(5) DEFAULT '0' NOT NULL, /*项次*/
imad03      varchar2(1),             /*归属层级                               */
imad04      varchar2(10),            /*特性代码                               */
imad05      varchar2(40),            /*特性值                                 */
imaddate    date,                    /*最近更改日                             */
imadgrup    varchar2(10),            /*资料所有群                             */
imadmodu    varchar2(10),            /*资料更改者                             */
imadorig    varchar2(10),            /*资料建立部门                           */
imadoriu    varchar2(10),            /*资料建立者                             */
imaduser    varchar2(10)             /*资料所有者                             */
);

alter table imad_file add  constraint imad_pk primary key  (imad01,imad02) enable validate;
grant select on imad_file to tiptopgp;
grant update on imad_file to tiptopgp;
grant delete on imad_file to tiptopgp;
grant insert on imad_file to tiptopgp;
grant index on imad_file to public;
grant select on imad_file to ods;
