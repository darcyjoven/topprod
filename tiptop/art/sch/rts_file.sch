/*
================================================================================
檔案代號:rts_file
檔案名稱:采购协议单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rts_file
(
rts01       varchar2(20) DEFAULT ' ' NOT NULL, /*协议编号*/
rts02       varchar2(10) DEFAULT ' ' NOT NULL, /*签订营运中心*/
rts03       number(5) DEFAULT '0' NOT NULL, /*协议版本号*/
rts04       varchar2(20),            /*合同编号                               */
rts05       varchar2(255),           /*备注                                   */
rts06       varchar2(4),             /*税种                                   */
rts07       number(9,4),             /*税率                                   */
rts900      varchar2(1),             /*状况码                                 */
                                     /*Status Code                            */
                                     /*0:Open 1:Confirmed 9:Void R:Transfer for Approval S:Rejected W:Withdraw*/
rtsacti     varchar2(1),             /*资料有效码                             */
rtscond     date,                    /*审核时间                               */
rtsconf     varchar2(1),             /*审核码                                 */
rtsconu     varchar2(10),            /*审核人员                               */
rtscrat     date,                    /*资料创建日                             */
rtsdate     date,                    /*最近更改日                             */
rtsdays     number(5),               /*签核完成天数                           */
rtsgrup     varchar2(10),            /*资料所有部门                           */
rtslegal    varchar2(10) NOT NULL,   /*所属法人                               */
rtsmksg     varchar2(1),             /*是否签核                               */
rtsmodu     varchar2(10),            /*资料更改者                             */
rtsplant    varchar2(10) DEFAULT ' ' NOT NULL, /*所属营运中心*/
rtsprit     number(5),               /*签核优先等级                           */
rtssign     varchar2(4),             /*签核等级                               */
rtssmax     number(5),               /*应签核顺序                             */
rtssseq     number(5),               /*已签核顺序                             */
rtsuser     varchar2(10),            /*资料所有者                             */
rtsoriu     varchar2(10),            /*资料建立者                             */
rtsorig     varchar2(10),            /*资料建立部门                           */
rts08       date,                    /*協議生效日期                           */
rts09       date                     /*協議終止日期                           */
);

alter table rts_file add  constraint rts_pk primary key  (rts01,rts02,rts03,rtsplant) enable validate;
grant select on rts_file to tiptopgp;
grant update on rts_file to tiptopgp;
grant delete on rts_file to tiptopgp;
grant insert on rts_file to tiptopgp;
grant index on rts_file to public;
grant select on rts_file to ods;
