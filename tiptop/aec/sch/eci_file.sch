/*
================================================================================
檔案代號:eci_file
檔案名稱:生产机器档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table eci_file
(
eci01       varchar2(10) NOT NULL,   /*机器编号                               */
eci02       varchar2(20),            /*标签编号                               */
eci03       varchar2(10),            /*工作中心编号                           */
eci04       number(20,6),            /*机器成本                               */
eci05       number(10),              /*机器产能                               */
eci06       varchar2(80),            /*机器说明                               */
eci07       number(5),               /*生产员工数                             */
eci08       number(5),               /*顺序                                   */
eciacti     varchar2(1),             /*资料有效码                             */
eciuser     varchar2(10),            /*资料所有者                             */
ecigrup     varchar2(10),            /*资料所有群                             */
ecimodu     varchar2(10),            /*资料更改者                             */
ecidate     date,                    /*最近更改日                             */
eci09       number(10),              /*人工最大产能                           */
ecioriu     varchar2(10),            /*资料建立者                             */
eciorig     varchar2(10),            /*资料建立部门                           */
eci10       number(15,3)             /*机器数量                               */
);

alter table eci_file add  constraint eci_pk primary key  (eci01) enable validate;
grant select on eci_file to tiptopgp;
grant update on eci_file to tiptopgp;
grant delete on eci_file to tiptopgp;
grant insert on eci_file to tiptopgp;
grant index on eci_file to public;
grant select on eci_file to ods;
