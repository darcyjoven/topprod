/*
================================================================================
檔案代號:rud_file
檔案名稱:需求分配单单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rud_file
(
rud01       varchar2(20) DEFAULT ' ' NOT NULL, /*需求分配单号*/
rud02       date,                    /*分配日期                               */
rud03       varchar2(10),            /*分配人员                               */
rud04       varchar2(255),           /*备注                                   */
rud900      varchar2(1),             /*状况码                                 */
                                     /*Status Code                            */
                                     /*0:Open 1:Confirmed 9:Void R:Transfer for Approval S:Rejected W:Withdraw*/
rudacti     varchar2(1),             /*资料有效码                             */
rudcond     date,                    /*审核日期                               */
rudconf     varchar2(1),             /*审核码                                 */
rudconu     varchar2(10),            /*审核人员                               */
rudcrat     date,                    /*资料创建日                             */
ruddate     date,                    /*最近更改日                             */
ruddays     number(5),               /*签核完成天数                           */
rudgrup     varchar2(10),            /*资料所有部门                           */
rudlegal    varchar2(10) NOT NULL,   /*所属法人                               */
rudmksg     varchar2(1),             /*是否签核                               */
rudmodu     varchar2(10),            /*资料更改者                             */
rudplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
rudprit     number(5),               /*签核优先等级                           */
rudsign     varchar2(4),             /*签核等级                               */
rudsmax     number(5),               /*应签核顺序                             */
rudsseq     number(5),               /*已签核顺序                             */
ruduser     varchar2(10),            /*资料所有者                             */
rudoriu     varchar2(10),            /*资料建立者                             */
rudorig     varchar2(10),            /*资料建立部门                           */
rud05       varchar2(10)             /*采购中心                               */
);

alter table rud_file add  constraint rud_pk primary key  (rud01) enable validate;
grant select on rud_file to tiptopgp;
grant update on rud_file to tiptopgp;
grant delete on rud_file to tiptopgp;
grant insert on rud_file to tiptopgp;
grant index on rud_file to public;
grant select on rud_file to ods;
