/*
================================================================================
檔案代號:bzg_file
檔案名稱:保税机器设备年统计档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table bzg_file
(
bzg01       number(5) NOT NULL,      /*年度                                   */
bzg02       varchar2(20) NOT NULL,   /*机器设备编号                           */
bzg03       number(15,3),            /*期初数量                               */
bzg04       number(15,3),            /*入库数                                 */
bzg05       number(15,3),            /*外运数                                 */
bzg06       number(15,3),            /*报废数                                 */
bzg07       number(15,3),            /*除帐数                                 */
bzg08       number(15,3),            /*帐面结存数                             */
bzg09       number(15,3),            /*盘存数                                 */
bzg10       number(15,3),            /*期末数                                 */
bzgacti     varchar2(1),             /*资料有效码                             */
bzguser     varchar2(10),            /*资料所有者                             */
bzggrup     varchar2(10),            /*资料所有部门                           */
bzgmodu     varchar2(10),            /*资料更改者                             */
bzgdate     date,                    /*最近更改日                             */
bzgplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
bzglegal    varchar2(10) NOT NULL,   /*所属法人                               */
bzgorig     varchar2(10),            /*资料建立部门                           */
bzgoriu     varchar2(10)             /*资料建立者                             */
);

alter table bzg_file add  constraint bzg_pk primary key  (bzg01,bzg02) enable validate;
grant select on bzg_file to tiptopgp;
grant update on bzg_file to tiptopgp;
grant delete on bzg_file to tiptopgp;
grant insert on bzg_file to tiptopgp;
grant index on bzg_file to public;
grant select on bzg_file to ods;
