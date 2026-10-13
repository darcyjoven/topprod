/*
================================================================================
檔案代號:rta_file
檔案名稱:商品条码资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table rta_file
(
rta01       varchar2(40) DEFAULT ' ' NOT NULL, /*产品编号*/
rta02       number(5) DEFAULT '0' NOT NULL, /*项次*/
rta03       varchar2(4),             /*单位代码                               */
rta04       varchar2(1),             /*条码类型                               */
                                     /*条码类型 1-原印码,2-自编码             */
rta05       varchar2(40) DEFAULT ' ' NOT NULL, /*条码*/
rtaacti     varchar2(1),             /*有效否 Y-有效,N-无效                   */
rtapos      varchar2(1) DEFAULT '1', /*no use                                 */
rta06       varchar2(10),            /*版本                                   */
rta07       varchar2(10),            /*货号                                   */
rta08       varchar2(10),            /*成份                                   */
rta09       varchar2(10),            /*等级                                   */
rta10       varchar2(10),            /*产地                                   */
rta11       varchar2(10),            /*厂商编号                               */
rtaud01     varchar2(10),            /*自定义字段                             */
rtaud02     varchar2(10),            /*自定义字段                             */
rtaud03     varchar2(10),            /*自定义字段                             */
rtaud04     varchar2(10),            /*自定义字段                             */
rtaud05     varchar2(10),            /*自定义字段                             */
rtaud06     varchar2(10),            /*自定义字段                             */
rtaud07     varchar2(10),            /*自定义字段                             */
rtaud08     varchar2(10),            /*自定义字段                             */
rtaud09     varchar2(10),            /*自定义字段                             */
rtaud10     varchar2(10)             /*自定义字段                             */
);

create unique index rta_01 on rta_file (rta05);
alter table rta_file add  constraint rta_pk primary key  (rta01,rta02) enable validate;
grant select on rta_file to tiptopgp;
grant update on rta_file to tiptopgp;
grant delete on rta_file to tiptopgp;
grant insert on rta_file to tiptopgp;
grant index on rta_file to public;
grant select on rta_file to ods;
