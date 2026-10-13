/*
================================================================================
檔案代號:rwr_file
檔案名稱:促销时间变更单单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rwr_file
(
rwr01       varchar2(20) DEFAULT ' ' NOT NULL, /*促销时间变更单号*/
rwr02       varchar2(10),            /*制定營運中心                           */
rwr03       varchar2(20),            /*活动代码                               */
rwr04       varchar2(1),             /*促销哦类型                             */
                                     /*Promotion Type                         */
                                     /*1:Special Product Price 2:Special Brand Class.  Price 3:Special Price-Interval Price */
                                     /*4:Assembly Promotion 6:Full Amount Promotion 9:Rebate Promotion*/
rwr05       varchar2(20),            /*促销单号                               */
rwr06       date,                    /*促销开始日期                           */
rwr07       date,                    /*促销结束日期                           */
rwr08       varchar2(8),             /*促销开始时间                           */
rwr09       varchar2(8),             /*促销结束时间                           */
rwr10       varchar2(1),             /*预设有效否                             */
rwr11       varchar2(255),           /*备注                                   */
rwr900      varchar2(1),             /*状况码                                 */
                                     /*Status Code                            */
                                     /*0:Open 1:Confirmed 9:Void R:Transfer for Approval S:Rejected W:Withdraw*/
rwracti     varchar2(1),             /*资料有效码                             */
rwrcond     date,                    /*审核日期                               */
rwrconf     varchar2(1),             /*审核码                                 */
rwrconu     varchar2(10),            /*审核人员                               */
rwrcrat     date,                    /*资料创建日                             */
rwrdate     date,                    /*最近更改日                             */
rwrdays     number(5),               /*签核完成天数                           */
rwrgrup     varchar2(10),            /*资料所有部门                           */
rwrlegal    varchar2(10) NOT NULL,   /*所属法人                               */
rwrmksg     varchar2(1),             /*是否签核                               */
rwrmodu     varchar2(10),            /*资料更改者                             */
rwrplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
rwrprit     number(5),               /*签核优先等级                           */
rwrsign     varchar2(4),             /*签核等级                               */
rwrsmax     number(5),               /*应签核顺序                             */
rwrsseq     number(5),               /*已签核顺序                             */
rwruser     varchar2(10),            /*资料所有者                             */
rwroriu     varchar2(10),            /*资料建立者                             */
rwrorig     varchar2(10)             /*资料建立部门                           */
);

alter table rwr_file add  constraint rwr_pk primary key  (rwr01) enable validate;
grant select on rwr_file to tiptopgp;
grant update on rwr_file to tiptopgp;
grant delete on rwr_file to tiptopgp;
grant insert on rwr_file to tiptopgp;
grant index on rwr_file to public;
grant select on rwr_file to ods;
