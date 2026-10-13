/*
================================================================================
檔案代號:rxa_file
檔案名稱:预收款退回单单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rxa_file
(
rxa01       varchar2(20) DEFAULT ' ' NOT NULL, /*退回单号*/
rxa02       varchar2(20),            /*订单单号                               */
rxa03       varchar2(10),            /*客户代码                               */
rxa04       number(20,6),            /*已冲金额                               */
rxa05       number(20,6),            /*已退金额                               */
rxa06       number(20,6),            /*可退金额                               */
rxa07       varchar2(255),           /*備注                                   */
rxa900      varchar2(1),             /*状况码                                 */
                                     /*Status Code                            */
                                     /*0:Open 1:Confirmed 9:Void R:Transfer for Approval S:Rejected W:Withdraw*/
rxaacti     varchar2(1),             /*资料有效码                             */
rxacond     date,                    /*审核日期                               */
rxaconu     varchar2(10),            /*审核人员                               */
rxacrat     date,                    /*资料创建日                             */
rxadate     date,                    /*最近更改日                             */
rxadays     number(5),               /*签核完成天数                           */
rxagrup     varchar2(10),            /*资料所有部门                           */
rxalegal    varchar2(10) NOT NULL,   /*所属法人                               */
rxamksg     varchar2(1),             /*是否签核                               */
rxamodu     varchar2(10),            /*资料更改者                             */
rxaplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
rxaprit     number(5),               /*签核优先等级                           */
rxasign     varchar2(4),             /*签核等级                               */
rxasmax     number(5),               /*应签核顺序                             */
rxasseq     number(5),               /*已签核顺序                             */
rxauser     varchar2(10),            /*资料所有者                             */
rxaconf     varchar2(1),             /*审核码                                 */
rxacont     varchar2(8),             /*审核时间                               */
rxaoriu     varchar2(10),            /*资料建立者                             */
rxaorig     varchar2(10),            /*资料建立部门                           */
rxa08       varchar2(20),            /*POS单号                                */
rxa09       date                     /*单据日期                               */
);

alter table rxa_file add  constraint rxa_pk primary key  (rxa01) enable validate;
grant select on rxa_file to tiptopgp;
grant update on rxa_file to tiptopgp;
grant delete on rxa_file to tiptopgp;
grant insert on rxa_file to tiptopgp;
grant index on rxa_file to public;
grant select on rxa_file to ods;
