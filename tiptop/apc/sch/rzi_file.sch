/*
================================================================================
檔案代號:rzi_file
檔案名稱:POS触屏方案设置档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table rzi_file
(
rzi01       varchar2(20) DEFAULT ' ' NOT NULL, /*方案编号*/
rzi02       varchar2(255),           /*方案说明                               */
rzi03       number(5),               /*大类行数                               */
rzi04       number(5),               /*大类列数                               */
rzi05       number(5),               /*小类行数                               */
rzi06       number(5),               /*小类列数                               */
rzi07       number(5),               /*产品行数                               */
rzi08       number(5),               /*产品列数                               */
rziacti     varchar2(1) NOT NULL,    /*资料有效码                             */
rzicrat     date,                    /*资料创建日                             */
rzidate     date,                    /*最近更改日                             */
rzigrup     varchar2(10),            /*资料所有群                             */
rzimodu     varchar2(10),            /*资料更改者                             */
rziorig     varchar2(10),            /*资料建立部门                           */
rzioriu     varchar2(10),            /*资料建立者                             */
rzipos      varchar2(1) DEFAULT ' ' NOT NULL, /*已传POS否*/
rziuser     varchar2(10),            /*资料所有者                             */
rzi09       varchar2(1) DEFAULT ' ' NOT NULL
);

alter table rzi_file add  constraint rzi_pk primary key  (rzi01) enable validate;
grant select on rzi_file to tiptopgp;
grant update on rzi_file to tiptopgp;
grant delete on rzi_file to tiptopgp;
grant insert on rzi_file to tiptopgp;
grant index on rzi_file to public;
grant select on rzi_file to ods;
