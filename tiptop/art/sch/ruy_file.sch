/*
================================================================================
檔案代號:ruy_file
檔案名稱:盘点单变更单单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ruy_file
(
ruy01       varchar2(20) DEFAULT ' ' NOT NULL, /*盘点变更单号*/
ruy02       varchar2(20),            /*所属盘点计划                           */
ruy03       varchar2(20),            /*盘点单号                               */
ruy04       date,                    /*变更日期                               */
ruy05       date,                    /*盘点日期                               */
ruy06       varchar2(10),            /*盘点仓库                               */
ruy07       varchar2(10),            /*变更人员                               */
ruy08       varchar2(255),           /*備注                                   */
ruy900      varchar2(1),             /*状况码                                 */
                                     /*Status Code                            */
                                     /*0:Open 1:Confirmed 9:Void R:Transfer for Approval S:Rejected W:Withdraw*/
ruyacti     varchar2(1),             /*资料有效码                             */
ruycond     date,                    /*审核时间                               */
ruyconf     varchar2(1),             /*审核码                                 */
ruyconu     varchar2(10),            /*审核人员                               */
ruycrat     date,                    /*资料创建日                             */
ruydate     date,                    /*最近更改日                             */
ruydays     number(5),               /*签核完成天数                           */
ruygrup     varchar2(10),            /*资料所有部门                           */
ruymksg     varchar2(1),             /*是否签核                               */
ruymodu     varchar2(10),            /*资料更改者                             */
ruyplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
ruyprit     number(5),               /*签核优先等级                           */
ruysign     varchar2(4),             /*签核等级                               */
ruysmax     number(5),               /*应签核顺序                             */
ruysseq     number(5),               /*已签核顺序                             */
ruyuser     varchar2(10),            /*资料所有者                             */
ruylegal    varchar2(10) NOT NULL,   /*所属法人                               */
ruyorig     varchar2(10),            /*资料建立部门                           */
ruyoriu     varchar2(10)             /*资料建立者                             */
);

alter table ruy_file add  constraint ruy_pk primary key  (ruy01) enable validate;
grant select on ruy_file to tiptopgp;
grant update on ruy_file to tiptopgp;
grant delete on ruy_file to tiptopgp;
grant insert on ruy_file to tiptopgp;
grant index on ruy_file to public;
grant select on ruy_file to ods;
