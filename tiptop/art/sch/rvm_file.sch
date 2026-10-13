/*
================================================================================
檔案代號:rvm_file
檔案名稱:配送分货单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rvm_file
(
rvm01       varchar2(20) DEFAULT ' ' NOT NULL, /*配送分货单号*/
rvm02       date,                    /*单据日期                               */
rvm03       varchar2(10),            /*配送中心                               */
rvm04       date,                    /*需求日期                               */
rvm05       varchar2(10),            /*线路编号                               */
rvm06       varchar2(1),             /*临时线路                               */
rvm07       varchar2(1),             /*自动派车否                             */
rvm08       varchar2(255),           /*备注                                   */
rvm09       varchar2(4000),          /*多角贸易序号                           */
rvm900      varchar2(1),             /*状况码                                 */
                                     /*Status Code                            */
                                     /*0:Open 1:Confirmed 9:Void R:Transfer for Approval S:Rejected W:Withdraw*/
rvmacti     varchar2(1),             /*资料有效码                             */
rvmcond     date,                    /*审核日期                               */
rvmconf     varchar2(1),             /*审核码                                 */
rvmconu     varchar2(10),            /*审核人员                               */
rvmcrat     date,                    /*资料创建日                             */
rvmdate     date,                    /*最近更改日                             */
rvmdays     number(5),               /*签核完成天数                           */
rvmgrup     varchar2(10),            /*资料所有部门                           */
rvmlegal    varchar2(10) NOT NULL,   /*所属法人                               */
rvmmksg     varchar2(1),             /*是否签核                               */
rvmmodu     varchar2(10),            /*资料更改者                             */
rvmplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
rvmprit     number(5),               /*签核优先等级                           */
rvmsign     varchar2(4),             /*签核等级                               */
rvmsmax     number(5),               /*应签核顺序                             */
rvmsseq     number(5),               /*已签核顺序                             */
rvmuser     varchar2(10),            /*资料所有者                             */
rvmoriu     varchar2(10),            /*资料建立者                             */
rvmorig     varchar2(10)             /*资料建立部门                           */
);

alter table rvm_file add  constraint rvm_pk primary key  (rvm01) enable validate;
grant select on rvm_file to tiptopgp;
grant update on rvm_file to tiptopgp;
grant delete on rvm_file to tiptopgp;
grant insert on rvm_file to tiptopgp;
grant index on rvm_file to public;
grant select on rvm_file to ods;
