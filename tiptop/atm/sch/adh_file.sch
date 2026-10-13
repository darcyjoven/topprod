/*
================================================================================
檔案代號:adh_file
檔案名稱:集团拨入单单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table adh_file
(
adh00       varchar2(1),             /*调拨类型                               */
adh01       varchar2(20) NOT NULL,   /*拨入单号                               */
adh02       date,                    /*单据日期                               */
adh03       varchar2(10),            /*员工编号                               */
adh04       varchar2(10),            /*部门编号                               */
adh05       varchar2(255),           /*备注                                   */
adh06       date,                    /*过帐日期                               */
adh07       varchar2(1),             /*状况码                                 */
adhmksg     varchar2(1),             /*是否签核                               */
adhsign     varchar2(4),             /*签核等级                               */
adhdays     number(5),               /*签核完成天数                           */
adhprit     number(5),               /*签核优先等级                           */
adhsseq     number(5),               /*已签核顺序                             */
adhsmax     number(5),               /*应签核顺序                             */
adhconf     varchar2(1),             /*审核                                   */
adhprsw     number(5),               /*打印次数                               */
adhacti     varchar2(1),             /*资料有效码                             */
adhpost     varchar2(1),             /*过帐否                                 */
adhuser     varchar2(10),            /*资料所有者                             */
adhgrup     varchar2(10),            /*资料所有部门                           */
adhmodu     varchar2(10),            /*资料更改者                             */
adhdate     date,                    /*最近更改日                             */
adhplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
adhlegal    varchar2(10) NOT NULL,   /*所属法人                               */
adhorig     varchar2(10),            /*资料建立部门                           */
adhoriu     varchar2(10)             /*资料建立者                             */
);

create        index adh_02 on adh_file (adh02,adh01);
alter table adh_file add  constraint adh_pk primary key  (adh01) enable validate;
grant select on adh_file to tiptopgp;
grant update on adh_file to tiptopgp;
grant delete on adh_file to tiptopgp;
grant insert on adh_file to tiptopgp;
grant index on adh_file to public;
grant select on adh_file to ods;
