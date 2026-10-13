/*
================================================================================
檔案代號:vii_file
檔案名稱:No Use
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table vii_file
(
vii01       varchar2(10) NOT NULL,   /*积分使用规则编码                       */
vii02       varchar2(80),            /*积分使用规则说明                       */
vii03       varchar2(1),             /*使用方式                               */
vii04       date,                    /*生效日期                               */
vii05       date,                    /*失效日期                               */
vii06       varchar2(1),             /*确认码                                 */
viiacti     varchar2(1),             /*资料有效码                             */
viidate     date,                    /*最近更改日                             */
viigrup     varchar2(10),            /*资料所有部门                           */
viimodu     varchar2(10),            /*资料更改者                             */
viiuser     varchar2(10),            /*资料所有者                             */
viiorig     varchar2(10),            /*资料建立部门                           */
viioriu     varchar2(10)             /*资料建立者                             */
);

alter table vii_file add  constraint vii_pk primary key  (vii01) enable validate;
grant select on vii_file to tiptopgp;
grant update on vii_file to tiptopgp;
grant delete on vii_file to tiptopgp;
grant insert on vii_file to tiptopgp;
grant index on vii_file to public;
grant select on vii_file to ods;
