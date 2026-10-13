/*
================================================================================
檔案代號:obi_file
檔案名稱:混合包装方式档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table obi_file
(
obi01       varchar2(20) DEFAULT ' ' NOT NULL, /*混装编号*/
obi02       varchar2(80),            /*包装说明                               */
obi03       number(15,3),            /*包装长度                               */
obi04       number(15,3),            /*包装宽度                               */
obi05       number(15,3),            /*包装高度                               */
obi06       number(15,3),            /*包装内长                               */
obi07       number(15,3),            /*包装内宽                               */
obi08       number(15,3),            /*包装内高                               */
obi09       number(15,3),            /*包装体积                               */
obi10       number(15,3),            /*包装容积                               */
obi11       number(15,3),            /*包装重量                               */
obi12       varchar2(10),            /*末维属性组                             */
obi13       varchar2(255),           /*备注                                   */
obi14       varchar2(10),            /*属性群组                               */
obiacti     varchar2(1),             /*资料有效码                             */
obidate     date,                    /*资料更改日期                           */
obigrup     varchar2(10),            /*资料所属群组                           */
obimodu     varchar2(10),            /*资料更改者                             */
obiuser     varchar2(10),            /*资料所有者                             */
obioriu     varchar2(10),            /*资料建立者                             */
obiorig     varchar2(10)             /*资料建立部门                           */
);

alter table obi_file add  constraint obi_pk primary key  (obi01) enable validate;
grant select on obi_file to tiptopgp;
grant update on obi_file to tiptopgp;
grant delete on obi_file to tiptopgp;
grant insert on obi_file to tiptopgp;
grant index on obi_file to public;
grant select on obi_file to ods;
