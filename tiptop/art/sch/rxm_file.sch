/*
================================================================================
檔案代號:rxm_file
檔案名稱:赠品发放/退还单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rxm_file
(
rxm00       varchar2(1) DEFAULT ' ' NOT NULL, /*单据类型 1:赠品发放 2:赠品退 */
                                     /*单据类型 1-赠品发放 2-赠品退还         */
rxm01       varchar2(20) DEFAULT ' ' NOT NULL, /*发放/退还单号*/
rxm02       date,                    /*单据日期                               */
rxm03       varchar2(1) DEFAULT ' ' NOT NULL, /*发放类型 1-消费领赠 2-来店礼 */
                                     /*Release Types 1-When Consuming 2-When Coming to Stores 3-Drawing*/
rxm04       varchar2(20),            /*顾客姓名                               */
rxm05       varchar2(20),            /*顾客电话                               */
rxm06       varchar2(10),            /*经办人员                               */
rxm07       varchar2(255),           /*備注                                   */
rxm900      varchar2(1) DEFAULT '0' NOT NULL, /*状况码*/
                                     /*Status Code                            */
                                     /*0:Open 1:Confirmed 9:Void R:Transfer for Approval S:Rejected W:Withdraw*/
rxmacti     varchar2(1) DEFAULT 'Y' NOT NULL, /*资料有效码*/
rxmcond     date,                    /*审核日期                               */
rxmconf     varchar2(1) DEFAULT ' ' NOT NULL, /*审核码*/
rxmconu     varchar2(10),            /*审核人员                               */
rxmcrat     date,                    /*资料创建日                             */
rxmdate     date,                    /*最近更改日                             */
rxmdays     number(5),               /*签核完成天数                           */
rxmgrup     varchar2(10),            /*资料所有部门                           */
rxmlegal    varchar2(10) NOT NULL,   /*所属法人                               */
rxmmksg     varchar2(1) DEFAULT ' ' NOT NULL, /*是否签核*/
rxmmodu     varchar2(10),            /*资料更改者                             */
rxmorig     varchar2(10),            /*资料建立部门                           */
rxmoriu     varchar2(10),            /*资料建立者                             */
rxmplant    varchar2(10) DEFAULT ' ' NOT NULL, /*所属营运中心*/
rxmprit     number(5),               /*签核优先等级                           */
rxmsign     varchar2(4),             /*签核等级                               */
rxmsmax     number(5),               /*应签核顺序                             */
rxmsswq     number(5),               /*已签核顺序                             */
rxmuser     varchar2(10),            /*资料所有者                             */
rxm08       varchar2(20)             /*赠品发放单号                           */
);

alter table rxm_file add  constraint rxm_pk primary key  (rxm00,rxm01,rxmplant) enable validate;
grant select on rxm_file to tiptopgp;
grant update on rxm_file to tiptopgp;
grant delete on rxm_file to tiptopgp;
grant insert on rxm_file to tiptopgp;
grant index on rxm_file to public;
grant select on rxm_file to ods;
