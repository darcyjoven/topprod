/*
================================================================================
檔案代號:adf_file
檔案名稱:集团拨出单单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table adf_file
(
adf00       varchar2(1),             /*调拨类型                               */
adf01       varchar2(20) NOT NULL,   /*拨出单号                               */
adf02       date,                    /*单据日期                               */
adf03       varchar2(10),            /*员工编号                               */
adf04       varchar2(10),            /*部门编号                               */
adf05       varchar2(6),             /*调拨流程                               */
adf06       date,                    /*预计抵达日期                           */
adf07       varchar2(10),            /*在途仓                                 */
adf08       varchar2(255),           /*备注                                   */
adf09       date,                    /*过帐日期                               */
adf10       varchar2(1),             /*状况码                                 */
adfmksg     varchar2(1),             /*是否签核                               */
adfsign     varchar2(4),             /*签核等级                               */
adfdays     number(5),               /*签核完成天数                           */
adfprit     number(5),               /*签核优先等级                           */
adfsseq     number(5),               /*已签核顺序                             */
adfsmax     number(5),               /*应签核顺序                             */
adfconf     varchar2(1),             /*审核                                   */
adfpost     varchar2(1),             /*过帐否                                 */
adfprsw     number(5),               /*打印次数                               */
adfacti     varchar2(1),             /*资料有效码                             */
adfuser     varchar2(10),            /*资料所有者                             */
adfgrup     varchar2(10),            /*资料所有部门                           */
adfmodu     varchar2(10),            /*资料更改者                             */
adfdate     date,                    /*最近更改日                             */
adfplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
adflegal    varchar2(10) NOT NULL,   /*所属法人                               */
adforig     varchar2(10),            /*资料建立部门                           */
adforiu     varchar2(10)             /*资料建立者                             */
);

create        index adf_02 on adf_file (adf02,adf01);
alter table adf_file add  constraint adf_pk primary key  (adf01) enable validate;
grant select on adf_file to tiptopgp;
grant update on adf_file to tiptopgp;
grant delete on adf_file to tiptopgp;
grant insert on adf_file to tiptopgp;
grant index on adf_file to public;
grant select on adf_file to ods;
