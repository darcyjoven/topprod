/*
================================================================================
檔案代號:add_file
檔案名稱:集团调拨申请单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table add_file
(
add00       varchar2(1),             /*调拨类型                               */
add01       varchar2(20) NOT NULL,   /*调拨申请单号                           */
add02       date,                    /*申请日期                               */
add03       varchar2(10),            /*员工编号                               */
add04       varchar2(10),            /*部门编号                               */
add05       varchar2(255),           /*备注                                   */
add06       varchar2(1),             /*状况码                                 */
add07       varchar2(1),             /*结案否                                 */
add08       date,                    /*结案日期                               */
addmksg     varchar2(1),             /*是否签核                               */
addsign     varchar2(4),             /*签核等级                               */
adddays     number(5),               /*签核完成天数                           */
addprit     number(5),               /*签核优先等级                           */
addsseq     number(5),               /*已签核顺序                             */
addsmax     number(5),               /*应签核顺序                             */
addconf     varchar2(1),             /*审核                                   */
addprsw     number(5),               /*打印次数                               */
addacti     varchar2(1),             /*资料有效码                             */
adduser     varchar2(10),            /*资料所有者                             */
addgrup     varchar2(10),            /*资料所有部门                           */
addmodu     varchar2(10),            /*资料更改者                             */
adddate     date,                    /*最近更改日                             */
addplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
addlegal    varchar2(10) NOT NULL,   /*所属法人                               */
addorig     varchar2(10),            /*资料建立部门                           */
addoriu     varchar2(10)             /*资料建立者                             */
);

alter table add_file add  constraint add_pk primary key  (add01) enable validate;
grant select on add_file to tiptopgp;
grant update on add_file to tiptopgp;
grant delete on add_file to tiptopgp;
grant insert on add_file to tiptopgp;
grant index on add_file to public;
grant select on add_file to ods;
