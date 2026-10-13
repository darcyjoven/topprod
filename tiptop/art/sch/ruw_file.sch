/*
================================================================================
檔案代號:ruw_file
檔案名稱:盘点单/盘差单单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ruw_file
(
ruw00       varchar2(1) DEFAULT ' ' NOT NULL, /*单据别*/
                                     /*Document 1.Counting 2.Counting Diff.   */
ruw01       varchar2(20) DEFAULT ' ' NOT NULL, /*单据编号*/
ruw02       varchar2(20),            /*所属盘点计划                           */
ruw03       varchar2(20),            /*盘点/盘差单号                          */
ruw04       date,                    /*盘点日期                               */
ruw05       varchar2(10),            /*盘点仓库                               */
ruw06       varchar2(10),            /*盘点人员                               */
ruw07       varchar2(255),           /*備注                                   */
ruw08       varchar2(1),             /*库存调整否                             */
ruw09       date,                    /*调整日期                               */
ruw900      varchar2(1),             /*状况码                                 */
                                     /*Status Code                            */
                                     /*0:Open 1:Confirmed 9:Void R:Transfer for Approval S:Rejected W:Withdraw*/
ruwacti     varchar2(1),             /*资料有效码                             */
ruwcond     date,                    /*审核日期                               */
ruwconf     varchar2(1),             /*确认码                                 */
ruwcont     varchar2(8),             /*审核时间                               */
ruwconu     varchar2(10),            /*审核人员                               */
ruwcrat     date,                    /*资料创建日                             */
ruwdate     date,                    /*最近更改日                             */
ruwdays     number(5),               /*签核完成天数                           */
ruwgrup     varchar2(10),            /*资料所有部门                           */
ruwlegal    varchar2(10) NOT NULL,   /*所属法人                               */
ruwmksg     varchar2(1),             /*是否签核                               */
ruwmodu     varchar2(10),            /*资料更改者                             */
ruwplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
ruwpos      varchar2(1) DEFAULT '1', /*已传POS否                              */
ruwprit     number(5),               /*签核优先等级                           */
ruwsign     varchar2(4),             /*签核等级                               */
ruwsmax     number(5),               /*应签核顺序                             */
ruwsseq     number(5),               /*已签核顺序                             */
ruwuser     varchar2(10),            /*资料所有者                             */
ruworiu     varchar2(10),            /*资料建立者                             */
ruworig     varchar2(10),            /*资料建立部门                           */
ruw10       varchar2(20)             /*POS单号                                */
);

alter table ruw_file add  constraint ruw_pk primary key  (ruw00,ruw01) enable validate;
grant select on ruw_file to tiptopgp;
grant update on ruw_file to tiptopgp;
grant delete on ruw_file to tiptopgp;
grant insert on ruw_file to tiptopgp;
grant index on ruw_file to public;
grant select on ruw_file to ods;
